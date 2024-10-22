
import 'package:bloc_test/bloc_test.dart';
import 'package:dcc/cubits/initialization_cubit.dart';
import 'package:dcc/cubits/settings_cubit.dart';
import 'package:dcc/cubits/states/initialization_states.dart';
import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/repositories/secure_storage_repository_interface.dart';
import 'package:dcc/models/user_error_type.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/cubits/mock_user_cubit.dart';
import '../lib/repositories/mock_secure_storage_repository.dart';
import '../lib/repositories/mock_shared_preferences_repository.dart';
import '../lib/repositories/mock_user_repository.dart';

void main() {

  group('Initialization Cubit', () {
    MockSecureStorageRepository mockSecureStorageRepository;
    MockSharedPreferencesRepository mockSharedPreferencesRepository;
    MockUserRepository mockUserRepository;
    SettingsCubit settingsCubit;
    IUserCubit userCubit;
    MockUserCubit mockUserCubit;
    UserError errorUserDisabled = UserError(
      message: "User is disabled",
      errorType: UserErrorType.USER_DISABLED,
    );

    setUp(() {
      mockSecureStorageRepository = MockSecureStorageRepository();
      mockSharedPreferencesRepository = MockSharedPreferencesRepository();
      mockUserRepository = MockUserRepository();
      settingsCubit = SettingsCubit(sharedPreferencesRepository: mockSharedPreferencesRepository);
      mockUserRepository = MockUserRepository();
      mockUserCubit = MockUserCubit();
      userCubit = UserCubit(userRepository: mockUserRepository, secureStorageRepository: mockSecureStorageRepository);
    });

    tearDown(() {
      mockUserCubit.close();
      userCubit.close();
      settingsCubit.close();
    });

    InitializationCubit buildCubit({useMockUserCubit = false}) =>
        InitializationCubit(
          userCubit: useMockUserCubit ? mockUserCubit : userCubit,
          settingsCubit: settingsCubit,
          secureStorageRepository: mockSecureStorageRepository,
          sharedPreferencesRepository: mockSharedPreferencesRepository,
        );

    blocTest(
      'initial state is correct',
      build: buildCubit,
      expect: [],
    );

    blocTest(
      'start initialization (stop)',
      build: buildCubit,
      act: (InitializationCubit cubit) async {
        cubit.startInitialization();
      },
      wait: Duration(milliseconds: 500),
      expect: [
        InitializationNotStarted(),
        InitializationSettingsLoading(),
        InitializationSettingsLoaded(),
        InitializationUserLoading(),
        InitializationUserNoCredentials(),
      ],
    );

    blocTest(
      'start initialization (stored credentials)',
      build: buildCubit,
      act: (InitializationCubit cubit) async {
        mockSecureStorageRepository
            .withKeySet(StorageKeys.firestoreUsername, "foo")
            .withKeySet(StorageKeys.firestorePassword, "Test1234");
        await mockSharedPreferencesRepository.setFirestoreConfiguration(
            mockUserRepository.firestoreConfiguration
        );
        cubit.startInitialization();
      },
      wait: Duration(milliseconds: 500),
      expect: [
        InitializationNotStarted(),
        InitializationSettingsLoading(),
        InitializationSettingsLoaded(),
        InitializationUserLoading(),
        InitializationUserInitialized(),
        InitializationComplete()
      ],
    );

    blocTest(
      'start initialization (needs reset credentials)',
      build: () => buildCubit(useMockUserCubit: true),
      act: (InitializationCubit cubit) async {
        mockUserCubit.loginMock = (conf, email, password) => errorUserDisabled;
        mockSecureStorageRepository
            .withKeySet(StorageKeys.firestoreUsername, "foo")
            .withKeySet(StorageKeys.firestorePassword, "Test1234");
        await mockSharedPreferencesRepository.setFirestoreConfiguration(
            mockUserRepository.firestoreConfiguration
        );
        cubit.startInitialization();
      },
      wait: Duration(milliseconds: 500),
      expect: [
        InitializationNotStarted(),
        InitializationSettingsLoading(),
        InitializationSettingsLoaded(),
        InitializationUserLoading(),
        InitializationUserNeedsReset(userError: errorUserDisabled),
      ],
    );

    blocTest(
      'start initialization (already logged in)',
      build: buildCubit,
      act: (InitializationCubit cubit) async {
        await userCubit.login(mockUserRepository.firestoreConfiguration, "foo", "bar");
        cubit.startInitialization();
      },
      wait: Duration(milliseconds: 500),
      expect: [
        InitializationNotStarted(),
        InitializationSettingsLoading(),
        InitializationSettingsLoaded(),
        InitializationUserLoading(),
        InitializationUserInitialized(),
        InitializationComplete()
      ],
    );
  });
}
