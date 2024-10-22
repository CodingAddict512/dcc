import 'package:dcc/data/repositories/metric_type_repository_interface.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:rxdart/rxdart.dart';

class MockMetricTypeRepository implements IMetricTypeRepository {
  BehaviorSubject<List<MetricType>> _metricTypesSubject;

  MockMetricTypeRepository({List<MetricType> metricTypes}) {
    _metricTypesSubject = BehaviorSubject<List<MetricType>>.seeded(metricTypes ?? []);
  }

  void updateMetricTypes(List<MetricType> metricTypes) => _metricTypesSubject.add(metricTypes);

  Stream<List<MetricType>> getMetricTypes() => _metricTypesSubject.stream;
}
