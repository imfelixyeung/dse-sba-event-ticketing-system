const applicationVersion = 'dev-1.0.0';
const applicationImage = '/assets/icons/icon-192.png';

const Map<String, String> applicationChangeLog = {
  '0.0.0':
      'First developer build with without ETS, only simple Material Design',
  '0.0.1': 'Introduced Home page showing events',
  '0.0.2': 'Added accounts page for signing in and registration',
  '0.0.3': 'Added sign in page, accessible in accounts page',
  '0.0.4': 'Adeded register page, accessible in accounts page',
  '0.0.5': 'Implemented show events page',
  '0.0.6': 'Added joined events page',
  '0.0.7': 'Added created events page',
  '0.0.8': 'Added create event page accessible in created events page',
  '0.0.9': 'Added search function in home page',
  '0.1.0': 'Initial Release',
  '0.1.1': 'Analysis Page test',
  '0.1.2': 'Bug fixes',
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
