import 'package:dcc/data/firestore/firestore_service.dart';
import 'package:dcc/data/repositories/metric_type_repository_interface.dart';
import 'package:dcc/models/metric_type.dart';

class MetricTypeRepository implements IMetricTypeRepository {
  Stream<List<MetricType>> getMetricTypes() => FirestoreService.metricTypesStream();
}
