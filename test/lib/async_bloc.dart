import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart' as test;

/// blocTest but with async build function
@isTest
void asyncBlocTest<C extends Cubit<State>, State>(
  String description, {
  @required FutureOr<C> Function() build,
  State seed,
  Function(C cubit) act,
  Duration wait,
  int skip = 0,
  Iterable expect,
  Function(C cubit) verify,
  Iterable errors,
}) {
  test.test(description, () async {
    await runAsyncBlocTest<C, State>(
      description,
      build: build,
      seed: seed,
      act: act,
      wait: wait,
      skip: skip,
      expect: expect,
      verify: verify,
      errors: errors,
    );
  });
}

/// Internal [blocTest] runner which is only visible for testing.
/// This should never be used directly -- please use [blocTest] instead.
@visibleForTesting
Future<void> runAsyncBlocTest<C extends Cubit<State>, State>(
  String description, {
  @required FutureOr<C> Function() build,
  State seed,
  Function(C cubit) act,
  Duration wait,
  int skip = 0,
  Iterable expect,
  Function(C cubit) verify,
  Iterable errors,
}) async {
  final unhandledErrors = <Object>[];
  var shallowEquality = false;
  await runZoned(
    () async {
      final states = <State>[];
      final cubit = await build();
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      if (seed != null) cubit.emit(seed);
      final subscription = cubit.skip(skip).listen(states.add);
      try {
        await act?.call(cubit);
      } on Exception catch (error) {
        unhandledErrors.add(
          error is CubitUnhandledErrorException ? error.error : error,
        );
      }
      if (wait != null) await Future<void>.delayed(wait);
      await Future<void>.delayed(Duration.zero);
      await cubit.close();
      if (expect != null) {
        shallowEquality = '$states' == '$expect';
        test.expect(states, expect);
      }
      await subscription.cancel();
      await verify?.call(cubit);
    },
    onError: (Object error) {
      if (error is CubitUnhandledErrorException) {
        unhandledErrors.add(error.error);
      } else if (shallowEquality && error is test.TestFailure) {
        // ignore: only_throw_errors
        throw test.TestFailure(
          '''${error.message}
WARNING: Please ensure state instances extend Equatable, override == and hashCode, or implement Comparable.
Alternatively, consider using Matchers in the expect of the blocTest rather than concrete state instances.\n''',
        );
      } else {
        // ignore: only_throw_errors
        throw error;
      }
    },
  );
  if (errors != null) test.expect(unhandledErrors, errors);
}
