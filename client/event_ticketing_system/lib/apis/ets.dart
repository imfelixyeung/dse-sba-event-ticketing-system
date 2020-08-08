import 'dart:convert';
import 'package:event_ticketing_system/apis/database.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

var endpoint = 'http://dynamic.felixyeung2002.com';
// var endpoint = 'http://localhost:8081';

class EtsAPI {
  static Future<bool> ping() async {
    try {
      var response = await http.get('$endpoint/api/ping/');
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<Map> login(FeliUser user) async {
    var response = await http.post('$endpoint/api/login/',
        body: json.encode({"auth": user.toMap()}));
    return json.decode(response.body);
  }

  static Future<Map> register(FeliUser user) async {
    var response = await http.post('$endpoint/api/register/',
        body: json.encode({"register": user.toMap()}));
    return json.decode(response.body);
  }

  static Future<List> getEvents() async {
    var response = await http.get('$endpoint/api/events/get/');
    var jsonResponse = json.decode(response.body);
    return jsonResponse['data'];
  }

  static Future<Map> getEvent(String id) async {
    var response = await http.get('$endpoint/api/event/$id/get/');
    var jsonResponse = json.decode(response.body);
    return jsonResponse['data'];
  }

  static Future<Map> joinEvent(String eventId, String ticketId) async {
    var response = await http.post('$endpoint/api/event/$eventId/join/',
        body: json.encode({
          "ticket_id": ticketId,
          "auth": appUser.toMap(),
        }));
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static Future<Map> leaveEvent(String eventId) async {
    var response = await http.post('$endpoint/api/event/$eventId/leave/',
        body: json.encode({"auth": appUser.toMap()}));
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static Future<Map> removeEvent(String eventId) async {
    var response = await http.post('$endpoint/api/event/$eventId/remove/',
        body: json.encode({"auth": appUser.toMap()}));
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static Future<Map> createEvent(FeliEvent event) async {
    // http://localhost:8081/api/event/post/
    var response = await http.post('$endpoint/api/event/post/',
        body: json.encode({"auth": appUser.toMap(), "event": event.toMap()}));
    var jsonResponse = json.decode(response.body);
    return jsonResponse;
  }

  static Future shutdownServer() async {
    var response = await http.post('$endpoint/api/shutdown/',
        body: json.encode({"auth": appUser.toMap()}));
    var jsonResponse = json.decode(response.body);
    return jsonResponse['message'];
  }
}

class FeliEvent {
  String id, organiser, name, description;
  int startTime, endTime, createdAt;
  String venue, theme;
  int participantLimit;
  List tickets, participants, waitingList;

  FeliEvent() {
    tickets = [];
  }

  FeliEvent.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        organiser = json['organiser'],
        name = json['name'],
        description = json['description'],
        startTime = json['start_time'],
        endTime = json['end_time'],
        createdAt = json['created_at'],
        venue = json['venue'],
        theme = json['theme'],
        participantLimit = json['participant_limit'],
        tickets = json['tickets'],
        participants = json['participants'],
        waitingList = json['waiting_list'];

  Map toMap() {
    return {
      "name": name,
      "description": description,
      "venue": venue,
      "theme": theme,
      "tickets": tickets,
      "start_time": startTime,
      "end_time": endTime,
      "participant_limit": participantLimit
    };
  }
}

class FeliEventTicket {
  String id, type;
  int fee;

  FeliEventTicket() {}

  FeliEventTicket.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        type = json['type'],
        fee = json['fee'];
}

class FeliUser {
  String username,
      password,
      displayName,
      email,
      firstName,
      lastName,
      accessLevel;
  List joinedEvents, pendingEvents, createdEvents;
  bool authenticated = false;
  FeliUser() {
    joinedEvents = [];
    pendingEvents = [];
    createdEvents = [];
  }

  importFromMap(Map userMap) {
    if (userMap == null) {
      authenticated = false;
      displayName = null;
      email = null;
      firstName = null;
      lastName = null;
      accessLevel = null;
      joinedEvents = [];
      pendingEvents = [];
      createdEvents = [];
      return;
    }
    username = userMap['username'];
    displayName = userMap['display_name'];
    email = userMap['email'];
    firstName = userMap['first_name'];
    lastName = userMap['last_name'];
    accessLevel = userMap['access_level'];
    joinedEvents = userMap['joined_events'];
    pendingEvents = userMap['pending_events'];
    createdEvents = userMap['created_events'];
  }

  Future<Map> login() async {
    var response = await EtsAPI.login(this);
    var userMap = response['data'];
    if (userMap != null) {
      importFromMap(userMap);
      authenticated = true;
      Map<String, String> credentials = {
        "username": username,
        "password": password,
      };
      FeliStorageAPI.setUserCredentials(credentials);
    }
    return response;
  }

  Future<Map> register() async {
    var response = await EtsAPI.register(this);
    var userMap = response['data'];
    // importFromMap(userMap);
    if (userMap != null) {
      importFromMap(userMap);
      authenticated = true;
    }
    return response;
  }

  logout() {
    importFromMap({});
    authenticated = false;
    Map<String, String> temp = {};
    FeliStorageAPI.setUserCredentials(temp);
  }

  Future joinEvent(String eventId, String ticketId) async {
    var response = await EtsAPI.joinEvent(eventId, ticketId);
    return response;
  }

  Future leaveEvent(String eventId) async {
    var response = await EtsAPI.leaveEvent(eventId);
    return response;
  }

  Map toMap() {
    Map result = {
      "username": username ?? '',
      "password": password ?? '',
      "display_name": displayName ?? '',
      "email": email ?? '',
      "first_name": firstName ?? '',
      "last_name": lastName ?? '',
      "access_level": accessLevel ?? '',
    };
    if (joinedEvents != null) result['joined_events'] = joinedEvents;
    if (pendingEvents != null) result['pending_events'] = pendingEvents;
    if (createdEvents != null) result['created_events'] = createdEvents;
    return result;
  }
}

FeliUser appUser = FeliUser();

void main() async {
  appUser.username = 'FelixNPL';
  appUser.password = '20151529';
  await appUser.login();
  print('Authenticated: ${appUser.authenticated}');
}
