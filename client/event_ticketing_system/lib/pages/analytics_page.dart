import 'dart:typed_data';

import 'package:event_ticketing_system/apis/ets.dart';
import 'package:event_ticketing_system/blocs/theme.dart';
import 'package:event_ticketing_system/constants/app_info.dart';
import 'package:event_ticketing_system/constants/route_names.dart';
import 'package:event_ticketing_system/misc/launch_url.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import '../apis/database.dart';
import '../apis/translations.dart';
import '../constants/page_titles.dart';
import '../widgets/app_scaffold.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class AnalyticsPage extends StatefulWidget {
  const AnalyticsPage({Key key}) : super(key: key);

  @override
  _AnalyticsPageState createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      pageTitle: PageTitles.analytics,
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
                      Text(
                        Translate.get('analytics'),
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Divider(),
                      Card(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height - 192,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              primaryColor: feliOrange,
                            ),
                            child: PdfPreview(
                              canChangePageFormat: false,
                              initialPageFormat: PdfPageFormat.a4,
                              useActions: true,
                              actions: [
                                // PdfPreviewAction(icon: Icon)
                                // PdfPreviewAction(
                                //     icon: Icon(Icons.insert_chart),
                                //     onPressed: (a, b, c) {}),
                              ],
                              pdfFileName: 'ets-analytics.pdf',
                              build: generateReport,
                              maxPageWidth: 700,
                            ),
                          ),
                        ),
                      ),
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

Future<Uint8List> generateReport(PdfPageFormat pageFormat) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      pageFormat: pageFormat,
      footer: _generateFooter,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Text(
            '${Translate.get('event_ticketing_system')} ${Translate.get('analysis')} ${Translate.get('report')}',
            style: const pw.TextStyle(
              fontSize: 18,
            ),
          ),
          pw.Text(pw.LoremText().sentence(512)),
          pw.Text(pw.LoremText().sentence(512)),
        ];
      },
    ),
  );
  return pdf.save();
}

pw.Widget _generateFooter(pw.Context context) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.center,
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      // pw.Container(
      //   height: 20,
      //   width: 100,
      //   child: pw.BarcodeWidget(
      //     barcode: pw.Barcode.pdf417(),
      //     data: appUser.username,
      //   ),
      // ),
      pw.Text(
        'Page ${context.pageNumber} of ${context.pagesCount}',
        style: const pw.TextStyle(
          fontSize: 12,
        ),
      ),
    ],
  );
}
