import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/src/mock_document_reference.dart';
import 'package:dcc/cubits/routes_cubit.dart';
import 'package:dcc/cubits/states/routes_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/models/pickup_route.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/repositories/mock_routes_repository.dart';
import '../lib/repositories/mock_secure_storage_repository.dart';
import '../lib/repositories/mock_shared_preferences_repository.dart';
import '../lib/repositories/mock_user_repository.dart';

void main() {
  PickupRoute route = PickupRoute();
  List<PickupRoute> routes() => [PickupRoute()];

  IUserCubit userCubit;
  MockUserRepository mockUserRepository = MockUserRepository();

  setUp(() {
    userCubit = UserCubit(
      userRepository: mockUserRepository,
      secureStorageRepository: MockSecureStorageRepository(),
      sharedPreferencesRepository: MockSharedPreferencesRepository(),
    );
  });

  blocTest(
    'initial state is correct',
    build: () => RoutesCubit(
      routesRepository: MockRoutesRepository(),
      userCubit: userCubit,
    ),
    expect: [],
    verify: (RoutesCubit routesCubit) {
      expect(routesCubit.state, equals(RoutesInitial()));
    },
  );

  blocTest(
    'login triggers load of routes',
    build: () => RoutesCubit(
      routesRepository: MockRoutesRepository(routes: routes()),
      userCubit: userCubit,
    ),
    act: (cubit) {
      userCubit.login(mockUserRepository.firestoreConfiguration, "admin", "hunter2");
    },
    expect: [RoutesLoading(), RoutesLoaded(routes: routes(), route: route)],
    wait: const Duration(milliseconds: 50),
  );

  blocTest(
    'has any routes assigned',
    build: () => RoutesCubit(
      routesRepository: MockRoutesRepository(routes: routes()),
      userCubit: userCubit,
    ),
    seed: RoutesLoaded(routes: routes(), route: route) as RoutesState,
    verify: (RoutesCubit routesCubit) {
      expect(routesCubit.hasAnyRoutesAssigned(), equals(true));
    },
  );

  blocTest(
    'has no routes assigned',
    build: () => RoutesCubit(
      routesRepository: MockRoutesRepository(routes: routes()),
      userCubit: userCubit,
    ),
    seed: RoutesLoaded(routes: []) as RoutesState,
    verify: (RoutesCubit routesCubit) {
      expect(routesCubit.hasAnyRoutesAssigned(), equals(false));
    },
  );

  blocTest(
    'has selected route',
    build: () => RoutesCubit(
      routesRepository: MockRoutesRepository(routes: routes()),
      userCubit: userCubit,
    ),
    seed: RoutesLoaded(routes: routes(), route: route) as RoutesState,
    verify: (RoutesCubit routesCubit) {
      expect(routesCubit.hasSelectedRoute(), equals(true));
    },
  );

  blocTest(
    'has no selected route',
    build: () => RoutesCubit(
      routesRepository: MockRoutesRepository(routes: routes()),
      userCubit: userCubit,
    ),
    seed: RoutesLoaded(routes: routes(), route: null) as RoutesState,
    verify: (RoutesCubit routesCubit) {
      expect(routesCubit.hasSelectedRoute(), equals(false));
    },
  );

  blocTest(
    'select route',
    build: () => RoutesCubit(
      routesRepository: MockRoutesRepository(routes: routes()),
      userCubit: userCubit,
    ),
    seed: RoutesLoaded(routes: routes(), route: null) as RoutesState,
    act: (RoutesCubit routesCubit) {
      routesCubit.selectRoute(route);
    },
    expect: [RoutesLoaded(routes: routes(), route: route)],
  );

  group('Tests needing logged in routes cubit', () {
    PickupRoute closedRoute = PickupRoute(isActive: false, draftOrders: []);
    RoutesCubit loggedInRoutesCubit;

    setUp(() async {
      // These can not be moved to the corresponding build method since they run async
      await userCubit.login(mockUserRepository.firestoreConfiguration, "admin", "hunter2");
      loggedInRoutesCubit = RoutesCubit(
        routesRepository: MockRoutesRepository(routes: routes()),
        userCubit: userCubit,
      );
      await Future.delayed(const Duration(milliseconds: 50), () {});
    });

    blocTest(
      'close route',
      build: () => loggedInRoutesCubit,
      act: (RoutesCubit routesCubit) async {
        await routesCubit.closeRoute();
      },
      expect: [
        RoutesLoaded(routes: [closedRoute], route: closedRoute),
      ],
    );

    PickupRoute anotherRoute = PickupRoute(id: 'someId');
    blocTest(
      'Add new route',
      build: () => loggedInRoutesCubit,
      act: (RoutesCubit routesCubit) async {
        await routesCubit.addNewRoute(anotherRoute);
      },
      expect: [
        RoutesLoaded(routes: [route, anotherRoute], route: anotherRoute)
      ],
    );
  });

  group('Tests needing logged in routes cubit with draft orders', () {
    List<DocumentReference> draftOrders = [
      MockDocumentReference(null, null, 'id1', null, null, null, null),
      MockDocumentReference(null, null, 'id2', null, null, null, null),
      MockDocumentReference(null, null, 'id3', null, null, null, null),
    ];
    final PickupRoute routeWithDrafts = PickupRoute(draftOrders: draftOrders);
    final List<PickupRoute> routesWithDrafts = [routeWithDrafts];
    RoutesCubit loggedInRoutesCubit;

    setUp(() async {
      // These can not be moved to the corresponding build method since they run async
      await userCubit.login(mockUserRepository.firestoreConfiguration, "admin", "hunter2");
      loggedInRoutesCubit = RoutesCubit(
        routesRepository: MockRoutesRepository(routes: routesWithDrafts),
        userCubit: userCubit,
      );
      await Future.delayed(const Duration(milliseconds: 50), () {});
    });

    blocTest(
      'remove draft pickups by ids',
      build: () => loggedInRoutesCubit,
      act: (RoutesCubit routesCubit) async {
        await routesCubit.removeDraftPickupByIds(['id1', 'id2']);
      },
      expect: [
        RoutesLoaded(
          routes: [
            PickupRoute(draftOrders: [draftOrders[2]]),
          ],
          route: PickupRoute(draftOrders: [draftOrders[2]]),
        ),
      ],
    );
  });
}
