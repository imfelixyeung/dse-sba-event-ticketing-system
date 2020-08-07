import 'dart:convert';

import 'package:event_ticketing_system/apis/ets.dart';
import 'package:event_ticketing_system/blocs/theme.dart';
import 'package:event_ticketing_system/constants/register_requirements.dart';
import 'package:flutter/material.dart';
import '../apis/database.dart';
import '../apis/translations.dart';
import '../constants/page_titles.dart';
import '../widgets/app_scaffold.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController passwordTextEditingController = TextEditingController();
  bool loading = false;
  String accountTypeRadioGroup = 'participator';

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

  void handleRegister() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
    appUser.accessLevel = accountTypeRadioGroup;

    setState(() {
      loading = true;
    });
    var response = await appUser.register();
    setState(() {
      appUser = appUser;
    });
    if (appUser.authenticated) {
      await showSimpleDialog(Translate.get('register_success'));
      Navigator.of(context).pop();
      return;
    } else {
      await showSimpleDialog(response['error'] ?? 'An unknown error occured');
    }
    setState(() {
      loading = false;
    });
  }

  Widget _buildFirstName() {
    return TextFormField(
      onFieldSubmitted: (str) => handleRegister(),
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('first_name'),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return Translate.get('field_required');
        }
        if (value.length > RegisterRequirements.nameMax) {
          return Translate.get('err_too_long_max_format')
              .replaceFirst('%d', '${RegisterRequirements.nameMax}');
        }
      },
      onSaved: (String value) {
        appUser.firstName = value;
      },
    );
  }

  Widget _buildLastName() {
    return TextFormField(
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('last_name'),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return Translate.get('field_required');
        }
        if (value.length > RegisterRequirements.nameMax) {
          return Translate.get('err_too_long_max_format')
              .replaceFirst('%d', '${RegisterRequirements.nameMax}');
        }
      },
      onSaved: (String value) {
        appUser.lastName = value;
      },
    );
  }

  Widget _buildUsername() {
    return TextFormField(
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('username'),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return Translate.get('field_required');
        }
        if (value.length < RegisterRequirements.usernameMin ||
            value.length > RegisterRequirements.usernameMax) {
          return Translate.get('err_username_format')
              .replaceFirst('%d', '${RegisterRequirements.usernameMin}')
              .replaceFirst('%d', '${RegisterRequirements.usernameMax}');
        }
      },
      onSaved: (String value) {
        appUser.username = value;
      },
    );
  }

  Widget _buildDisplayName() {
    return TextFormField(
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('display_name'),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return Translate.get('field_required');
        }
        if (value.length > RegisterRequirements.nameMax) {
          return Translate.get('err_too_long_max_format')
              .replaceFirst('%d', '${RegisterRequirements.nameMax}');
        }
      },
      onSaved: (String value) {
        appUser.displayName = value;
      },
    );
  }

  Widget _buildEmail() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('email'),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return Translate.get('field_required');
        }
        // TODO Check Email
        var emailChecker = RegExp(r'^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w+)+$');
        if (!emailChecker.hasMatch(value)) {
          return Translate.get('err_email');
        }
      },
      onSaved: (String value) {
        appUser.email = value;
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      controller: passwordTextEditingController,
      obscureText: true,
      keyboardType: TextInputType.text,
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('password'),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return Translate.get('field_required');
        }
        if (value.length < RegisterRequirements.passwordMin ||
            value.length > RegisterRequirements.passwordMax) {
          return Translate.get('err_password_format')
              .replaceFirst('%d', '${RegisterRequirements.passwordMin}')
              .replaceFirst('%d', '${RegisterRequirements.passwordMax}');
        }
      },
      onSaved: (String value) {
        appUser.password = value;
      },
    );
  }

  Widget _buildConfirmPassword() {
    return TextFormField(
      obscureText: true,
      keyboardType: TextInputType.text,
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('confirm_password'),
      ),
      validator: (String value) {
        if (!(value == passwordTextEditingController.text))
          return Translate.get('err_password_no_match');
      },
    );
  }

  Widget _buildRadioParticipator() {
    return RadioListTile(
      groupValue: accountTypeRadioGroup,
      value: 'participator',
      activeColor: feliOrange,
      title: Text(Translate.get('participator')),
      onChanged: (t) {
        setState(() {
          accountTypeRadioGroup = t;
        });
      },
    );
  }

  Widget _buildRadioOrganiser() {
    return RadioListTile(
      groupValue: accountTypeRadioGroup,
      value: 'organiser',
      activeColor: feliOrange,
      title: Text(Translate.get('organiser')),
      onChanged: (t) {
        setState(() {
          accountTypeRadioGroup = t;
        });
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
                        Translate.get('register'),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(child: _buildFirstName(), flex: 1),
                                  Container(width: 16),
                                  Flexible(child: _buildLastName(), flex: 1)
                                ],
                              ),
                              Container(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(child: _buildUsername(), flex: 1),
                                  Container(width: 16),
                                  Flexible(child: _buildDisplayName(), flex: 1)
                                ],
                              ),
                              Container(height: 16),
                              _buildEmail(),
                              Container(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(child: _buildPassword(), flex: 1),
                                  Container(width: 16),
                                  Flexible(
                                      child: _buildConfirmPassword(), flex: 1)
                                ],
                              ),
                              Container(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      child: _buildRadioParticipator(),
                                      flex: 1),
                                  Container(width: 16),
                                  Flexible(
                                      child: _buildRadioOrganiser(), flex: 1)
                                ],
                              ),
                              Container(height: 16),
                              RaisedButton(
                                child: Text(Translate.get('submit')),
                                onPressed: !loading ? handleRegister : null,
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
