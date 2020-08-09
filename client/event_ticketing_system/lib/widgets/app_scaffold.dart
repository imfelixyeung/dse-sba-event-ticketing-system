import 'package:flutter/material.dart';

import 'app_drawer.dart';

class AppScaffold extends StatelessWidget {
  AppScaffold(
      {@required this.body,
      @required this.pageTitle,
      this.floatingActionButton,
      this.actions,
      this.loading = false,
      Key key})
      : super(key: key);

  final Widget body;
  final Widget floatingActionButton;
  final String pageTitle;
  final List<Widget> actions;
  bool loading;

  @override
  Widget build(BuildContext context) {
    final bool displayMobileLayout = MediaQuery.of(context).size.width < 600;
    return GestureDetector(
      onTap: () => unfocus(context),
      child: Row(
        children: [
          !displayMobileLayout
              ? AppDrawer(
                  // loading: loading,
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
                        // loading: loading,
                        permanentlyDisplay: false,
                        key: UniqueKey(),
                      )
                    : null,
                body: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 1200),
                        child: body,
                      ),
                    ),
                    if (loading)
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(bottom: Radius.circular(4)),
                        child: SizedBox(
                          height: 4,
                          child: LinearProgressIndicator(),
                        ),
                      ),
                  ],
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
