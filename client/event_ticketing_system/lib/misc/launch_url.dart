import 'package:url_launcher/url_launcher.dart';
// import 'dart:html';

void launchURL(String url) async {
  // if (!url.startsWith('https://') && !url.startsWith('http://')) {
  //   url = window.location.origin + url;
  // }
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    print('Failed to launch $url');
  }
}
