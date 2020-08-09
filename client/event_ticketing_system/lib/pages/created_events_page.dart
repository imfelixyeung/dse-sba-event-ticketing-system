import 'package:event_ticketing_system/apis/ets.dart';
import 'package:event_ticketing_system/blocs/theme.dart';
import 'package:event_ticketing_system/constants/app_info.dart';
import 'package:event_ticketing_system/constants/route_names.dart';
import 'package:event_ticketing_system/misc/launch_url.dart';
import 'package:event_ticketing_system/misc/simple_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../apis/database.dart';
import '../apis/translations.dart';
import '../constants/page_titles.dart';
import '../widgets/app_scaffold.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CreatedEventsPage extends StatefulWidget {
  const CreatedEventsPage({Key key}) : super(key: key);

  @override
  _CreatedEventsPageState createState() => _CreatedEventsPageState();
}

class _CreatedEventsPageState extends State<CreatedEventsPage> {
  bool loading = false;

  Map<String, FeliEvent> events = {};

  Future<bool> showEventRemovalConfirmationDialog() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Translate.get('event_remove_confirmtion_title')),
            content: Text(Translate.get('event_remove_confirmtion_subtitle')),
            actions: [
              FlatButton(
                child: Text(Translate.get('cancel')),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text(Translate.get('confirm')),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  void removeEvent(String eventId) async {
    if (!(await showEventRemovalConfirmationDialog())) return;
    setState(() {
      loading = true;
    });
    var response = await EtsAPI.removeEvent(eventId);
    await appUser.login();
    if (response['status'] == 200) {
      showSimpleDialog(context, Translate.get('event_remove_successfully'));
    } else {
      await showSimpleDialog(context,
          Translate.get(response['error']) ?? Translate.get('unknown_error'));
    }
    setState(() {
      appUser = appUser;
      loading = false;
    });
  }

  void getEventDetails(String eventId) async {
    if (events[eventId] != null) {
      return;
    }
    var response = await EtsAPI.getEvent(eventId);
    if (response != null) {
      FeliEvent event = FeliEvent.fromJson(response);
      setState(() {
        events[eventId] = event;
      });
    }
  }

  getEventTitle(String eventId) {
    if (events[eventId] != null) {
      return events[eventId].name;
    }
    return null;
  }

  Widget _buildEventListTile(event) {
    getEventDetails(event['event_id']);
    var eventName = getEventTitle(event['event_id']);
    return ListTile(
      title: Text(eventName != null ? eventName : '${event['event_id']}'),
      onTap: () {
        Navigator.of(context)
            .pushNamed(RouteNames.eventDetails + '/${event['event_id']}');
      },
      trailing: IconButton(
        icon: Icon(Icons.remove_circle_outline),
        onPressed: !loading ? () => removeEvent(event['event_id']) : null,
      ),
    );
  }

  Widget _buildCreatedEvents() {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ExpansionTile(
        leading: ExcludeSemantics(
          child: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            child: Text('${appUser.createdEvents.length}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.black)),
          ),
        ),
        initiallyExpanded: true,
        title: Text(Translate.get('created_events')),
        children: [
          ...appUser.createdEvents.map((event) {
            return _buildEventListTile(event);
          }).toList()
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
      floatingActionButton: FloatingActionButton.extended(
        label: Text(Translate.get('create_event')),
        icon: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed(RouteNames.createEvent);
        },
      ),
      pageTitle: PageTitles.createdEvents,
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
                      _buildCreatedEvents(),
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
