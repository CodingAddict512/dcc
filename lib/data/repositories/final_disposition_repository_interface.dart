import 'package:dcc/models/final_disposition.dart';

abstract class IFinalDispositionRepository {
  Stream<List<FinalDisposition>> getFinalDispositions();
}
