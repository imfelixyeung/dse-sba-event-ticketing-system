import 'package:event_ticketing_system/apis/ets.dart';
import 'package:event_ticketing_system/blocs/theme.dart';
import 'package:event_ticketing_system/constants/app_info.dart';
import 'package:event_ticketing_system/constants/route_names.dart';
import 'package:event_ticketing_system/misc/launch_url.dart';
import 'package:event_ticketing_system/misc/show_address_selector_dialog.dart';
import 'package:event_ticketing_system/misc/simple_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../apis/database.dart';
import '../apis/translations.dart';
import '../constants/page_titles.dart';
import '../widgets/app_scaffold.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({Key key}) : super(key: key);

  @override
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  bool loading = false;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _venueFocus = FocusNode();
  final FocusNode _themeFocus = FocusNode();
  final FocusNode _startTimeFocus = FocusNode();
  final FocusNode _endTimeFocus = FocusNode();
  final FocusNode _participantLimitFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var event = FeliEvent();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController venueController = TextEditingController();

  DateTime startDateTime;
  DateTime endDateTime;

  void handleCreation() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      loading = true;
    });

    var response = await EtsAPI.createEvent(event);

    if (response['status'] == 200) {
      await appUser.login();
      await showSimpleDialog(
          context, Translate.get('event_created_successfully'));
      Navigator.of(context).pop();
      return;
    } else {
      await showSimpleDialog(context,
          Translate.get(response['error']) ?? Translate.get('unknown_error'));
    }

    setState(() {
      loading = false;
    });
  }

  Widget _buildEventName() {
    return TextFormField(
      focusNode: _nameFocus,
      onFieldSubmitted: (str) => {_descriptionFocus.requestFocus()},
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('name'),
      ),
      validator: (String value) {
        if (value.length <= 0) return Translate.get('field_required');
      },
      onSaved: (String value) {
        event.name = value;
      },
    );
  }

  Widget _buildEventDescription() {
    return TextFormField(
      focusNode: _descriptionFocus,
      onFieldSubmitted: (str) => {_venueFocus.requestFocus()},
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('description'),
      ),
      validator: (String value) {
        if (value.length <= 0) return Translate.get('field_required');
      },
      onSaved: (String value) {
        event.description = value;
      },
    );
  }

  Widget _buildEventVenue() {
    return TextFormField(
      controller: venueController,
      focusNode: _venueFocus,
      onFieldSubmitted: (str) => {_themeFocus.requestFocus()},
      enabled: !loading,
      decoration: InputDecoration(
        suffixIcon: IconButton(
            icon: Icon(Icons.map),
            onPressed: () async {
              String address = await showAddressSelectorDialog(context);
              if (address != null) venueController.text = address;
            }),
        filled: true,
        labelText: Translate.get('venue'),
      ),
      validator: (String value) {
        if (value.length <= 0) return Translate.get('field_required');
      },
      onSaved: (String value) {
        event.venue = value;
      },
    );
  }

  Widget _buildEventTheme() {
    return TextFormField(
      focusNode: _themeFocus,
      onFieldSubmitted: (str) => {_startTimeFocus.requestFocus()},
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('theme'),
      ),
      validator: (String value) {
        if (value.length <= 0) return Translate.get('field_required');
      },
      onSaved: (String value) {
        event.theme = value;
      },
    );
  }

  Widget _buildEventStartTime() {
    return TextFormField(
      controller: startDateController,
      focusNode: _startTimeFocus,
      onFieldSubmitted: (str) => {_endTimeFocus.requestFocus()},
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('start_date_time'),
        suffixIcon: IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () async {
            var tempStartDate = await showDatePicker(
              context: context,
              initialDate:
                  startDateTime == null ? DateTime.now() : startDateTime,
              firstDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year + 10),
            );
            TimeOfDay tempStartTime;
            if (tempStartDate != null)
              tempStartTime = await showTimePicker(
                context: context,
                initialTime: startDateTime != null
                    ? TimeOfDay.fromDateTime(startDateTime)
                    : TimeOfDay.now(),
              );
            if (tempStartDate != null && tempStartTime != null) {
              startDateTime = new DateTime(
                tempStartDate.year,
                tempStartDate.month,
                tempStartDate.day,
                tempStartTime.hour,
                tempStartTime.minute,
              );
              setState(() {
                startDateTime = startDateTime;
                startDateController.text = DateFormat().format(startDateTime);
              });
            }
          },
        ),
      ),
      validator: (String value) {
        if (value.length <= 0) return Translate.get('field_required');
        if (startDateTime != null &&
            endDateTime != null &&
            startDateTime.microsecondsSinceEpoch >=
                endDateTime.microsecondsSinceEpoch)
          return Translate.get('date_time_conflict');
      },
      onSaved: (String value) {
        // event.startTime = startDateTime.microsecondsSinceEpoch;
        event.startTime = startDateTime.millisecondsSinceEpoch;
      },
    );
  }

  Widget _buildEventEndTime() {
    return TextFormField(
      controller: endDateController,
      focusNode: _endTimeFocus,
      onFieldSubmitted: (str) => {_participantLimitFocus.requestFocus()},
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('end_date_time'),
        suffixIcon: IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () async {
            var tempEndDate = await showDatePicker(
              context: context,
              initialDate: endDateTime == null ? DateTime.now() : endDateTime,
              firstDate: DateTime.now(),
              lastDate: DateTime(DateTime.now().year + 10),
            );
            TimeOfDay tempEndTime;
            if (tempEndDate != null)
              tempEndTime = await showTimePicker(
                context: context,
                initialTime: endDateTime != null
                    ? TimeOfDay.fromDateTime(endDateTime)
                    : TimeOfDay.now(),
              );
            if (tempEndDate != null && tempEndTime != null) {
              endDateTime = new DateTime(
                tempEndDate.year,
                tempEndDate.month,
                tempEndDate.day,
                tempEndTime.hour,
                tempEndTime.minute,
              );
              setState(() {
                endDateTime = endDateTime;
                endDateController.text = DateFormat().format(endDateTime);
              });
            }
          },
        ),
      ),
      validator: (String value) {
        if (value.length <= 0) return Translate.get('field_required');
        if (startDateTime != null &&
            endDateTime != null &&
            startDateTime.microsecondsSinceEpoch >=
                endDateTime.microsecondsSinceEpoch)
          return Translate.get('date_time_conflict');
      },
      onSaved: (String value) {
        event.endTime = endDateTime.millisecondsSinceEpoch;
      },
    );
  }

  Widget _buildEventParticipantLimit() {
    return TextFormField(
      focusNode: _participantLimitFocus,
      onFieldSubmitted: (str) => {handleCreation()},
      enabled: !loading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('participant_limit'),
      ),
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      validator: (String value) {
        if (value.length <= 0) return Translate.get('field_required');
      },
      onSaved: (String value) {
        event.participantLimit = int.tryParse(value);
      },
    );
  }

  Widget _buildTicket(Map ticket, int i) {
    return ListTile(
      title: Text('${ticket['type']}'),
      subtitle: Text('HK\$${ticket['fee']}'),
      trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline),
          onPressed: () {
            setState(() {
              event.tickets.removeAt(i);
            });
          }),
    );
  }

  Widget _buildTicketAdder() {
    List<Widget> ticketWidgets = [];

    for (var i = 0; i < event.tickets.length; i++) {
      ticketWidgets.add(_buildTicket(event.tickets[i], i));
    }

    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                Map newTicket = await showTicketCreatorDialog();
                if (newTicket != null) {
                  setState(() {
                    event.tickets.add(newTicket);
                  });
                }
              }),
          initiallyExpanded: true,
          title: Text(Translate.get('tickets')),
          children: [...ticketWidgets],
        ),
      ),
    );
  }

  Future<Map> showTicketCreatorDialog() async {
    Map ticket = {};

    final FocusNode _typeFocus = FocusNode();
    final FocusNode _feeFocus = FocusNode();

    final GlobalKey<FormState> _ticketFormKey = GlobalKey<FormState>();

    void handleTicketCreation() {}

    Widget _buildTicketType() {
      return TextFormField(
        focusNode: _typeFocus,
        onFieldSubmitted: (str) => {_feeFocus.requestFocus()},
        decoration: InputDecoration(
          filled: true,
          labelText: Translate.get('type'),
        ),
        validator: (String value) {
          if (value.length <= 0) return Translate.get('field_required');
        },
        onSaved: (String value) {
          ticket['type'] = value;
        },
      );
    }

    Widget _buildTicketFee() {
      return TextFormField(
        focusNode: _feeFocus,
        onFieldSubmitted: (str) => {handleTicketCreation()},
        decoration: InputDecoration(
          prefixText: 'HK\$',
          filled: true,
          labelText: Translate.get('fee'),
        ),
        inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
        validator: (String value) {
          if (value.length <= 0) return Translate.get('field_required');
        },
        onSaved: (String value) {
          ticket['fee'] = int.tryParse(value);
        },
      );
    }

    bool handleSubmit() {
      if (!_ticketFormKey.currentState.validate()) {
        return false;
      }
      _ticketFormKey.currentState.save();
      return true;
    }

    return await showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text(Translate.get('add_ticket')),
        content: Form(
          key: _ticketFormKey,
          child: Container(
            constraints: BoxConstraints(maxHeight: 192),
            child: Column(
              children: [
                _buildTicketType(),
                Container(height: 16),
                _buildTicketFee(),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(Translate.get('cancel')),
            onPressed: () {
              Navigator.of(context).pop(null);
            },
          ),
          FlatButton(
            child: Text(Translate.get('ok')),
            onPressed: () {
              if (handleSubmit()) Navigator.of(context).pop(ticket);
            },
          )
        ],
      ),
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
      pageTitle: PageTitles.createEvent,
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
                        Translate.get('create_event'),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(height: 16),
                              _buildEventName(),
                              Container(height: 16),
                              _buildEventDescription(),
                              Container(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(child: _buildEventVenue(), flex: 1),
                                  Container(width: 16),
                                  Flexible(child: _buildEventTheme(), flex: 1)
                                ],
                              ),
                              Container(height: 16),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                      child: _buildEventStartTime(), flex: 1),
                                  Container(width: 16),
                                  Flexible(child: _buildEventEndTime(), flex: 1)
                                ],
                              ),
                              Container(height: 16),
                              _buildEventParticipantLimit(),
                              Container(height: 16),
                              _buildTicketAdder(),
                              Container(height: 16),
                              RaisedButton(
                                child: Text(Translate.get('submit')),
                                onPressed: !loading ? handleCreation : null,
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
