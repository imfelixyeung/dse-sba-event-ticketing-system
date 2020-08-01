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
                    children: user.authenticated
                        ? [
                            Text(
                              Translate.get('account'),
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            RaisedButton(
                              child: Text(Translate.get('signout')),
                              onPressed: () {
                                Navigator.pushNamed(context, RouteNames.login);
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
                              onPressed: () {
                                Navigator.pushNamed(context, RouteNames.login);
                              },
                            ),
                            RaisedButton(
                              child: Text(Translate.get('register')),
                              onPressed: () {
                                Navigator.pushNamed(context, RouteNames.login);
                              },
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
