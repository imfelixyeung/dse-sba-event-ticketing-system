import 'package:event_ticketing_system/apis/translations.dart';
import 'package:event_ticketing_system/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:event_ticketing_system/apis/ets.dart';

class EventSearch extends SearchDelegate<String> {
  final List events;

  EventSearch(this.events);

  @override
  String get searchFieldLabel => Translate.get('search');

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      textTheme: theme.textTheme.copyWith(
          headline6: theme.textTheme.headline6.copyWith(
        color: theme.textTheme.bodyText1.color,
      )),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: Translate.get('clear'),
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
        tooltip: Translate.get('back'),
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
