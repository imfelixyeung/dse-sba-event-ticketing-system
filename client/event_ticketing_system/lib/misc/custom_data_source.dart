import 'package:flutter/material.dart';

class CustomDataSource extends DataTableSource {
  List<List<dynamic>> data;
  int _selectedCount = 0;
  Function onTap = (e) {};
  bool lastCellIsDouble;
  CustomDataSource(this.data, {this.onTap, this.lastCellIsDouble = false});
  DataRow getRow(int index) {
    final _case = data[index];

    return DataRow.byIndex(
        index: index,
        cells: _case
            .map((cell) => DataCell(
                    Text((lastCellIsDouble &&
                            cell is double &&
                            _case.indexOf(cell) == _case.length - 1)
                        ? cell.toStringAsFixed(3)
                        : cell.toString()), onTap: () {
                  onTap(_case);
                }))
            .toList());
  }

  int get rowCount => data.length;

  bool get isRowCountApproximate => false;

  int get selectedRowCount => _selectedCount;
}
