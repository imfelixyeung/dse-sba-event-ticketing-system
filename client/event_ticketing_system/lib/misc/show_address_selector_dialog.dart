import 'package:event_ticketing_system/apis/address_suggestion.dart';
import 'package:event_ticketing_system/apis/translations.dart';
import 'package:flutter/material.dart';

Future<String> showAddressSelectorDialog(BuildContext context) async {
  return await showDialog(
    context: context,
    builder: (_) => new AddressSelectorDialog(),
  );
}

class AddressSelectorDialog extends StatefulWidget {
  @override
  _AddressSelectorDialogState createState() => _AddressSelectorDialogState();
}

class _AddressSelectorDialogState extends State<AddressSelectorDialog> {
  final GlobalKey<FormState> _addressFormKey = GlobalKey<FormState>();
  bool loading = false;
  List<String> suggested = [];

  void handleRequest(String uglyAddress) async {
    var tempSuggested = await AddressSuggestion.getSuggestions(uglyAddress);
    setState(() {
      suggested = [
        ...{...tempSuggested}
      ];
    });
  }

  Widget _buildSuggestions() {
    return Column(
      children: [
        ...suggested
            .map((e) => ListTile(
                  title: Text(e),
                  onTap: () {
                    Navigator.of(context).pop(e);
                  },
                ))
            .toList()
      ],
    );
  }

  Widget _buildAddress() {
    return TextFormField(
      onChanged: (str) => handleRequest(str),
      onFieldSubmitted: (str) => {},
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('address'),
      ),
      validator: (String value) {
        if (value.length <= 0) return Translate.get('field_required');
      },
      onSaved: (String value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: new Text(Translate.get('address_selector')),
      content: Form(
        key: _addressFormKey,
        child: Container(
          width: 350,
          height: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAddress(),
                Container(height: 16),
                _buildSuggestions(),
              ],
            ),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(Translate.get('ok')),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
