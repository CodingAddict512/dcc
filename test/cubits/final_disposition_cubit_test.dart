import 'package:bloc_test/bloc_test.dart';
import 'package:dcc/cubits/final_disposition_cubit.dart';
import 'package:dcc/cubits/states/final_disposition_state.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/async_bloc.dart';
import '../lib/repositories/mock_final_disposition_repository.dart';

void main() {
  FinalDisposition finalDisposition = FinalDisposition(id: 1);
  FinalDisposition finalDisposition2 = FinalDisposition(id: 2);
  MockFinalDispositionRepository mockFinalDispositionRepository;

  Map<int, FinalDisposition> getId2Disposition(Iterable<FinalDisposition> dispositions) {
    return Map.fromIterable(
      dispositions,
      key: (fd) => fd.id,
      value: (fd) => fd,
    );
  }

  loadedFinalDispositionCubit() async {
    FinalDispositionCubit finalDispositionCubit = FinalDispositionCubit(
      finalDispositionRepository: mockFinalDispositionRepository,
    );
    await Future.delayed(const Duration(milliseconds: 50), () {});
    return finalDispositionCubit;
  }

  setUp(() {
    mockFinalDispositionRepository = MockFinalDispositionRepository(finalDispositions: [finalDisposition]);
  });

  blocTest(
    'will load final dispositions on initialization',
    build: () => FinalDispositionCubit(
      finalDispositionRepository: MockFinalDispositionRepository(finalDispositions: [finalDisposition]),
    ),
    expect: [
      FinalDispositionStateLoading(),
      FinalDispositionStateLoaded(
        id2disposition: getId2Disposition([finalDisposition]),
        dispositions: [finalDisposition],
      ),
    ],
  );

  asyncBlocTest(
    'update final disposition',
    build: () => loadedFinalDispositionCubit(),
    act: (FinalDispositionCubit finalDispositionCubit) {
      mockFinalDispositionRepository.updateFinalDispositions([finalDisposition, finalDisposition2]);
      mockFinalDispositionRepository.updateFinalDispositions([finalDisposition2]);
    },
    expect: [
      FinalDispositionStateLoaded(
        id2disposition: getId2Disposition([finalDisposition, finalDisposition2]),
        dispositions: [finalDisposition, finalDisposition2],
      ),
      FinalDispositionStateLoaded(
        id2disposition: getId2Disposition([finalDisposition2]),
        dispositions: [finalDisposition2],
      ),
    ],
  );

  FinalDisposition sameId = finalDisposition.copyWith(type: 'someType');
  asyncBlocTest(
    'update final disposition with same id',
    build: () => loadedFinalDispositionCubit(),
    act: (FinalDispositionCubit finalDispositionCubit) {
      mockFinalDispositionRepository.updateFinalDispositions([sameId]);
    },
    expect: [
      FinalDispositionStateLoaded(
        id2disposition: getId2Disposition([sameId]),
        dispositions: [sameId],
      ),
    ],
  );

  asyncBlocTest(
    'select final disposition',
    build: () => loadedFinalDispositionCubit(),
    act: (FinalDispositionCubit finalDispositionCubit) {
      finalDispositionCubit.selectFinalDisposition(finalDisposition);
    },
    expect: [
      FinalDispositionStateLoaded(
        id2disposition: getId2Disposition([finalDisposition]),
        dispositions: [finalDisposition],
        selectedFinalDisposition: finalDisposition,
      ),
    ],
  );

  asyncBlocTest(
    'discard final disposition',
    build: () => loadedFinalDispositionCubit(),
    act: (FinalDispositionCubit finalDispositionCubit) {
      finalDispositionCubit.selectFinalDisposition(finalDisposition);
      finalDispositionCubit.discardSelectedFinalDisposition();
    },
    expect: [
      FinalDispositionStateLoaded(
        id2disposition: getId2Disposition([finalDisposition]),
        dispositions: [finalDisposition],
        selectedFinalDisposition: finalDisposition,
      ),
      FinalDispositionStateLoaded(
        id2disposition: getId2Disposition([finalDisposition]),
        dispositions: [finalDisposition],
        selectedFinalDisposition: null,
      ),
    ],
  );

  asyncBlocTest(
    'final disposition from id',
    build: () => loadedFinalDispositionCubit(),
    verify: (FinalDispositionCubit finalDispositionCubit) {
      expect(finalDispositionCubit.finalDispositionFromId(1), equals(finalDisposition));
    },
  );

  asyncBlocTest(
    'non-existent final disposition from id',
    build: () => loadedFinalDispositionCubit(),
    verify: (FinalDispositionCubit finalDispositionCubit) {
      expect(finalDispositionCubit.finalDispositionFromId(3), equals(null));
    },
  );
}
