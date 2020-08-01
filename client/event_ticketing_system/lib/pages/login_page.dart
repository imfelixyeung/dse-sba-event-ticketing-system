import 'package:event_ticketing_system/apis/ets.dart';
import 'package:flutter/material.dart';
import '../apis/database.dart';
import '../apis/translations.dart';
import '../constants/page_titles.dart';
import '../widgets/app_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameInputController = TextEditingController();
  TextEditingController passwordInputController = TextEditingController();

  Future<bool> showSimpleDialog(String title) async {
    return await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text(title),
              actions: <Widget>[
                FlatButton(
                  child: Text(Translate.get('ok')),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  void handleLogin() async {
    user.username = usernameInputController.text;
    user.password = passwordInputController.text;
    await user.login();
    if (user.authenticated) {
      await showSimpleDialog(Translate.get('login_success_msg_format')
          .replaceAll('%s', user.displayName));
      Navigator.of(context).pop();
    } else {
      await showSimpleDialog(Translate.get('login_error_msg'));
    }
  }

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
                      Text(
                        Translate.get('login'),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(),
                      Container(height: 16),
                      TextField(
                          onSubmitted: (str) {},
                          controller: usernameInputController,
                          decoration: InputDecoration(
                              filled: true,
                              labelText: Translate.get('username'),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  usernameInputController.text = '';
                                },
                              ))),
                      Container(height: 16),
                      TextField(
                          onSubmitted: (str) {},
                          controller: passwordInputController,
                          decoration: InputDecoration(
                              filled: true,
                              labelText: Translate.get('password'),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  usernameInputController.text = '';
                                },
                              ))),
                      Container(height: 16),
                      RaisedButton(
                        child: Text(Translate.get('submit')),
                        onPressed: handleLogin,
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
