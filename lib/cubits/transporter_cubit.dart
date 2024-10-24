import 'dart:async';

import 'package:dcc/cubits/states/transporter_state.dart';
import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/data/respository_interface.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransporterCubit extends Cubit<TransporterState> {
  final IRepository repository;
  final IUserCubit userCubit;

  StreamSubscription? listener;
  StreamSubscription? onNewUser;

  TransporterCubit({required this.repository, required this.userCubit})
      : super(TransporterInitial()) {
    onNewUser = userCubit.stream.listen((event) => _userStateChange(event));
    userCubit.state.ifState<UserLoggedIn>(
      withState: (state) => _userStateChange(state),
      orElse: (state) {},
    );
  }

  factory TransporterCubit.fromContext(BuildContext context) =>
      TransporterCubit(
        userCubit: context.read<IUserCubit>(),
        repository: context.read<IRepository>(),
      );

  void _userStateChange(UserState newState) async {
    newState.ifState<UserLoggedIn>(
      withState: (state) async {
        await listener!.cancel();
        listener = null;
        emit(TransporterLoading());
        listener = repository
            .getTransporter(state.transporterId)
            .listen((transporter) {
          final loaded = TransporterLoaded(transporter: transporter);
          emit(loaded);
        });
      },
      orElse: (state) {},
    );
  }

  @override
  Future<void> close() async {
    await listener!.cancel();
    await onNewUser!.cancel();
    return super.close();
  }
}
