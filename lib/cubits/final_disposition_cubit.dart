import 'dart:async';

import 'package:dcc/cubits/states/final_disposition_state.dart';
import 'package:dcc/data/repositories/final_disposition_repository_interface.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class FinalDispositionCubit extends Cubit<FinalDispositionState> {
  final IFinalDispositionRepository finalDispositionRepository;
  StreamSubscription _listener;

  FinalDispositionCubit({@required this.finalDispositionRepository}) : super(FinalDispositionStateInitial()) {
    this._setupStream();
  }

  factory FinalDispositionCubit.fromContext(BuildContext context) => FinalDispositionCubit(
        finalDispositionRepository: context.read<IFinalDispositionRepository>(),
      );

  void selectFinalDisposition(FinalDisposition finalDisposition) {
    state.ifState<FinalDispositionStateLoaded>(withState: (state) {
      final loaded = state.copyWith(
        selectedFinalDisposition: finalDisposition,
      );
      emit(loaded);
    });
  }

  void discardSelectedFinalDisposition() {
    state.ifState<FinalDispositionStateLoaded>(withState: (state) {
      final loaded = state.copyWith(
        selectedFinalDisposition: null,
      );
      emit(loaded);
    });
  }

  void _setupStream() async {
    await _listener?.cancel();
    _listener = null;
    emit(FinalDispositionStateLoading());
    _listener = finalDispositionRepository.getFinalDispositions().listen((finalDispositions) {
      if (finalDispositions.isEmpty) {
        emit(FinalDispositionStateNoFinalDispositions());
        return;
      }
      Map<int, FinalDisposition> byId = Map.fromIterable(
        finalDispositions,
        key: (fd) => fd.id,
        value: (fd) => fd,
      );
      state.ifState<FinalDispositionStateLoaded>(withState: (s) {
        final newState = s.copyWith(
          dispositions: finalDispositions,
          id2disposition: byId,
          selectedFinalDisposition: s.selectedFinalDisposition,
        );
        emit(newState);
      }, orElse: (s) {
        final newState = FinalDispositionStateLoaded(
          dispositions: finalDispositions,
          id2disposition: byId,
          selectedFinalDisposition: null,
        );
        emit(newState);
      });
    });
  }

  FinalDisposition finalDispositionFromId(int id) {
    if (id == null) {
      return null;
    }

    return state.ifState<FinalDispositionStateLoaded>(
      withState: (state) {
        return state?.id2disposition[id];
      },
      orElse: (state) => null,
    );
  }

  @override
  Future<void> close() async {
    await _listener?.cancel();
    return super.close();
  }
}
