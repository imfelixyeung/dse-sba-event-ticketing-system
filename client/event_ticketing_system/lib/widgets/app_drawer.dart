import 'package:event_ticketing_system/apis/ets.dart';
import 'package:flutter/material.dart';
import '../apis/translations.dart';
import '../blocs/theme.dart';

import '../constants/page_titles.dart';
import '../constants/route_names.dart';
import 'app_route_observer.dart';
import 'dart:math' as math;

/// The navigation drawer for the app.
/// This listens to changes in the route to update which page is currently been shown
class AppDrawer extends StatefulWidget {
  AppDrawer({@required this.permanentlyDisplay, this.loading = false, Key key})
      : super(key: key);

  final bool permanentlyDisplay;
  bool loading;
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> with RouteAware {
  String _selectedRoute;
  AppRouteObserver _routeObserver;

  final _listTileShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(32)));

  @override
  void initState() {
    super.initState();
    _routeObserver = AppRouteObserver();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    _routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    _updateSelectedRoute();
  }

  @override
  void didPop() {
    _updateSelectedRoute();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Row(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                AppBar(
                  leading: !widget.permanentlyDisplay
                      ? IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                      : null,
                  title: Text(Translate.get('event_ticketing_system')),
                ),
                if (widget.loading)
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: LinearProgressIndicator(),
                  ),
                if (!widget.loading) Container(height: 4),
                Divider(),
                FeliListTile(
                  _selectedRoute == RouteNames.home,
                  () async {
                    await _navigateTo(context, RouteNames.home);
                  },
                  PageTitles.home,
                  Icon(Icons.home),
                  widget.permanentlyDisplay,
                ),
                if (['admin', 'participator'].contains(appUser.accessLevel))
                  FeliListTile(
                    _selectedRoute == RouteNames.joinedEvents,
                    () async {
                      await _navigateTo(context, RouteNames.joinedEvents);
                    },
                    PageTitles.joinedEvents,
                    Icon(Icons.event_available),
                    widget.permanentlyDisplay,
                  ),
                if (['admin', 'organiser'].contains(appUser.accessLevel))
                  FeliListTile(
                    _selectedRoute == RouteNames.createdEvents,
                    () async {
                      await _navigateTo(context, RouteNames.createdEvents);
                    },
                    PageTitles.createdEvents,
                    Icon(Icons.event),
                    widget.permanentlyDisplay,
                  ),
                if (['admin', 'organiser', 'participator']
                    .contains(appUser.accessLevel))
                  FeliListTile(
                    _selectedRoute == RouteNames.analytics,
                    () async {
                      await _navigateTo(context, RouteNames.analytics);
                    },
                    PageTitles.analytics,
                    Icon(Icons.insert_chart),
                    widget.permanentlyDisplay,
                  ),
                Divider(thickness: 2),
                FeliListTile(
                  _selectedRoute == RouteNames.account,
                  () async {
                    await _navigateTo(context, RouteNames.account);
                  },
                  PageTitles.account,
                  Icon(Icons.account_circle),
                  widget.permanentlyDisplay,
                ),
                FeliListTile(
                  _selectedRoute == RouteNames.settings,
                  () async {
                    await _navigateTo(context, RouteNames.settings);
                  },
                  PageTitles.settings,
                  Icon(Icons.settings),
                  widget.permanentlyDisplay,
                ),
              ],
            ),
          ),
          // widget.permanentlyDisplay
          //     ? const VerticalDivider(width: 2)
          //     : Container()
        ],
      ),
    );
  }

  /// Closes the drawer if applicable (which is only when it's not been displayed permanently) and navigates to the specified route
  /// In a mobile layout, the a modal drawer is used so we need to explicitly close it when the user selects a page to display
  Future<void> _navigateTo(BuildContext context, String routeName) async {
    // if (!widget.permanentlyDisplay) {
    // }
    Navigator.pop(context);
    // await Navigator.pushReplacementNamed(context, routeName);
    // await Navigator.popAndPushNamed(context, routeName);
    await Navigator.pushNamed(context, routeName);
  }

  void _updateSelectedRoute() {
    setState(() {
      _selectedRoute = ModalRoute.of(context).settings.name;
    });
  }
}

class FeliListTile extends StatelessWidget {
  final bool _selected;
  final Function _onTap;
  final Widget _icon;
  final _listTileShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(32)));
  final String _pageTitle;
  final bool permanentlyDisplay;

  FeliListTile(this._selected, this._onTap, this._pageTitle, this._icon,
      this.permanentlyDisplay);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _selected
          ? BoxDecoration(
              borderRadius: permanentlyDisplay
                  ? BorderRadius.horizontal(right: Radius.circular(32))
                  : null,
              color: feliOrange.withAlpha(64),
            )
          : null,
      child: ListTile(
        shape: permanentlyDisplay ? _listTileShape : null,
        leading: _icon,
        title: Text(_pageTitle),
        onTap: _onTap,
        selected: _selected,
      ),
    );
  }
}
