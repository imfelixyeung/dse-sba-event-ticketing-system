import 'package:flutter/material.dart';
import '../apis/translations.dart';

void showChangeLogDialog(
    {BuildContext context, Map<String, String> applicationChangeLog}) {
  showDialog(
      context: context,
      child: new AlertDialog(
        actions: [
          FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(Translate.get('close')))
        ],
        title: new Text(Translate.get('changelog')),
        content: SingleChildScrollView(
          child: Column(
            children: [
              for (var log in applicationChangeLog.keys.toList().reversed)
                ListTile(
                  isThreeLine: true,
                  title: Text(log.toString()),
                  subtitle: Text(applicationChangeLog[log].toString()),
                )
            ],
          ),
        ),
      ));
}
