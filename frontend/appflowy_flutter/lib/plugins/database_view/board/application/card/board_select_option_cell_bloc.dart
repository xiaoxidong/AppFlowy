import 'dart:async';
import 'package:appflowy/plugins/database_view/application/cell/cell_service.dart';
import 'package:appflowy_backend/protobuf/flowy-database/select_type_option.pb.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'board_select_option_cell_bloc.freezed.dart';

class BoardSelectOptionCellBloc
    extends Bloc<BoardSelectOptionCellEvent, BoardSelectOptionCellState> {
  final SelectOptionCellController cellController;
  void Function()? _onCellChangedFn;

  BoardSelectOptionCellBloc({
    required this.cellController,
  }) : super(BoardSelectOptionCellState.initial(cellController)) {
    on<BoardSelectOptionCellEvent>(
      (event, emit) async {
        await event.when(
          initial: () async {
            _startListening();
          },
          didReceiveOptions: (List<SelectOptionPB> selectedOptions) {
            emit(state.copyWith(selectedOptions: selectedOptions));
          },
        );
      },
    );
  }

  @override
  Future<void> close() async {
    if (_onCellChangedFn != null) {
      cellController.removeListener(_onCellChangedFn!);
      _onCellChangedFn = null;
    }
    await cellController.dispose();
    return super.close();
  }

  void _startListening() {
    _onCellChangedFn = cellController.startListening(
      onCellChanged: ((selectOptionContext) {
        if (!isClosed) {
          add(BoardSelectOptionCellEvent.didReceiveOptions(
            selectOptionContext?.selectOptions ?? [],
          ));
        }
      }),
    );
  }
}

@freezed
class BoardSelectOptionCellEvent with _$BoardSelectOptionCellEvent {
  const factory BoardSelectOptionCellEvent.initial() = _InitialCell;
  const factory BoardSelectOptionCellEvent.didReceiveOptions(
    List<SelectOptionPB> selectedOptions,
  ) = _DidReceiveOptions;
}

@freezed
class BoardSelectOptionCellState with _$BoardSelectOptionCellState {
  const factory BoardSelectOptionCellState({
    required List<SelectOptionPB> selectedOptions,
  }) = _BoardSelectOptionCellState;

  factory BoardSelectOptionCellState.initial(
      SelectOptionCellController context) {
    final data = context.getCellData();
    return BoardSelectOptionCellState(
      selectedOptions: data?.selectOptions ?? [],
    );
  }
}
