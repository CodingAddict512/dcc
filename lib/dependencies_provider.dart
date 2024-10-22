import 'package:dcc/abstract_dependencies_provider.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/repositories/final_disposition_repository_interface.dart';
import 'package:dcc/data/repositories/impl/final_disposition_repository.dart';
import 'package:dcc/data/repositories/impl/metric_type_repository.dart';
import 'package:dcc/data/repositories/impl/pickup_repository.dart';
import 'package:dcc/data/repositories/impl/routes_repository.dart';
import 'package:dcc/data/repositories/impl/secure_storage_repository.dart';
import 'package:dcc/data/repositories/impl/shared_preferences_repository.dart';
import 'package:dcc/data/repositories/impl/user_repository.dart';
import 'package:dcc/data/repositories/metric_type_repository_interface.dart';
import 'package:dcc/data/repositories/pickup_repository_interface.dart';
import 'package:dcc/data/repositories/routes_repository_interface.dart';
import 'package:dcc/data/repositories/secure_storage_repository_interface.dart';
import 'package:dcc/data/repositories/shared_preferences_repository_interface.dart';
import 'package:dcc/data/repositories/user_repository_interface.dart';
import 'package:dcc/data/repository.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class DependenciesProvider extends AbstractDependenciesProvider {
  final IRepository _repository;
  final ISecureStorageRepository _secureStorageRepository;
  final ISharedPreferencesRepository _sharedPreferencesRepository;
  final IUserRepository _userRepository;
  final IPickupRepository _pickupRepository;
  final IRoutesRepository _routesRepository;
  final IMetricTypeRepository _metricTypeRepository;
  final IFinalDispositionRepository _finalDispositionRepository;

  DependenciesProvider(
    this._repository,
    this._secureStorageRepository,
    this._sharedPreferencesRepository,
    this._userRepository,
    this._pickupRepository,
    this._routesRepository,
    this._metricTypeRepository,
    this._finalDispositionRepository,
    child,
  ) : super(child: child);

  factory DependenciesProvider.fromChild({@required child}) {
    ISharedPreferencesRepository sharedPreferencesRepository = SharedPreferencesRepository();
    return DependenciesProvider(
      Repository(),
      SecureStorageRepository(),
      sharedPreferencesRepository,
      UserRepository(sharedPreferencesRepository: sharedPreferencesRepository),
      PickupRepository(),
      RoutesRepository(),
      MetricTypeRepository(),
      FinalDispositionRepository(),
      child,
    );
  }

  IUserCubit getUserCubit(context) => UserCubit.fromContext(context);

  Widget repositories({child}) {
    return MultiProvider(providers: [
      Provider<ISharedPreferencesRepository>(create: (context) => _sharedPreferencesRepository),
      Provider<IRepository>(create: (context) => _repository),
      Provider<ISecureStorageRepository>(create: (context) => _secureStorageRepository),
      Provider<IUserRepository>(create: (context) => _userRepository),
      Provider<IPickupRepository>(create: (context) => _pickupRepository),
      Provider<IRoutesRepository>(create: (context) => _routesRepository),
      Provider<IMetricTypeRepository>(create: (context) => _metricTypeRepository),
      Provider<IFinalDispositionRepository>(create: (context) => _finalDispositionRepository),
    ], child: child);
  }
}
