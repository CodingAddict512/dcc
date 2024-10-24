import 'package:dcc/models/metric_type.dart';

abstract class IMetricTypeRepository {
  Stream<List<MetricType>> getMetricTypes();
}
