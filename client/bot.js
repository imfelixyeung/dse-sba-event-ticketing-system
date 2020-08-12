const Discord = require("discord.js");
const client = new Discord.Client();
const { DialogFlowAPI } = require("./src/dialogflow");
const { EtsAPI } = require("./src/ets");

const token = require("./.discord.json");

client.once("ready", () => {
    console.log("ETS Bot Ready");
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

    console.log({ requestUserId, requestMessage });
    console.log({ reply, action, allRequiredParamsPresent, fields });

    if (reply && reply != '') msg.reply(reply);

    if (action == actions.clearchat) {
        msg.delete();
        const fetched = await msg.channel.messages.fetch({
            limit: 99,
        });
        msg.channel.bulkDelete(fetched);
    }

    if (action == actions.getEventLength) {
        let events = await EtsAPI.getEvents();
        if (events) {
            msg.reply(`There is a total of ${events.length} events`);
        } else {
            msg.reply("An error occurred");
        }
        return;
    }

    if (action == actions.getEvents) {
        let events = await EtsAPI.getEvents();
        if (events) {
            msg.reply('\n' + EtsAPI.buildEventListInfo(events));
        } else {
            msg.reply("An error occurred");
        }
        return;
    }

    if (action == actions.getEventsRandom) {
        let events = await EtsAPI.getEvents();
        if (events) {
            if (events.length > 0) {
                let targetEvent =
                    events[Math.floor(Math.random() * events.length)];
                console.log(targetEvent)
                msg.reply("\n" + EtsAPI.buildEventInfo(targetEvent));
            } else {
                msg.reply('There are no events..')
            }
        } else {
            msg.reply("An error occurred");
        }
        return;
    }

    if (action == actions.getUserLength) {
        let events = await EtsAPI.getUsers();
        if (events) {
            msg.reply(`There is a total of ${events.length} users`);
        } else {
            msg.reply("An error occurred");
        }
        return;
    }

    if (action == actions.ping) {
        msg.reply(
            `Pong from Machine Learning Chat Bot! took ${responseDialogflowTime - requestTime}ms`
        );
        let events = await EtsAPI.ping();
        if (events) {
            const responseEtsTime = new Date();
            msg.reply(
                `Pong from Event Ticketing System! took ${
                    responseEtsTime -
                    requestTime -
                    (responseDialogflowTime - requestTime)
                }ms`
            );
        } else {
            msg.reply("Event Ticketing System is offline");
        }
        return;
    }
});

client.login(token);
