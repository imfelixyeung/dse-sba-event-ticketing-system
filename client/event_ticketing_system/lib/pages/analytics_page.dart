import 'dart:typed_data';

import 'package:event_ticketing_system/apis/ets.dart';
import 'package:event_ticketing_system/blocs/theme.dart';
import 'package:event_ticketing_system/constants/app_info.dart';
import 'package:event_ticketing_system/constants/route_names.dart';
import 'package:event_ticketing_system/misc/language.dart';
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
import 'package:flutter/services.dart';

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
                        Translate.get('analysis'),
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
                              pdfFileName: 'ets-analysis.pdf',
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

  Map report = await EtsAPI.getAnalysis();

  // final fontBase = await rootBundle.load('fonts/Roboto/Roboto-Regular.ttf');
  // final fontBold = await rootBundle.load('fonts/Roboto/Roboto-Bold.ttf');
  // final fontItalic = await rootBundle.load('fonts/Roboto/Roboto-Italic.ttf');

  pw.Widget _generateHeader(pw.Context context) {
    Map header = report['header'];

    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.Text(
            asciiOnly(Translate.get('${header['title']}')),
            style: const pw.TextStyle(
              fontSize: 18,
            ),
          ),
        ),
        pw.Container(
          height: 32,
          width: 192,
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(asciiOnly(Translate.get(
                    'name',
                    appLanguage: Languages.enGB.value,
                  ))),
                  pw.Text(asciiOnly('${header['user']['name']}')),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(asciiOnly(Translate.get(
                    'email',
                    appLanguage: Languages.enGB.value,
                  ))),
                  pw.Text(asciiOnly('${header['user']['email']}')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _generateFooter(pw.Context context) {
    Map footer = report['footer'];
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Container(
          height: 20,
          width: 100,
          child: pw.BarcodeWidget(
            barcode: pw.Barcode.pdf417(),
            data: '${footer['barcode']}',
          ),
        ),
        pw.Text(
          'Page ${context.pageNumber} of ${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  pw.Widget _generateTable(pw.Context context, List tableData) {
    final headers = tableData.removeAt(0);

    print({
      "TableHeaders": headers,
      "TableData": tableData,
    });

    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      // headerDecoration: pw.BoxDecoration(
      //   borderRadius: 2,
      //   color: baseColor,
      // ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.centerLeft,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
      },
      headerStyle: pw.TextStyle(
        // color: _baseTextColor,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        // color: _darkColor,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.BoxBorder(
          bottom: true,
          // color: accentColor,
          width: .5,
        ),
      ),
      headers: List<String>.generate(
          headers.length,
          (index) => asciiOnly(Translate.get(
                '${headers[index]}',
                appLanguage: Languages.enGB.value,
              ))),
      // headers: headers,
      data: List<List<String>>.generate(
        tableData.length,
        (row) => List<String>.generate(
          headers.length,
          (col) =>
              asciiOnly(truncateWithEllipsis(16, ('${tableData[row][col]}'))),
        ),
      ),
      // data: tableData,
    );
  }

  pdf.addPage(
    pw.MultiPage(
      pageFormat: pageFormat,
      header: _generateHeader,
      footer: _generateFooter,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          // pw.Text(
          //   '${Translate.get('event_ticketing_system')} ${Translate.get('analysis')} ${Translate.get('report')}',
          //   style: const pw.TextStyle(
          //     fontSize: 18,
          //   ),
          // ),
          if (report['body']['joined_events_table'] != null) ...[
            pw.Container(height: 16),
            pw.Text(asciiOnly(Translate.get(
              'joined_events',
              appLanguage: Languages.enGB.value,
            ))),
            _generateTable(context, report['body']['joined_events_table']),
            pw.Container(height: 16),
          ],
          if (report['body']['created_events_table'] != null) ...[
            pw.Container(height: 16),
            pw.Text(asciiOnly(Translate.get(
              'created_events',
              appLanguage: Languages.enGB.value,
            ))),
            _generateTable(context, report['body']['created_events_table']),
            pw.Container(height: 16),
          ],
          pw.Text(asciiOnly('Total: ${Translate.get(
            '\$',
            appLanguage: Languages.enGB.value,
          )}${report['body']['fee']}'))
        ];
      },
    ),
  );
  return pdf.save();
}

// Source: https://stackoverflow.com/questions/53359109/dart-how-to-truncate-string-and-add-ellipsis-after-character-number
String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

String asciiOnly(String target) {
  return target.replaceAll(RegExp("[^\\x00-\\x7F]"), "-");
}
