import 'package:event_ticketing_system/apis/translations.dart';
import 'package:flutter/material.dart';

Future<bool> showSimpleDialog(BuildContext context, String title) async {
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
    ),
  );
}
