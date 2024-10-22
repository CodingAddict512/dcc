import 'package:bloc_test/bloc_test.dart';
import 'package:dcc/cubits/final_disposition_cubit.dart';
import 'package:dcc/cubits/metric_type_cubit.dart';
import 'package:dcc/cubits/pickup_edit_cubit.dart';
import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/pickup_edit_state.dart';
import 'package:dcc/models/customer.dart';
import 'package:dcc/models/final_disposition.dart';
import 'package:dcc/models/location.dart';
import 'package:dcc/models/metric_type.dart';
import 'package:dcc/models/nh_category.dart';
import 'package:dcc/models/pickup.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:dcc/models/pickup_with_references.dart';
import 'package:dcc/models/status.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/async_bloc.dart';
import '../lib/cubits/mock_user_cubit.dart';
import '../lib/repositories/mock_final_disposition_repository.dart';
import '../lib/repositories/mock_metric_type_repository.dart';
import '../lib/repositories/mock_pickup_repository.dart';
import '../lib/repositories/mock_routes_repository.dart';
import '../lib/repositories/mock_user_repository.dart';

void main() async {
  final PickupWithReferences pickupWithRefs = PickupWithReferences(id: 'id', status: Status.ASSIGNED);
  final Pickup pickup = await Pickup.fromPickupWithReferences(pickupWithRefs);

  MockUserRepository mockUserRepository;
  MockUserCubit mockUserCubit;

  Future<PickupsCubit> loggedInPickupsCubit() async {
    PickupsCubit pickupsCubit = PickupsCubit(
      userCubit: mockUserCubit,
      pickupRepository: MockPickupRepository(pickups: [pickupWithRefs]),
      routesCubit: RoutesCubit(
        routesRepository: MockRoutesRepository(routes: [PickupRoute()]),
        userCubit: mockUserCubit,
      ),
    );
    // These can not be moved to the corresponding build method since they run async
    await mockUserCubit.login(mockUserRepository.firestoreConfiguration, "admin", "hunter2");
    await Future.delayed(const Duration(milliseconds: 50), () {});
    return pickupsCubit;
  }

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockUserCubit = MockUserCubit();
  });

  blocTest(
    'initial state is correct',
    build: () => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: PickupsCubit(
        routesCubit: RoutesCubit(routesRepository: MockRoutesRepository(), userCubit: mockUserCubit),
        pickupRepository: MockPickupRepository(),
        userCubit: mockUserCubit,
      ),
    ),
    verify: (PickupEditCubit pickupEditCubit) {
      expect(pickupEditCubit.state, equals(PickupEditInitial()));
    },
  );

  blocTest(
    'load pickup',
    build: () => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: PickupsCubit(
        routesCubit: RoutesCubit(routesRepository: MockRoutesRepository(), userCubit: mockUserCubit),
        pickupRepository: MockPickupRepository(),
        userCubit: mockUserCubit,
      ),
    ),
    act: (PickupEditCubit pickupEditCubit) {
      pickupEditCubit.load(pickup);
    },
    expect: [
      PickupEditLoading(),
      PickupEditLoaded(oldPickup: pickup),
    ],
  );

  int newAmount = 1;
  MetricType newMetric = MetricType(id: 2, metric: 3);
  String newWeight = '4';
  blocTest(
    'register weight',
    build: () => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: PickupsCubit(
        routesCubit: RoutesCubit(routesRepository: MockRoutesRepository(), userCubit: mockUserCubit),
        pickupRepository: MockPickupRepository(),
        userCubit: mockUserCubit,
      ),
    ),
    act: (PickupEditCubit pickupEditCubit) {
      pickupEditCubit.load(pickup);
      pickupEditCubit.registerWeight(newAmount, newMetric, newWeight);
    },
    expect: [
      PickupEditLoading(),
      PickupEditLoaded(oldPickup: pickup),
      PickupEditLoaded(oldPickup: pickup, actualAmount: newAmount, actualMetric: newMetric, weight: newWeight),
    ],
  );

  blocTest(
    'new note',
    build: () => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: PickupsCubit(
        routesCubit: RoutesCubit(routesRepository: MockRoutesRepository(), userCubit: mockUserCubit),
        pickupRepository: MockPickupRepository(),
        userCubit: mockUserCubit,
      ),
    ),
    act: (PickupEditCubit pickupEditCubit) {
      pickupEditCubit.load(pickup);
      pickupEditCubit.newNote('note');
    },
    expect: [
      PickupEditLoading(),
      PickupEditLoaded(oldPickup: pickup),
      PickupEditLoaded(oldPickup: pickup, note: 'note'),
    ],
  );

  FinalDisposition finalDisposition = FinalDisposition(id: 1, type: '2', outgoingDispositionType: false, category: NHCategory.KATEGORI1);
  blocTest(
    'select final disposition type',
    build: () => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: PickupsCubit(
        routesCubit: RoutesCubit(routesRepository: MockRoutesRepository(), userCubit: mockUserCubit),
        pickupRepository: MockPickupRepository(),
        userCubit: mockUserCubit,
      ),
    ),
    act: (PickupEditCubit pickupEditCubit) {
      pickupEditCubit.load(pickup);
      pickupEditCubit.selectFinalDispositionType(finalDisposition);
    },
    expect: [
      PickupEditLoading(),
      PickupEditLoaded(oldPickup: pickup),
      PickupEditLoaded(oldPickup: pickup, actualFinalDisposition: finalDisposition),
    ],
  );

  Location location = Location(id: 'id', name: 'name');
  Customer customer = Customer(primaryLocation: location);
  blocTest(
    'select origin customer',
    build: () => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: PickupsCubit(
        routesCubit: RoutesCubit(routesRepository: MockRoutesRepository(), userCubit: mockUserCubit),
        pickupRepository: MockPickupRepository(),
        userCubit: mockUserCubit,
      ),
    ),
    act: (PickupEditCubit pickupEditCubit) {
      pickupEditCubit.load(pickup);
      pickupEditCubit.selectOriginCustomer(customer);
    },
    expect: [
      PickupEditLoading(),
      PickupEditLoaded(oldPickup: pickup),
      PickupEditLoaded(
        oldPickup: pickup,
        originCustomer: customer,
        originLocation: customer.primaryLocation,
      ),
    ],
  );

  blocTest(
    'select origin location',
    build: () => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: PickupsCubit(
        routesCubit: RoutesCubit(routesRepository: MockRoutesRepository(), userCubit: mockUserCubit),
        pickupRepository: MockPickupRepository(),
        userCubit: mockUserCubit,
      ),
    ),
    act: (PickupEditCubit pickupEditCubit) {
      pickupEditCubit.load(pickup);
      pickupEditCubit.selectOriginLocation(location);
    },
    expect: [
      PickupEditLoading(),
      PickupEditLoaded(oldPickup: pickup),
      PickupEditLoaded(
        oldPickup: pickup,
        originLocation: location,
      ),
    ],
  );

  blocTest(
    'select receiver customer',
    build: () => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: PickupsCubit(
        routesCubit: RoutesCubit(routesRepository: MockRoutesRepository(), userCubit: mockUserCubit),
        pickupRepository: MockPickupRepository(),
        userCubit: mockUserCubit,
      ),
    ),
    act: (PickupEditCubit pickupEditCubit) {
      pickupEditCubit.load(pickup);
      pickupEditCubit.selectReceiverCustomer(customer);
    },
    expect: [
      PickupEditLoading(),
      PickupEditLoaded(oldPickup: pickup),
      PickupEditLoaded(
        oldPickup: pickup,
        receiverCustomer: customer,
        receiverLocation: customer.primaryLocation,
      ),
    ],
  );

  blocTest(
    'select receiver location',
    build: () => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: PickupsCubit(
        routesCubit: RoutesCubit(routesRepository: MockRoutesRepository(), userCubit: mockUserCubit),
        pickupRepository: MockPickupRepository(),
        userCubit: mockUserCubit,
      ),
    ),
    act: (PickupEditCubit pickupEditCubit) {
      pickupEditCubit.load(pickup);
      pickupEditCubit.selectReceiverLocation(location);
    },
    expect: [
      PickupEditLoading(),
      PickupEditLoaded(oldPickup: pickup),
      PickupEditLoaded(oldPickup: pickup, receiverLocation: location),
    ],
  );

  Pickup editedPickup = pickup.copyWith(
    actualFinalDispositionId: finalDisposition.id,
    actualFinalDisposition: finalDisposition.type,
    actualRegisteredWeight: newWeight,
    actualAmount: newAmount,
    actualMetric: newMetric.metric,
    actualMetricTypeId: newMetric.id,
    originCustomer: customer,
    originLocation: customer.primaryLocation,
    receiverCustomer: customer,
    receiverLocation: customer.primaryLocation,
    note: 'note',
  );
  blocTest(
    'get edited pickup',
    build: () => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: PickupsCubit(
        routesCubit: RoutesCubit(routesRepository: MockRoutesRepository(), userCubit: mockUserCubit),
        pickupRepository: MockPickupRepository(),
        userCubit: mockUserCubit,
      ),
    ),
    act: (PickupEditCubit pickupEditCubit) {
      pickupEditCubit.load(pickup);
      pickupEditCubit.registerWeight(newAmount, newMetric, newWeight);
      pickupEditCubit.newNote('note');
      pickupEditCubit.selectFinalDispositionType(finalDisposition);
      pickupEditCubit.selectOriginCustomer(customer);
      pickupEditCubit.selectReceiverCustomer(customer);
    },
    verify: (PickupEditCubit pickupEditCubit) {
      expect(pickupEditCubit.editedPickup(pickupEditCubit.state), equals(editedPickup));
    },
  );

  Pickup editedPickup2 = pickup.copyWith(
    actualFinalDispositionId: finalDisposition.id,
    actualFinalDisposition: finalDisposition.type,
    actualRegisteredWeight: newWeight,
    actualAmount: newAmount,
    actualMetric: newMetric.metric,
    actualMetricTypeId: newMetric.id,
    note: 'note',
  );
  asyncBlocTest(
    'save edited pickup',
    build: () async => PickupEditCubit(
      metricTypeCubit: MetricTypeCubit(metricTypeRepository: MockMetricTypeRepository()),
      finalDispositionCubit: FinalDispositionCubit(finalDispositionRepository: MockFinalDispositionRepository()),
      pickupsCubit: await loggedInPickupsCubit(),
    ),
    act: (PickupEditCubit pickupEditCubit) {
      pickupEditCubit.load(pickup);
      pickupEditCubit.registerWeight(newAmount, newMetric, newWeight);
      pickupEditCubit.newNote('note');
      pickupEditCubit.selectFinalDispositionType(finalDisposition);
      pickupEditCubit.save();
    },
    expect: [
      PickupEditLoading(),
      PickupEditLoaded(oldPickup: pickup),
      PickupEditLoaded(
        oldPickup: pickup,
        actualAmount: newAmount,
        actualMetric: newMetric,
        weight: newWeight,
      ),
      PickupEditLoaded(
        oldPickup: pickup,
        actualAmount: newAmount,
        actualMetric: newMetric,
        weight: newWeight,
        note: 'note',
      ),
      PickupEditLoaded(
        oldPickup: pickup,
        actualAmount: newAmount,
        actualMetric: newMetric,
        weight: newWeight,
        note: 'note',
        actualFinalDisposition: finalDisposition,
      ),
      PickupEditLoaded(
        oldPickup: editedPickup2.copyWith(originalStatus: Status.ASSIGNED),
        actualAmount: newAmount,
        actualMetric: newMetric,
        weight: newWeight,
        note: 'note',
        actualFinalDisposition: finalDisposition,
      ),
      PickupEditLoaded(
        oldPickup: editedPickup2,
        actualAmount: newAmount,
        actualMetric: newMetric,
        weight: newWeight,
        note: 'note',
        actualFinalDisposition: finalDisposition,
      ),
    ],
    wait: const Duration(milliseconds: 50),
  );
}
