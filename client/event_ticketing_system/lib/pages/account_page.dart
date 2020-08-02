import 'package:event_ticketing_system/apis/ets.dart';
import 'package:event_ticketing_system/constants/route_names.dart';
import 'package:event_ticketing_system/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../apis/database.dart';
import '../apis/translations.dart';
import '../constants/page_titles.dart';
import '../widgets/app_scaffold.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool displayMobileLayout = deviceWidth < 600;

    return AppScaffold(
      pageTitle: PageTitles.home,
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: appUser.authenticated
                            ? [
                                Text(
                                  Translate.get('account'),
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                ListTile(
                                  title: Text(Translate.get('username')),
                                  subtitle: Text(appUser.username),
                                ),
                                ListTile(
                                  title: Text(Translate.get('display_name')),
                                  subtitle: Text(appUser.displayName),
                                ),
                                ListTile(
                                  title: Text(Translate.get('email')),
                                  subtitle: Text(appUser.email),
                                ),
                                ListTile(
                                  title: Text(Translate.get('first_name')),
                                  subtitle: Text(appUser.firstName),
                                ),
                                ListTile(
                                  title: Text(Translate.get('last_name')),
                                  subtitle: Text(appUser.lastName),
                                ),
                                ListTile(
                                  title: Text(Translate.get('account_type')),
                                  subtitle:
                                      Text(Translate.get(appUser.accessLevel)),
                                ),
                                RaisedButton(
                                  child: Text(Translate.get('logout')),
                                  onPressed: () {
                                    appUser.logout();
                                    setState(() {
                                      appUser = appUser;
                                    });
                                  },
                                ),
                              ]
                            : [
                                Text(
                                  Translate.get('account'),
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                RaisedButton(
                                  child: Text(Translate.get('login')),
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                        context, RouteNames.login);
                                    setState(() {
                                      appUser = appUser;
                                    });
                                  },
                                ),
                                RaisedButton(
                                  child: Text(Translate.get('register')),
                                  onPressed: () async {
                                    await Navigator.pushNamed(
                                        context, RouteNames.register);
                                    setState(() {
                                      appUser = appUser;
                                    });
                                  },
                                ),
                              ],
                      ),
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
