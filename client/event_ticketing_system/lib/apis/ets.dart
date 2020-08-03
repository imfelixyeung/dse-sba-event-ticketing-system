import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

var endpoint = 'http://dynamic.felixyeung2002.com:8081';
// var endpoint = 'http://localhost:8081';

class EtsAPI {
  static Future<Map> login(User user) async {
    print('$endpoint/api/login/');
    var response = await http.post('$endpoint/api/login/',
        body: json.encode({"auth": user.toMap()}));
    return json.decode(response.body);
  }

  static Future<Map> register(User user) async {
    print('$endpoint/api/register/');
    var response = await http.post('$endpoint/api/register/',
        body: json.encode({"register": user.toMap()}));
    return json.decode(response.body);
  }

  static Future<List> getEvents() async {
    var response = await http.get('$endpoint/api/events/get');
    var jsonResponse = json.decode(response.body);
    return jsonResponse['data'];
  }
}

class FeliEvent {
  String id, organiser, name, description;
  int startTime, endTime, createdAt;
  String venue, theme;
  int participantLimit;
  List tickets, participants, waitingList;

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
}

class User {
  String username,
      password,
      displayName,
      email,
      firstName,
      lastName,
      accessLevel;
  List joinedEvents, pendingEvents, createdEvents;
  bool authenticated = false;
  User();

  importFromMap(Map userMap) {
    if (userMap == null) {
      authenticated = false;
      displayName = null;
      email = null;
      firstName = null;
      lastName = null;
      accessLevel = null;
      joinedEvents = null;
      pendingEvents = null;
      createdEvents = null;
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
    }
    return response;
  }

  Future<Map> register() async {
    var response = await EtsAPI.register(this);
    var userMap = response['data'];
    importFromMap(userMap);
    if (userMap != null) {
      importFromMap(userMap);
      authenticated = true;
    }
    return response;
  }

  logout() {
    importFromMap({});
    authenticated = false;
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

User appUser = User();

void main() async {
  appUser.username = 'FelixNPL';
  appUser.password = '20151529';
  await appUser.login();
  print('Authenticated: ${appUser.authenticated}');
}