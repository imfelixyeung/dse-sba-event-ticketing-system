import 'dart:convert';
import 'dart:math';

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

class EditEventPage extends StatefulWidget {
  final String eventId;
  const EditEventPage(this.eventId, {Key key}) : super(key: key);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  bool initiateLoading = true;
  bool updateLoading = false;
  bool eventExist = false;
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();
  final FocusNode _venueFocus = FocusNode();
  final FocusNode _themeFocus = FocusNode();
  final FocusNode _startTimeFocus = FocusNode();
  final FocusNode _endTimeFocus = FocusNode();
  final FocusNode _participantLimitFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var event = FeliEvent();

  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController venueController = TextEditingController();
  TextEditingController themeController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TextEditingController participantLimitController = TextEditingController();

  DateTime startDateTime;
  DateTime endDateTime;

  Future fetchResource() async {
    var data = await EtsAPI.getEvent(widget.eventId);
    if (data != null) {
      event = FeliEvent.fromJson(data);
      setState(() {
        eventExist = true;
      });
    }
  }

  void handleCreation() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      updateLoading = true;
    });

    print(DateTime.now());
    print(JsonEncoder.withIndent(' ').convert(event.toMap()));

    var response = await EtsAPI.updateEvent(event);

    if (response['status'] == 200) {
      await appUser.login();
      await showSimpleDialog(
          context, Translate.get('event_updated_successfully'));
      Navigator.of(context).pop();
      return;
    } else {
      await showSimpleDialog(context,
          Translate.get(response['error']) ?? Translate.get('unknown_error'));
    }

    setState(() {
      updateLoading = false;
    });
  }

  Widget _buildEventName() {
    return TextFormField(
      controller: nameController,
      focusNode: _nameFocus,
      onFieldSubmitted: (str) => {_descriptionFocus.requestFocus()},
      enabled: !updateLoading,
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
      controller: descriptionController,
      focusNode: _descriptionFocus,
      onFieldSubmitted: (str) => {_venueFocus.requestFocus()},
      enabled: !updateLoading,
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
      enabled: !updateLoading,
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
      controller: themeController,
      focusNode: _themeFocus,
      onFieldSubmitted: (str) => {_startTimeFocus.requestFocus()},
      enabled: !updateLoading,
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
      enabled: !updateLoading,
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
              firstDate: DateTime.fromMillisecondsSinceEpoch([
                endDateTime.millisecondsSinceEpoch,
                startDateTime.millisecondsSinceEpoch,
                DateTime.now().millisecondsSinceEpoch
              ].reduce(min)),
              lastDate: DateTime.fromMillisecondsSinceEpoch([
                endDateTime.millisecondsSinceEpoch,
                startDateTime.millisecondsSinceEpoch,
                DateTime(DateTime.now().year + 10).millisecondsSinceEpoch
              ].reduce(max)),
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
      enabled: !updateLoading,
      decoration: InputDecoration(
        filled: true,
        labelText: Translate.get('end_date_time'),
        suffixIcon: IconButton(
          icon: Icon(Icons.date_range),
          onPressed: () async {
            var tempEndDate = await showDatePicker(
              context: context,
              initialDate: endDateTime == null ? DateTime.now() : endDateTime,
              firstDate: DateTime.fromMillisecondsSinceEpoch([
                endDateTime.millisecondsSinceEpoch,
                startDateTime.millisecondsSinceEpoch,
                DateTime.now().millisecondsSinceEpoch
              ].reduce(min)),
              lastDate: DateTime.fromMillisecondsSinceEpoch([
                endDateTime.millisecondsSinceEpoch,
                startDateTime.millisecondsSinceEpoch,
                DateTime(DateTime.now().year + 10).millisecondsSinceEpoch
              ].reduce(max)),
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
      controller: participantLimitController,
      focusNode: _participantLimitFocus,
      onFieldSubmitted: (str) => {handleCreation()},
      enabled: !updateLoading,
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
    );
  }

  Widget _buildTicketAdder() {
    List<Widget> ticketWidgets = [];

    for (var i = 0; i < event.tickets.length; i++) {
      ticketWidgets.add(_buildTicket(event.tickets[i], i));
    }

    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(Translate.get('tickets')),
        children: [...ticketWidgets],
      ),
    );
  }

  void core() async {
    await fetchResource();
    setState(() {
      initiateLoading = false;
    });
    if (eventExist) {
      nameController.text = event.name;
      descriptionController.text = event.description;
      venueController.text = event.venue;
      themeController.text = event.theme;

      startDateTime = DateTime.fromMillisecondsSinceEpoch(event.startTime);
      startDateController.text = DateFormat().format(startDateTime);

      endDateTime = DateTime.fromMillisecondsSinceEpoch(event.endTime);
      endDateController.text = DateFormat().format(endDateTime);

      participantLimitController.text = '${event.participantLimit}';
    }
  }

  @override
  void initState() {
    core();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      loading: updateLoading || initiateLoading,
      pageTitle: PageTitles.editEvent,
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
                    children: initiateLoading
                        ? [
                            Text('Loading'),
                          ]
                        : [
                            Text(
                              Translate.get('edit_event'),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            child: _buildEventVenue(), flex: 1),
                                        Container(width: 16),
                                        Flexible(
                                            child: _buildEventTheme(), flex: 1)
                                      ],
                                    ),
                                    Container(height: 16),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Flexible(
                                            child: _buildEventStartTime(),
                                            flex: 1),
                                        Container(width: 16),
                                        Flexible(
                                            child: _buildEventEndTime(),
                                            flex: 1)
                                      ],
                                    ),
                                    Container(height: 16),
                                    _buildEventParticipantLimit(),
                                    Container(height: 16),
                                    _buildTicketAdder(),
                                    Container(height: 16),
                                    RaisedButton(
                                      child: Text(Translate.get('update')),
                                      onPressed: !updateLoading
                                          ? handleCreation
                                          : null,
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
