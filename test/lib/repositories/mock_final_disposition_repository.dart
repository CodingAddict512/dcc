import 'package:dcc/data/repositories/final_disposition_repository_interface.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:rxdart/rxdart.dart';

class MockFinalDispositionRepository implements IFinalDispositionRepository {
  BehaviorSubject<List<FinalDisposition>> _finalDispositionsSubject;

  MockFinalDispositionRepository({List<FinalDisposition> finalDispositions}) {
    _finalDispositionsSubject = BehaviorSubject<List<FinalDisposition>>.seeded(finalDispositions ?? []);
  }

  void updateFinalDispositions(List<FinalDisposition> finalDispositions) => _finalDispositionsSubject.add(finalDispositions);

  Stream<List<FinalDisposition>> getFinalDispositions() => _finalDispositionsSubject.stream;
}
