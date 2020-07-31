import 'package:flutter/material.dart';

import 'app_drawer.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({@required this.body, @required this.pageTitle, Key key})
      : super(key: key);

  final Widget body;

  final String pageTitle;

  @override
  Widget build(BuildContext context) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    return Row(
      children: [
        !displayMobileLayout
            ? AppDrawer(
                permanentlyDisplay: true,
                key: UniqueKey(),
              )
            : Container(),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: displayMobileLayout,
              title: Text(pageTitle),
            ),
            drawer: displayMobileLayout
                ? AppDrawer(
                    permanentlyDisplay: false,
                    key: UniqueKey(),
                  )
                : null,
            body: body,
          ),
        )
      ],
    );
  }
}
