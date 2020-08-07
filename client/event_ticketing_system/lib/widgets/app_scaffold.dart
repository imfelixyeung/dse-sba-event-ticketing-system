import 'package:flutter/material.dart';

import 'app_drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold(
      {@required this.body,
      @required this.pageTitle,
      this.floatingActionButton,
      this.actions,
      Key key})
      : super(key: key);

  final Widget body;
  final Widget floatingActionButton;
  final String pageTitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    return GestureDetector(
      onTap: () => unfocus(context),
      child: Row(
        children: [
          !displayMobileLayout
              ? AppDrawer(
                  permanentlyDisplay: true,
                  key: UniqueKey(),
                )
              : Container(),
          Expanded(
            child: Container(
              child: Scaffold(
                floatingActionButton: floatingActionButton,
                appBar: AppBar(
                  automaticallyImplyLeading: displayMobileLayout,
                  title: Text(pageTitle),
                  actions: actions,
                ),
                drawer: displayMobileLayout
                    ? AppDrawer(
                        permanentlyDisplay: false,
                        key: UniqueKey(),
                      )
                    : null,
                body: Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 1200),
                    child: body,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  unfocus(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
}
