import 'package:bloc_test/bloc_test.dart';
import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/repositories/mock_secure_storage_repository.dart';
import '../lib/repositories/mock_shared_preferences_repository.dart';
import '../lib/repositories/mock_user_repository.dart';

void main() {
  const String transporterId = "0";
  const String driverId = "1234";

  // These are per test.
  MockUserRepository mockUserRepository;
  MockSecureStorageRepository mockSecureStorageRepository;
  MockSharedPreferencesRepository mockSharedPreferencesRepository;
  UserLoggedIn userLoggedIn = UserLoggedIn(
    driverId: driverId,
    transporterId: transporterId,
  );

  setUp(() {
    mockUserRepository = MockUserRepository(
      driverId: driverId,
      transporterId: transporterId,
    );
    mockSecureStorageRepository = MockSecureStorageRepository();
    mockSharedPreferencesRepository = MockSharedPreferencesRepository();
  });

  buildCubit() => UserCubit(
        userRepository: mockUserRepository,
        secureStorageRepository: mockSecureStorageRepository,
        sharedPreferencesRepository: mockSharedPreferencesRepository,
      );

  blocTest(
    'initial state is correct',
    build: buildCubit,
    expect: [],
  );

  blocTest(
    'simple successful login',
    build: buildCubit,
    act: (cubit) async {
      await cubit.login(mockUserRepository.firestoreConfiguration, "admin", "hunter2");
    },
    expect: [UserLoading(), userLoggedIn],
  );

  blocTest(
    'otp login',
    build: buildCubit,
    act: (cubit) async {
      await cubit.otpLogin("foo@example.com", "trololololol", "https://127.0.0.1:1/this-should-not-be-called");
    },
    expect: [UserLoading(), userLoggedIn],
  );

  blocTest(
    'clear login and reset',
    build: buildCubit,
    act: (cubit) async {
      await cubit.clearLoginCacheAndReset();
    },
    expect: [UserLoading(), UserInitial()],
  );
}
