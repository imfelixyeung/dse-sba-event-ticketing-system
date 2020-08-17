const Discord = require("discord.js");
const client = new Discord.Client();
const { DialogFlowAPI } = require("./src/dialogflow");
const { EtsAPI } = require("./src/ets");

const token = require("./.discord.json");

const express = require("express");
const app = express();

const port = 8082;

client.once("ready", () => {
    console.log("ETS Discord Bot Ready");
});

const etsGuildId = "741593546997628970";
const etsGuildChannelId = "741598820475076669";
const etsBotClientId = "741594110980259841";

const actions = {
    getEventLength: "ets.events.length.get",
    getEvents: "ets.events.get",
    getEventsRandom: "ets.events.random",
    getUserLength: "ets.users.length.get",
    ping: "ets.ping",
    clearchat: "ets.chat.clear",
};

client.on("message", async (msg) => {
    if (msg.guild.id !== etsGuildId) return;
    if (msg.channel.id !== etsGuildChannelId) return;
    if (msg.author.id === etsBotClientId) return;

    const requestMessage = msg.content.toString();
    const requestUserId = msg.author.id.toString();

    const responses = await getResponses({
        requestMessage: requestMessage,
        requestUserId: `web-${requestUserId}`,
    });
    responses.forEach((e) => msg.reply(e.toString()));
});

async function getResponses(
    { requestMessage, requestUserId },
    isDiscord = true
) {
    let responses = [];
    const requestTime = new Date();

    /* 
        Start of DialogFlowAPI
    */
    let {
        reply,
        action,
        allRequiredParamsPresent,
        fields,
    } = await DialogFlowAPI.getResponse({
        sessionId: requestUserId,
        text: requestMessage,
    });
    const responseDialogflowTime = new Date();

    // console.log({ requestUserId, requestMessage });
    // console.log({ reply, action, allRequiredParamsPresent, fields });

    if (reply && reply != "") responses.push(reply);

    // if (action == actions.clearchat) {
    //     msg.delete();
    //     const fetched = await msg.channel.messages.fetch({
    //         limit: 99,
    //     });
    //     msg.channel.bulkDelete(fetched);
    // }

    if (action == actions.getEventLength) {
        let events = await EtsAPI.getEvents();
        if (events) {
            responses.push(`There is a total of ${events.length} events`);
        } else {
            responses.push("An error occurred");
        }
        return responses;
    }

    if (action == actions.getEvents) {
        if (!isDiscord) {
            responses.push("Not supported");
            return responses;
        }
        let events = await EtsAPI.getEvents();
        if (events) {
            responses.push("\n" + EtsAPI.buildEventListInfo(events));
        } else {
            responses.push("An error occurred");
        }
        return responses;
    }

    if (action == actions.getEventsRandom) {
        if (!isDiscord) {
            responses.push("Not supported");
            return responses;
        }
        let events = await EtsAPI.getEvents();
        if (events) {
            if (events.length > 0) {
                let targetEvent =
                    events[Math.floor(Math.random() * events.length)];
                // console.log(targetEvent);
                responses.push("\n" + EtsAPI.buildEventInfo(targetEvent));
            } else {
                responses.push("There are no events..");
            }
        } else {
            responses.push("An error occurred");
        }
        return responses;
    }

    if (action == actions.getUserLength) {
        let events = await EtsAPI.getUsers();
        if (events) {
            responses.push(`There is a total of ${events.length} users`);
        } else {
            responses.push("An error occurred");
        }
        return responses;
    }

    if (action == actions.ping) {
        responses.push(
            `Pong from Machine Learning Chat Bot! took ${
                responseDialogflowTime - requestTime
            }ms`
        );
        let events = await EtsAPI.ping();
        if (events) {
            const responseEtsTime = new Date();
            responses.push(
                `Pong from Event Ticketing System! took ${
                    responseEtsTime -
                    requestTime -
                    (responseDialogflowTime - requestTime)
                }ms`
            );
        } else {
            responses.push("Event Ticketing System is offline");
        }
        return responses;
    }
    return responses;
}

app.get("/api/chatBot", async (req, res) => {
    let message = req.query.message;
    let id = req.query.id || Math.random().toString();
    if (!message || message.trim() == "") {
        res.send({
            error: "No body",
        });
        return;
    } else {
        let responses = await getResponses(
            { requestMessage: message, requestUserId: `web-${id}` },
            false
        );
        res.send({
            request: { message, id },
            response: responses,
        });
    }
});

app.listen(port, (_) => console.log(`Bot Listening on port ${port}`));

client.login(token);
