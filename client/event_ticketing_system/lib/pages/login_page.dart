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
  bool loading = false;

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
    setState(() {
      loading = true;
    });
    appUser.username = usernameInputController.text;
    appUser.password = passwordInputController.text;
    await appUser.login();
    if (appUser.authenticated) {
      await showSimpleDialog(Translate.get('login_success_msg_format')
          .replaceAll('%s', appUser.displayName));
      Navigator.of(context).pop();
    } else {
      await showSimpleDialog(Translate.get('login_error_msg'));
    }
    setState(() {
      loading = false;
    });
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
                        enabled: !loading,
                        onSubmitted: (str) => handleLogin(),
                        controller: usernameInputController,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: Translate.get('username'),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                usernameInputController.text = '';
                              },
                            )),
                      ),
                      Container(height: 16),
                      TextField(
                        enabled: !loading,
                        onSubmitted: (str) => handleLogin(),
                        controller: passwordInputController,
                        decoration: InputDecoration(
                            filled: true,
                            labelText: Translate.get('password'),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                usernameInputController.text = '';
                              },
                            )),
                        obscureText: true,
                      ),
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
