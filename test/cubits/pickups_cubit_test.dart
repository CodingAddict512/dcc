import 'package:bloc_test/bloc_test.dart';
import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/models/file_format.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:dcc/models/pickup_with_references.dart';
import 'package:dcc/models/status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/async_bloc.dart';
import '../lib/repositories/mock_pickup_repository.dart';
import '../lib/repositories/mock_routes_repository.dart';
import '../lib/repositories/mock_secure_storage_repository.dart';
import '../lib/repositories/mock_user_repository.dart';

void main() async {
  PickupRoute route = PickupRoute();
  PickupWithReferences pickupWithRefs = PickupWithReferences(status: Status.DRAFT);
  Pickup pickup = await Pickup.fromPickupWithReferences(pickupWithRefs);
  List<Pickup> pickups = [pickup];

  MockUserRepository mockUserRepository;
  MockRoutesRepository mockRoutesRepository;
  IUserCubit userCubit;
  RoutesCubit routesCubit;

  Future<PickupsCubit> loggedInPickupsCubit() async {
    PickupsCubit pickupsCubit = PickupsCubit(
      userCubit: userCubit,
      pickupRepository: MockPickupRepository(pickups: [pickupWithRefs]),
      routesCubit: routesCubit,
    );
    // These can not be moved to the corresponding build method since they run async
    await userCubit.login(mockUserRepository.firestoreConfiguration, "admin", "hunter2");
    await Future.delayed(const Duration(milliseconds: 50), () {});
    return pickupsCubit;
  }

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockRoutesRepository = MockRoutesRepository(routes: [route]);
    userCubit = UserCubit(
      userRepository: mockUserRepository,
      secureStorageRepository: MockSecureStorageRepository(),
    );
    routesCubit = RoutesCubit(
      userCubit: userCubit,
      routesRepository: mockRoutesRepository,
    );
  });

  blocTest(
    'initial state is correct',
    build: () => PickupsCubit(
      userCubit: userCubit,
      pickupRepository: MockPickupRepository(pickups: [pickupWithRefs]),
      routesCubit: routesCubit,
    ),
    expect: [],
    verify: (PickupsCubit pickupsCubit) {
      expect(pickupsCubit.state, equals(PickupsInitial()));
    },
  );

  blocTest(
    'login triggers load of pickups',
    build: () => PickupsCubit(
      userCubit: userCubit,
      pickupRepository: MockPickupRepository(pickups: [pickupWithRefs]),
      routesCubit: routesCubit,
    ),
    act: (cubit) {
      userCubit.login(mockUserRepository.firestoreConfiguration, "admin", "hunter2");
    },
    expect: [PickupsLoading(), PickupsLoaded(pickups: pickups, pickup: pickup)],
    wait: const Duration(milliseconds: 50),
  );

  blocTest(
    'select pickup',
    build: () => PickupsCubit(
      userCubit: userCubit,
      pickupRepository: MockPickupRepository(pickups: [pickupWithRefs]),
      routesCubit: routesCubit,
    ),
    seed: PickupsLoaded(pickups: pickups, pickup: null) as PickupsState,
    act: (PickupsCubit pickupsCubit) {
      pickupsCubit.selectPickup(pickup);
    },
    expect: [PickupsLoaded(pickups: pickups, pickup: pickup)],
  );

  final startedPickup = pickup.copyWith(status: Status.STARTED, orderId: 'PENDING');
  asyncBlocTest(
    'start pickup',
    build: loggedInPickupsCubit,
    act: (PickupsCubit pickupsCubit) {
      pickupsCubit.startPickup();
    },
    expect: [
      PickupsLoaded(
        pickups: pickups,
        pickup: startedPickup.copyWith(originalStatus: Status.STARTED),
      ),
      PickupsLoaded(pickups: [startedPickup], pickup: startedPickup)
    ],
  );

  Pickup assignedPickup = pickup.copyWith(status: Status.ASSIGNED);
  asyncBlocTest(
    'reset pickup',
    build: loggedInPickupsCubit,
    act: (PickupsCubit pickupsCubit) {
      pickupsCubit.resetPickup();
    },
    expect: [
      PickupsLoaded(
        pickups: pickups,
        pickup: assignedPickup.copyWith(originalStatus: Status.ASSIGNED),
      ),
      PickupsLoaded(pickups: [assignedPickup], pickup: assignedPickup)
    ],
  );

  asyncBlocTest(
    'delete draft pickup',
    build: loggedInPickupsCubit,
    act: (PickupsCubit pickupsCubit) {
      pickupsCubit.deleteDraftPickup();
    },
    expect: [PickupsLoaded(pickups: [], pickup: null)],
  );

  final pickupAfterRegisterWeight = pickup.copyWith(
    actualAmount: 1,
    actualMetricTypeId: 2,
    actualMetric: 3,
    actualRegisteredWeight: '4',
  );
  asyncBlocTest(
    'register weight',
    build: loggedInPickupsCubit,
    act: (PickupsCubit pickupsCubit) {
      pickupsCubit.registerWeight(1, MetricType(id: 2, metric: 3), '4');
    },
    expect: [
      PickupsLoaded(
        pickups: pickups,
        pickup: pickupAfterRegisterWeight.copyWith(originalStatus: pickup.status),
      ),
      PickupsLoaded(pickups: [pickupAfterRegisterWeight], pickup: pickupAfterRegisterWeight)
    ],
  );

  final pickupAfterNhDocFormatRegister = pickup.copyWith(externalNHDocFormat: FileFormat.JPEG);
  asyncBlocTest(
    'register nh doc format',
    build: loggedInPickupsCubit,
    act: (PickupsCubit pickupsCubit) {
      pickupsCubit.registerNhDocFormat(FileFormat.JPEG);
    },
    expect: [
      PickupsLoaded(
        pickups: pickups,
        pickup: pickupAfterNhDocFormatRegister.copyWith(originalStatus: pickup.status),
      ),
      PickupsLoaded(pickups: [pickupAfterNhDocFormatRegister], pickup: pickupAfterNhDocFormatRegister)
    ],
  );

  final pickupAfterEditNote = pickup.copyWith(note: 'note');
  asyncBlocTest(
    'register nh doc format',
    build: loggedInPickupsCubit,
    act: (PickupsCubit pickupsCubit) {
      pickupsCubit.editNote('note');
    },
    expect: [
      PickupsLoaded(
        pickups: pickups,
        pickup: pickupAfterEditNote.copyWith(originalStatus: pickup.status),
      ),
      PickupsLoaded(pickups: [pickupAfterEditNote], pickup: pickupAfterEditNote)
    ],
  );

  asyncBlocTest(
    'save pickup',
    build: loggedInPickupsCubit,
    act: (PickupsCubit pickupsCubit) {
      pickupsCubit.savePickup(pickupAfterEditNote);
    },
    expect: [
      PickupsLoaded(
        pickups: pickups,
        pickup: pickupAfterEditNote.copyWith(originalStatus: pickup.status),
      ),
      PickupsLoaded(pickups: [pickupAfterEditNote], pickup: pickupAfterEditNote)
    ],
  );
}
