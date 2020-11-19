const fetch = require("node-fetch");

const endpoint = "https://ets.feli.page";
var dateFormat = require("dateformat");

class EtsAPI {
    static async getEvents() {
        try {
            var response = await fetch(`${endpoint}/api/events/get/`);
            var json = await response.json();
            return json.data;
        } catch (error) {
            console.log(error);
            return null;
        }
    }

    static async getUsers() {
        try {
            var response = await fetch(`${endpoint}/api/users/get/`);
            var json = await response.json();
            return json.data;
        } catch (error) {
            console.log(error);
            return null;
        }
    }

    static async ping() {
        try {
            var response = await fetch(`${endpoint}/api/ping/`);
            var json = await response.json();
            return true;
        } catch (error) {
            return false;
        }
    }

    static buildEventInfo(event) {
        return `**${event["name"]}**
${event["description"]}
Organised by __${event["organiser"]}__
${dateFormat(new Date(event["start_time"]))} to ${dateFormat(
            new Date(event["end_time"])
        )}
${`${endpoint}/app/#/eventDetails/${event["id"]}`}
`;
    }
    static buildEventListInfo(events) {
        let result = '';
        for (var event of events) {
            result += this.buildEventInfo(event) + '\n';
        }
        return result
    }
}

async function test( 

) {
    var events = await EtsAPI.getEvents();
    console.log(EtsAPI.buildEventListInfo(events));
}

if (require.main === module) {
    test();
}

module.exports = { EtsAPI };
