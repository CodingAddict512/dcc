import 'package:dcc/data/firestore/firestore_service.dart';
import 'package:dcc/data/repositories/final_disposition_repository_interface.dart';
import 'package:dcc/models/final_disposition.dart';

class FinalDispositionRepository implements IFinalDispositionRepository {
  Stream<List<FinalDisposition>> getFinalDispositions() => FirestoreService.finalDispositionsStream();
}
