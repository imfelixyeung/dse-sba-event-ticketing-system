import '../misc/launch_url.dart';

class GoogleMapsAPI {
  static Function launchMapsLink(List<dynamic> _case) {
    String address = '${_case[0]} ${_case[1]}';
    address = address.replaceAll(' (非住宅)', '');
    address = address.replaceAll(' (non-residential)', '');

    var link = generateLink(address);
    launchURL(link);
    print(link);
  }

  static String generateLink(String address) {
    var encoded = Uri.encodeComponent(address);
    return 'https://www.google.com/maps?q=$encoded';
  }
}
