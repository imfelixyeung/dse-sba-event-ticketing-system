import 'dart:convert';
import 'package:http/http.dart' as http;

var endpoint = 'http://localhost:8081';

class EtsAPI {
  static Future<Map> login(User user) async {
    print('$endpoint/api/login/');
    var response = await http.post('$endpoint/api/login/',
        body: json.encode({"auth": user.toMap()}));
    return json.decode(response.body);
  }
}

class User {
  String username;
  String password;
  String displayName;
  String email;
  String firstName;
  String lastName;
  String accessLevel;
  List joinedEvents;
  List pendingEvents;
  List createdEvents;
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
    authenticated = true;
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

  Future login() async {
    var response = await EtsAPI.login(this);
    var userMap = response['data'];
    importFromMap(userMap);
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

User user = User();

void main() async {
  user.username = 'FelixNPL';
  user.password = '20151529';
  await user.login();
  print('Authenticated: ${user.authenticated}');
}
