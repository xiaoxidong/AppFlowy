import 'package:appflowy_backend/protobuf/flowy-database/field_entities.pb.dart';
import 'package:flutter/material.dart';

import '../../../application/cell/cell_service.dart';
import 'board_cell.dart';
import 'board_checkbox_cell.dart';
import 'board_checklist_cell.dart';
import 'board_date_cell.dart';
import 'board_number_cell.dart';
import 'board_select_option_cell.dart';
import 'board_text_cell.dart';
import 'board_url_cell.dart';

abstract class BoardCellBuilderDelegate extends CellControllerBuilderDelegate {
  CellCache get cellCache;
}

class BoardCellBuilder {
  final BoardCellBuilderDelegate delegate;

  BoardCellBuilder(this.delegate);

  Widget buildCell(
    String groupId,
    CellIdentifier cellId,
    EditableCellNotifier cellNotifier,
  ) {
    final cellControllerBuilder = CellControllerBuilder(
      delegate: delegate,
      cellId: cellId,
      cellCache: delegate.cellCache,
    );

    final key = cellId.key();
    switch (cellId.fieldType) {
      case FieldType.Checkbox:
        return BoardCheckboxCell(
          groupId: groupId,
          cellControllerBuilder: cellControllerBuilder,
          key: key,
        );
      case FieldType.DateTime:
        return BoardDateCell(
          groupId: groupId,
          cellControllerBuilder: cellControllerBuilder,
          key: key,
        );
      case FieldType.SingleSelect:
        return BoardSelectOptionCell(
          groupId: groupId,
          cellControllerBuilder: cellControllerBuilder,
          key: key,
        );
      case FieldType.MultiSelect:
        return BoardSelectOptionCell(
          groupId: groupId,
          cellControllerBuilder: cellControllerBuilder,
          editableNotifier: cellNotifier,
          key: key,
        );
      case FieldType.Checklist:
        return BoardChecklistCell(
          cellControllerBuilder: cellControllerBuilder,
          key: key,
        );
      case FieldType.Number:
        return BoardNumberCell(
          groupId: groupId,
          cellControllerBuilder: cellControllerBuilder,
          key: key,
        );
      case FieldType.RichText:
        return BoardTextCell(
          groupId: groupId,
          cellControllerBuilder: cellControllerBuilder,
          editableNotifier: cellNotifier,
          key: key,
        );
      case FieldType.URL:
        return BoardUrlCell(
          groupId: groupId,
          cellControllerBuilder: cellControllerBuilder,
          key: key,
        );
    }
    throw UnimplementedError;
  }
}
