import 'dart:async';

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
  final TextEditingController addressController = TextEditingController();
  bool loading = false;
  List<String> suggested = [];
  bool gettingSuggestions = false;
  Timer timer;
  String lastUglyAddress = '';

  void handleRequest(String uglyAddress) async {
    if (gettingSuggestions) return;
    if (lastUglyAddress == uglyAddress) return;
    gettingSuggestions = true;
    lastUglyAddress = uglyAddress;
    var tempSuggested = await AddressSuggestion.getSuggestions(uglyAddress);
    setState(() {
      suggested = [
        ...{...tempSuggested}
      ];
    });
    gettingSuggestions = false;
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
      controller: addressController,
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
  void initState() {
    super.initState();
    timer = Timer.periodic(new Duration(milliseconds: 250), (timer) {
      handleRequest(addressController.text);
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
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
