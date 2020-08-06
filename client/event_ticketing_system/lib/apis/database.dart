import 'dart:convert';

import 'package:hive/hive.dart';
// import 'package:hive_flutter/hive_flutter.dart';

const userBoxName = 'userBox';
const configBoxName = 'configBox';
const colorScheme = 'colorScheme';
const languageString = 'language';
const addressLookup = 'addressLookup';
const searchHistory = 'searchHistory';
const credentials = 'credentials';

final userBox = Hive.box(userBoxName);
final configBox = Hive.box(configBoxName);

class FeliStorageAPI {
  String getLanguage() {
    String lang = configBox.get(languageString, defaultValue: 'en-gb');
    return lang;
  }

  setLanguage(String language) {
    configBox.put(languageString, language);
  }

  String getColorScheme() {
    return configBox.get(colorScheme, defaultValue: 'automatic');
  }

  setColorScheme(String scheme) {
    configBox.put(colorScheme, scheme);
  }

  static List<String> getSearchHistory() {
    List<String> fallback = [];
    List result = configBox.get(searchHistory, defaultValue: fallback);
    return result.map((e) => e.toString()).toList();
    return result;
  }

  static setSearchHistory(List<String> history) {
    configBox.put(searchHistory, history);
  }

  static addSearchHistory(String item) {
    removeSearchHistory(item);
    var history = getSearchHistory();
    if (!history.contains(item)) history.insert(0, item);
    setSearchHistory(history);
  }

  static removeSearchHistory(String item) {
    var history = getSearchHistory();
    history.removeWhere((element) => element == item);
    setSearchHistory(history);
  }

  static Map<String, String> getUserCredentials() {
    var result = userBox.get(credentials, defaultValue: null);
    if (result != null) return new Map.from(result);
    return null;
  }

  static setUserCredentials(Map<String, String> cred) {
    userBox.put(credentials, cred);
  }
}
