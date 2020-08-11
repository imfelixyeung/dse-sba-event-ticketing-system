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
  bool loading = false;
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    setState(() {
      loading = true;
    });
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

  Widget _buildUsername() {
    return TextFormField(
      textInputAction: TextInputAction.next,
      focusNode: _usernameFocus,
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('username'),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return Translate.get('field_required');
        }
      },
      onSaved: (String value) {
        appUser.username = value;
      },
      onFieldSubmitted: (e) {
        _passwordFocus.requestFocus();
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      focusNode: _passwordFocus,
      obscureText: true,
      keyboardType: TextInputType.text,
      autocorrect: false,
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('password'),
      ),
      // validator: (String value) {},
      onSaved: (String value) {
        appUser.password = value;
      },
      onFieldSubmitted: (e) {
        handleLogin();
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      loading: loading,
      pageTitle: PageTitles.login,
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
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(height: 16),
                              _buildUsername(),
                              Container(height: 16),
                              _buildPassword(),
                              Container(height: 16),
                              RaisedButton(
                                child: Text(Translate.get('submit')),
                                onPressed: !loading ? handleLogin : null,
                              ),
                            ],
                          ))
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
