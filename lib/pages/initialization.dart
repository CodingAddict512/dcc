import 'package:dcc/cubits/initialization_cubit.dart';
import 'package:dcc/cubits/states/initialization_states.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dcc/extensions/compat.dart';

class InitializationPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    InitializationCubit initializationCubit = context.watch<InitializationCubit>();

    Widget loading(InitializationState state) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    void toHome() {
      Navigator.pop(context);
      Navigator.pushNamed(context, '/home');
    }

    void toLogin() {
      Navigator.pushNamed(context, '/login');
    }

    return Scaffold(
      appBar: null,
      body: BlocConsumer<InitializationCubit, InitializationState>(
        listener: (context, state) {
          if (state is InitializationError) {
            // TODO, we need some way to recover from this with a retry/reset flow.
            // (retry for network errors and such, reset for permanent issues)
            // Currently, this is not possible.
            FlushbarHelper.createError(
              message: state.errorMessage,
              duration: null,
            ).show(context);
          } else if (state is InitializationUserNeedsReset) {
            toLogin();
          } else if (state is InitializationUserNoCredentials) {
            toLogin();
          } else if (state is InitializationComplete) {
            toHome();
          } else if (state is InitializationPendingExternalChangeState) {
            FlushbarHelper.createError(
              message: "Stopped in state " + state.toString() + ", but we have no resume handler for that!?",
              duration: null,
            ).show(context);
          }
        },
        builder: (context, state) {
          // We defer starting until here as otherwise a very early error state
          // might not be seen by the listener.
          initializationCubit.state.ifState<InitializationNotStarted>(
              withState: (s) => initializationCubit.startInitialization()
          );
          return loading(state);
        },
      ),
    );
  }
}
