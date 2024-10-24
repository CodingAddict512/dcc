import 'dart:async';

import 'package:dcc/cubits/states/metric_type_state.dart';
import 'package:dcc/data/repositories/metric_type_repository_interface.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MetricTypeCubit extends Cubit<MetricTypeState> {
  final IMetricTypeRepository metricTypeRepository;
  StreamSubscription? listener;

  MetricTypeCubit({required this.metricTypeRepository})
      : super(MetricTypeStateInitial()) {
    this._setupStream();
  }

  factory MetricTypeCubit.fromContext(BuildContext context) => MetricTypeCubit(
        metricTypeRepository: context.read<IMetricTypeRepository>(),
      );

  void _setupStream() async {
    await listener!.cancel();
    listener = null;
    emit(MetricTypeStateLoading());
    listener = metricTypeRepository.getMetricTypes().listen((metricTypes) {
      if (metricTypes.isEmpty) {
        emit(MetricTypeStateNoMetrics());
        return;
      }

      state.ifState<MetricTypeStateLoaded>(withState: (s) {
        final newState = s.copyWith(
          metricTypes: metricTypes,
        );
        emit(newState);
      }, orElse: (s) {
        final newState = MetricTypeStateLoaded(
          metricTypes: metricTypes,
        );
        emit(newState);
      });
    });
  }

  MetricType metricTypeFromId(int id) {
    return state.ifState<MetricTypeStateLoaded>(
      withState: (state) {
        return state.metricTypes?.firstWhere(
          (mt) => mt.id == id,
          orElse: null,
        );
      },
      orElse: (state) => null,
    );
  }

  @override
  Future<void> close() async {
    await listener!.cancel();
    return super.close();
  }
}
