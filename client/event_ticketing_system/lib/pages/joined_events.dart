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

class JoinedEventsPage extends StatefulWidget {
  const JoinedEventsPage({Key key}) : super(key: key);

  @override
  _JoinedEventsPageState createState() => _JoinedEventsPageState();
}

class _JoinedEventsPageState extends State<JoinedEventsPage> {
  bool loading = false;

  leaveEvent(event) async {
    setState(() {
      loading = true;
    });
    String eventId = event['event_id'];
    await appUser.leaveEvent(eventId);
    await appUser.login();
    setState(() {
      appUser = appUser;
      loading = false;
    });
    showSimpleDialog(context, 'event_left');
  }

  Widget _buildEventListTile(event) {
    return ListTile(
      title: Text('${event['event_id']}'),
      trailing: IconButton(
        icon: Icon(Icons.remove_circle_outline),
        onPressed: !loading ? () => leaveEvent(event) : null,
      ),
    );
  }

  Widget _buildPendingEvents() {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ExpansionTile(
        leading: ExcludeSemantics(
          child: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            child: Text('${appUser.pendingEvents.length}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.black)),
          ),
        ),
        initiallyExpanded: true,
        title: Text(Translate.get('pending_events')),
        children: [
          ...appUser.pendingEvents.map((event) {
            _buildEventListTile(event);
          }).toList()
        ],
      ),
    );
  }

  Widget _buildJoinedEvents() {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ExpansionTile(
        leading: ExcludeSemantics(
          child: CircleAvatar(
            backgroundColor: Theme.of(context).accentColor,
            child: Text('${appUser.joinedEvents.length}',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.black)),
          ),
        ),
        initiallyExpanded: true,
        title: Text(Translate.get('joined_events')),
        children: [
          ...appUser.joinedEvents.map((event) {
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
                      _buildPendingEvents(),
                      Container(height: 16),
                      _buildJoinedEvents(),
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
