import 'package:bloc_test/bloc_test.dart';
import 'package:dcc/cubits/states/transporter_state.dart';
import 'package:dcc/cubits/transporter_cubit.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/models/transporter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/cubits/mock_user_cubit.dart';
import '../lib/repositories/mock_secure_storage_repository.dart';
import '../lib/repositories/mock_user_repository.dart';
import '../lib/test_repository.dart';

void main() {
  final String transporterId = "0";
  // Cannot be created in setUp as it is used in expect values (and they are
  // computed before setUp is called.
  final Transporter transporter = TestRepository.getTransporterByIdForTest(transporterId);

  // These are per test.
  TestRepository testRepository;
  IUserCubit userCubit;
  MockUserRepository mockUserRepository = MockUserRepository();


  setUp(() {
    testRepository = TestRepository();
    userCubit = UserCubit(
        userRepository: mockUserRepository,
        secureStorageRepository: MockSecureStorageRepository()
    );
  });

  blocTest('initial state is correct',
      build: () => TransporterCubit(repository: testRepository, userCubit: userCubit),
      expect: [],
  );


  blocTest('login triggers load of transporter',
    build: () => TransporterCubit(repository: testRepository, userCubit: userCubit),
    act: (cubit) {
      testRepository.transporterSubject.add(transporter);
      userCubit.login(mockUserRepository.firestoreConfiguration, "admin", "hunter2");
    },
    expect: [TransporterLoading(), TransporterLoaded(transporter: transporter)],
    wait: const Duration(milliseconds: 500),
  );
}
