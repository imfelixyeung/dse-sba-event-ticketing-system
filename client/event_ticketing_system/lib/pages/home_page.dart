import 'package:event_ticketing_system/blocs/theme.dart';
import 'package:event_ticketing_system/constants/app_info.dart';
import 'package:event_ticketing_system/misc/launch_url.dart';
import 'package:flutter/material.dart';
import '../apis/database.dart';
import '../apis/translations.dart';
import '../constants/page_titles.dart';
import '../widgets/app_scaffold.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final bool displayMobileLayout = deviceWidth < 600;

    return AppScaffold(
      pageTitle: PageTitles.home,
      body: Center(
        child: Container(
          // constraints: BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Markdown(
                  styleSheet: MarkdownStyleSheet(
                      tableCellsDecoration:
                          BoxDecoration(color: Colors.transparent),
                      tableBorder: TableBorder.all(color: Colors.transparent),
                      p: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 16),
                      a: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(fontSize: 16, color: feliOrange),
                      blockquoteDecoration: BoxDecoration(
                          color: Colors.grey.withAlpha(64),
                          borderRadius: BorderRadius.circular(8.0))),
                  styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
                  data: applicationAboutText(),
                  onTapLink: (var link) {
                    launchURL(link);
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
