import 'package:http/http.dart' as http;
import 'dart:convert';

import 'database.dart';

class AddressSuggestion {
  static String convertSuggestionToAddress(String language, Map address) {
    try {
      var buildingName = address['BuildingName'];
      if (buildingName != null) return buildingName;
    } catch (e) {}
    try {
      var estateName = address['${language}Estate']['EstateName'];
      if (estateName != null) return estateName;
    } catch (e) {}
    return address['${language}Street']['StreetName'];
    return address.toString();
  }

  static Future<List<String>> getSuggestions(String query) async {
    Map<String, String> languageMapping = {
      "en-gb": "Eng",
      "zh-hk": "Chi",
    };
    try {
      String appLanguage = FeliStorageAPI().getLanguage() ?? 'en-gb';
      // String appLanguage = 'en-gb';
      String language = languageMapping[appLanguage];

      String endpoint = 'https://www.als.ogcio.gov.hk/lookup?q=$query&n=10';
      var response = await http.get(endpoint,
          headers: {"Accept": "application/json", "Accept-Language": "*"});
      var jsonResponse = json.decode(response.body);
      List detailedAddresses = jsonResponse['SuggestedAddress'];
      List addresses = detailedAddresses.map((e) {
        // print(e);
        return e['Address']['PremisesAddress']['${language}PremisesAddress'];
      }).toList();
      List<String> beautifulAddress = addresses
          .map((address) => convertSuggestionToAddress(language, address))
          .toList();
      return beautifulAddress;
    } catch (e) {
      return [];
    }
  }
}

// void main() async {
//   String query = 'Tsing Yi';
//   List suggestions = await AddressSuggestion.getSuggestions(query);
//   print(suggestions.join('\n'));
// }
