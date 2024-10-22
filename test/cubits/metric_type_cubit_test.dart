import 'package:bloc_test/bloc_test.dart';
import 'package:dcc/cubits/metric_type_cubit.dart';
import 'package:dcc/cubits/states/metric_type_state.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/async_bloc.dart';
import '../lib/repositories/mock_metric_type_repository.dart';

void main() {
  MetricType metricType = MetricType(id: 1);
  MetricType metricType2 = MetricType(id: 2);
  MockMetricTypeRepository mockMetricTypeRepository;

  loadedMetricTypeCubit() async {
    MetricTypeCubit metricTypeCubit = MetricTypeCubit(metricTypeRepository: mockMetricTypeRepository);
    await Future.delayed(const Duration(milliseconds: 50), () {});
    return metricTypeCubit;
  }

  setUp(() {
    mockMetricTypeRepository = MockMetricTypeRepository(metricTypes: [metricType]);
  });

  blocTest(
    'will load metric types on initialization',
    build: () => MetricTypeCubit(
      metricTypeRepository: MockMetricTypeRepository(metricTypes: [metricType]),
    ),
    expect: [
      MetricTypeStateLoading(),
      MetricTypeStateLoaded(metricTypes: [metricType]),
    ],
  );

  asyncBlocTest(
    'update metric types',
    build: () => loadedMetricTypeCubit(),
    act: (MetricTypeCubit metricTypeCubit) {
      mockMetricTypeRepository.updateMetricTypes([metricType, metricType2]);
      mockMetricTypeRepository.updateMetricTypes([metricType2]);
    },
    expect: [
      MetricTypeStateLoaded(metricTypes: [metricType, metricType2]),
      MetricTypeStateLoaded(metricTypes: [metricType2]),
    ],
  );

  blocTest(
    'metric type from id',
    build: () => MetricTypeCubit(
      metricTypeRepository: MockMetricTypeRepository(metricTypes: [metricType]),
    ),
    expect: [
      MetricTypeStateLoading(),
      MetricTypeStateLoaded(metricTypes: [metricType]),
    ],
    verify: (MetricTypeCubit metricTypeCubit) {
      expect(metricTypeCubit.metricTypeFromId(1), equals(metricType));
    },
  );
}
