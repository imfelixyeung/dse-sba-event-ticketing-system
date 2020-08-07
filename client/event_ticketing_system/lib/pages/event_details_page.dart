import 'package:event_ticketing_system/apis/ets.dart';
import 'package:event_ticketing_system/apis/whatsapp.dart';
import 'package:event_ticketing_system/blocs/theme.dart';
import 'package:event_ticketing_system/misc/launch_url.dart';
import 'package:event_ticketing_system/misc/simple_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../apis/database.dart';
import '../apis/translations.dart';
import '../constants/page_titles.dart';
import '../widgets/app_scaffold.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;
  const EventDetailsPage(this.eventId, {Key key}) : super(key: key);

  @override
  _EventDetailsPageState createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  bool loading = true;
  bool eventExist = false;
  FeliEvent feliEvent;
  List<FeliEventTicket> tickets = [];
  String ticketGroup = '';
  bool joinLoading = false;

  void joinEvent() async {
    setState(() {
      joinLoading = true;
    });
    if (ticketGroup == '') return;
    await appUser.joinEvent(widget.eventId, ticketGroup);
    await appUser.login();
    showSimpleDialog(context, Translate.get('event_joined_successfully'));
    setState(() {
      appUser = appUser;
      joinLoading = false;
    });

    // TODO: Implement Join Event
  }

  Future fetchResource() async {
    var data = await EtsAPI.getEvent(widget.eventId);
    if (data != null) {
      feliEvent = FeliEvent.fromJson(data);
      setState(() {
        eventExist = true;
      });

      List ticketsJson = data['tickets'];
      for (var ticketJson in ticketsJson) {
        try {
          tickets.add(FeliEventTicket.fromJson(ticketJson));
        } catch (e) {}
      }
    }
  }

  void core() async {
    await fetchResource();
    setState(() {
      loading = false;
    });
  }

  Widget _buildEventDetails() {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(Translate.get('event_info')),
        children: [
          ListTile(
            title: Text(Translate.get('name')),
            subtitle: Text('${feliEvent.name}'),
          ),
          ListTile(
            title: Text(Translate.get('description')),
            subtitle: Text('${feliEvent.description}'),
          ),
          ListTile(
            dense: true,
            title: Text(Translate.get('organiser')),
            subtitle: Text('${feliEvent.organiser}'),
          ),
          ListTile(
            dense: true,
            title: Text(Translate.get('start_date_time')),
            subtitle: Text(DateFormat().format(
                DateTime.fromMillisecondsSinceEpoch(feliEvent.startTime))),
          ),
          ListTile(
            dense: true,
            title: Text(Translate.get('end_date_time')),
            subtitle: Text(DateFormat().format(
                DateTime.fromMillisecondsSinceEpoch(feliEvent.endTime))),
          ),
          ListTile(
            dense: true,
            title: Text(Translate.get('venue')),
            subtitle: Text('${feliEvent.venue}'),
          ),
          ListTile(
            dense: true,
            title: Text(Translate.get('theme')),
            subtitle: Text('${feliEvent.theme}'),
          ),
          ListTile(
            dense: true,
            title: Text(Translate.get('participant_limit')),
            subtitle: Text('${feliEvent.participantLimit}'),
          ),
          ListTile(
            dense: true,
            title: Text(Translate.get('id')),
            subtitle: Text('${feliEvent.id}'),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTickets() {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(Translate.get('tickets')),
        children: tickets.map((ticket) {
          return ListTile(
            dense: true,
            title: Text('${ticket.type}'),
            subtitle: Text('HK\$${ticket.fee}'),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildRadioTicket(FeliEventTicket ticket) {
    return RadioListTile(
      groupValue: ticketGroup,
      value: ticket.id,
      activeColor: feliOrange,
      title: Text('${ticket.type}'),
      subtitle: Text('HK\$${ticket.fee}'),
      onChanged: (t) {
        setState(() {
          ticketGroup = t;
        });
      },
    );
  }

  Widget _buildJoinForm() {
    return Card(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(Translate.get('join_now')),
        children: [
          ...tickets.map((ticket) => _buildRadioTicket(ticket)).toList(),
          RaisedButton(
            child: Text(Translate.get('join')),
            onPressed: (ticketGroup != '' &&
                    ![...appUser.pendingEvents, ...appUser.joinedEvents]
                        .map((e) => e['event_id'])
                        .toList()
                        .contains(widget.eventId) &&
                    !joinLoading)
                ? joinEvent
                : null,
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    core();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      actions: [
        IconButton(
            icon: Icon(Icons.share),
            onPressed: eventExist
                ? () async {
                    var link = WhatsAppAPI.generateLink(
                        'http://dynamic.felixyeung2002.com/#/eventDetails/${widget.eventId}');
                    await launchURL(link);
                  }
                : null)
      ],
      pageTitle: PageTitles.eventDetails,
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
                    children: loading
                        ? [
                            Text('Looking for event ${widget.eventId}?'),
                            Text('Still loading...'), // TODO: Add translate
                          ]
                        : eventExist
                            ? [
                                _buildEventDetails(),
                                Container(height: 16),
                                if (!['admin', 'participator']
                                    .contains(appUser.accessLevel))
                                  _buildEventTickets(),
                                if (['admin', 'participator']
                                    .contains(appUser.accessLevel))
                                  _buildJoinForm(),
                              ]
                            : [
                                Text('Oh no..'),
                                Text(
                                    'Event with id ${widget.eventId} was not found!'),
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
