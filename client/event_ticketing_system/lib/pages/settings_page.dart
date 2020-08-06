import 'package:event_ticketing_system/misc/simple_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../apis/translations.dart';
import '../apis/whatsapp.dart';
import '../blocs/theme.dart';
import '../constants/app_info.dart';
import '../misc/language.dart';
import '../misc/launch_url.dart';
import '../misc/show_changelog_dialog.dart';
import '../widgets/greyed_out.dart';
import 'package:provider/provider.dart';
import '../apis/database.dart';
import '../apis/ets.dart';

import '../constants/page_titles.dart';
import '../widgets/app_scaffold.dart';

// import 'package:flutter/material.dart';

// import '../constants/page_titles.dart';
// import '../widgets/app_scaffold.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  List<String> colorSchemes = [
    'automatic',
    'light',
    'dark',
    'black',
  ];

  List<Language> languages = [
    Languages.enGB,
    Languages.zhHK,
  ];
  String selectedLanguage = FeliStorageAPI().getLanguage();
  String selectedColorScheme = FeliStorageAPI().getColorScheme();

  List<DropdownMenuItem<String>> colorSchemeDropdownItems;
  List<DropdownMenuItem<String>> languageDropdownItems;

  final _listTileShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)));

  List<DropdownMenuItem<String>> buildColorSchemeDropDownItems(
      List<String> colorSchemes) {
    List<DropdownMenuItem<String>> items = [];

    for (var scheme in colorSchemes) {
      items.add(DropdownMenuItem(
        value: scheme,
        child: Text(Translate.get(scheme)),
      ));
    }
    return items;
  }

  List<DropdownMenuItem<String>> buildlanguageDropDownItems(
      List<Language> colorSchemes) {
    List<DropdownMenuItem<String>> items = [];
    for (var language in languages) {
      items.add(DropdownMenuItem(
        value: language.value,
        child: Text(language.displayName),
      ));
    }
    return items;
  }

  @override
  void initState() {
    colorSchemeDropdownItems = buildColorSchemeDropDownItems(colorSchemes);
    languageDropdownItems = buildlanguageDropDownItems(languages);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final feliTheme = Provider.of<FeliThemeChanger>(context);

    return AppScaffold(
      pageTitle: PageTitles.settings,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        shape: _listTileShape,
                        leading: Icon(Icons.color_lens),
                        title: Text(Translate.get('color_scheme')),
                        trailing: DropdownButton(
                          underline: Container(),
                          value: selectedColorScheme,
                          items: colorSchemeDropdownItems,
                          onChanged: (value) {
                            feliTheme.setTheme();
                            FeliStorageAPI().setColorScheme(value);
                            setState(() {
                              selectedColorScheme = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        shape: _listTileShape,
                        leading: Icon(Icons.language),
                        title: Text(Translate.get('language')),
                        trailing: DropdownButton(
                          underline: Container(),
                          value: selectedLanguage,
                          items: languageDropdownItems,
                          onChanged: (value) {
                            FeliStorageAPI().setLanguage(value);
                            feliTheme.setTheme();
                            setState(() {
                              selectedLanguage = value;

                              colorSchemeDropdownItems =
                                  buildColorSchemeDropDownItems(colorSchemes);
                              languageDropdownItems =
                                  buildlanguageDropDownItems(languages);
                            });
                          },
                        ),
                      ),
                      ListTile(
                          shape: _listTileShape,
                          leading: Icon(Icons.info),
                          title: Text(Translate.get('about')),
                          onTap: () async {
                            showAboutDialog(
                              context: context,
                              applicationVersion: applicationVersion,
                              applicationIcon: Container(
                                constraints: BoxConstraints(
                                    maxWidth: 48.0, maxHeight: 48.0),
                                child: Image.network(applicationImage),
                              ),
                              children: [],
                            );
                          }),
                      ListTile(
                          shape: _listTileShape,
                          leading: Icon(Icons.history),
                          title: Text(Translate.get('changelog')),
                          onTap: () async {
                            showChangeLogDialog(
                                context: context,
                                applicationChangeLog: applicationChangeLog);
                          }),
                      ListTile(
                          shape: _listTileShape,
                          leading: FaIcon(FontAwesomeIcons.whatsapp),
                          title: Text(Translate.get('share_on_whatsapp')),
                          onTap: () async {
                            var link = WhatsAppAPI.generateLink(
                                applicationShareText());
                            await launchURL(link);
                          }),
                      ListTile(
                          shape: _listTileShape,
                          leading: FaIcon(FontAwesomeIcons.instagram),
                          title: Text(Translate.get('contact_me')),
                          onTap: () async {
                            await launchURL(
                                'https://www.instagram.com/im.feli.page/');
                          }),
                      ListTile(
                          shape: _listTileShape,
                          leading: Image.network(
                              'assets/images/bmc-new-btn-logo.svg'),
                          // leading: FaIcon(FontAwesomeIcons.cup),
                          title: Text(Translate.get('buy_coffee')),
                          onTap: () async {
                            await launchURL(
                                'https://www.buymeacoffee.com/iWuHsKU');
                          }),
                      if (appUser.authenticated &&
                          appUser.accessLevel == 'admin')
                        Divider(),
                      if (appUser.authenticated &&
                          appUser.accessLevel == 'admin')
                        ListTile(
                            shape: _listTileShape,
                            leading: Icon(Icons.replay),
                            // leading: FaIcon(FontAwesomeIcons.cup),
                            title: Text(Translate.get('restart_server')),
                            onTap: () async {
                              var message = await EtsAPI.shutdownServer();
                              await showSimpleDialog(
                                  context, Translate.get('$message'));
                              var ping = false;
                              while (!ping) {
                                ping = await EtsAPI.ping();
                                if (ping) {
                                  await showSimpleDialog(context,
                                      Translate.get('server_back_online'));
                                } else {
                                  await new Future.delayed(
                                      const Duration(seconds: 1));
                                }
                              }
                            }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
