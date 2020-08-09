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
    getUserLength: "ets.users.length.get",
    ping: "ets.ping",
};

client.on("message", async (msg) => {
    if (msg.guild.id !== etsGuildId) return;
    if (msg.channel.id !== etsGuildChannelId) return;
    if (msg.author.id === etsBotClientId) return;

    const requestMessage = msg.content.toString();
    const requestUserId = msg.author.id.toString();
    const requestTime = new Date();

    if (requestMessage.startsWith('.')) {
        if (requestMessage.startsWith(".clearchat")) {
            msg.delete();
            const fetched = await msg.channel.messages.fetch({
                limit: 99,
            });
            msg.channel.bulkDelete(fetched);

        } return;
    }

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

    msg.reply(reply);

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
