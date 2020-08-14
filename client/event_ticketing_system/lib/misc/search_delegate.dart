import 'package:event_ticketing_system/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:event_ticketing_system/apis/ets.dart';

class EventSearch extends SearchDelegate<String> {
  final List events;

  EventSearch(this.events);

  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List filteredEvents = query.isEmpty
        ? events
        : events.where((element) {
            String lowered = query.toLowerCase();
            bool queryInName =
                element['name'].toString().toLowerCase().contains(lowered);
            bool queryInDesc = element['description']
                .toString()
                .toLowerCase()
                .contains(lowered);
            bool queryInVenue =
                element['venue'].toString().toLowerCase().contains(lowered);
            bool queryInTheme =
                element['theme'].toString().toLowerCase().contains(lowered);
            return queryInName || queryInDesc || queryInVenue || queryInTheme;
          }).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          ...filteredEvents.map((event) {
            return Container(
              constraints: BoxConstraints(maxWidth: 600),
              child: ListTile(
                title: Text(event['name'].toString()),
                onTap: () async {
                  close(context, event['id']);
                  Navigator.of(context)
                      .pushNamed(RouteNames.eventDetails + '/${event['id']}');
                },
              ),
            );
          }).toList(),
          ListTile(dense: true),
        ],
      ),
    );
  }
}
