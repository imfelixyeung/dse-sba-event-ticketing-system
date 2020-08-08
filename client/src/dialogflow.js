const serviceAccount = require("./ets-bxok-fc31bc4e01b8.json");
const { SessionsClient } = require("dialogflow");

class DialogFlowAPI {
    static async getResponse({ sessionId, text }) {
        const sessionClient = new SessionsClient({
            credentials: serviceAccount,
        });
        const session = sessionClient.sessionPath("ets-bxok", sessionId);
        
        const request = {
            session: session,
            queryInput: {
                text: {
                    text: text,
                    languageCode: "en-US",
                },
            },
        };

        var response;
        try {
            response = await sessionClient.detectIntent(request);
        } catch (error) {
            console.log({ error });
        }
        if (!response) return;

        // console.log(JSON.stringify(response, null, 4));


        const result = response[0].queryResult;
        let messages = result.fulfillmentMessages;
        const reply = messages[0].text.text.join("\n");
        const action = result.action;
        const fields = result.parameters.fields;
        const allRequiredParamsPresent = result.allRequiredParamsPresent;
        return { reply, action, allRequiredParamsPresent, fields };
    }
}

// async function main() {
//     let response = await DialogFlowAPI.getResponse({
//         sessionId: "foo",
//         text: "Hello",
//     });
//     console.log(response);
//     console.log(response[0].text.text.join("\n"));
// }

// main();

module.exports = { DialogFlowAPI };
