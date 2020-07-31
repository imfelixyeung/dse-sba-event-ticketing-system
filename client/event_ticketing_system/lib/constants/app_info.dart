const applicationVersion = 'dev-1.0.0';
const applicationImage = '/assets/icons/icon-192.png';

const Map<String, String> applicationChangeLog = {
  'dev-1.0.0': 'First developer build with without ETS',
};

String applicationAboutText() {
  return '''
# Event Ticketing System

## Site under construction

Have a look at the [documentation](/docs/)

Visit other sites in the meantime

* [Covid HK](https://covidhk.feli.page/)
* [Next Train](https://nexttrain.feli.page/)
* [URL Shortener](https://url.feli.page/)


[logo]: /favicon.png "ETS Logo"


![ETS Icon](/favicon.png)


  ''';
}

String applicationShareText() {
  return '''Event Ticketing System''';
}
