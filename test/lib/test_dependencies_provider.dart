import 'package:dcc/abstract_dependencies_provider.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/repositories/secure_storage_repository_interface.dart';
import 'package:dcc/data/repositories/shared_preferences_repository_interface.dart';
import 'package:dcc/data/repositories/user_repository_interface.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'cubits/mock_user_cubit.dart';
import 'repositories/mock_secure_storage_repository.dart';
import 'repositories/mock_shared_preferences_repository.dart';
import 'repositories/mock_user_repository.dart';
import 'test_repository.dart';

class TestDependenciesProvider extends AbstractDependenciesProvider {

  final TestRepository testRepository;
  final ISecureStorageRepository secureStorageRepository = MockSecureStorageRepository();
  final ISharedPreferencesRepository sharedPreferencesRepository = MockSharedPreferencesRepository();
  final IUserRepository userRepository = MockUserRepository();

  TestDependenciesProvider({@required child}) : testRepository = TestRepository(), super(child: child);
  TestDependenciesProvider.withRepository({@required child, this.testRepository}) : super(child: child);

  IUserCubit getUserCubit(context) => MockUserCubit();
  Widget repositories({child}) {
    return MultiProvider(
        providers: [
          Provider<ISharedPreferencesRepository>(create: (context) => sharedPreferencesRepository),
          Provider<IRepository>(create: (context) => testRepository),
          Provider<ISecureStorageRepository>(create: (context) => secureStorageRepository),
          Provider<IUserRepository>(create: (context) => userRepository)
        ],
        child: child
    );
  }
}
