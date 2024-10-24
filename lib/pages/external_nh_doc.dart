import 'package:dcc/cubits/external_nh_doc_cubit.dart';
import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/states/external_nh_doc_state.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/status.dart';
import 'package:dcc/pages/scan_nh_doc.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
// import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExternalNhDocPage extends StatelessWidget {
  Widget loading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final pickupsCubit = context.watch<PickupsCubit>();
    final externalNhDocCubit = context.watch<ExternalNhDocCubit>();
    final navigator = Navigator.of(context);

    pickupsCubit.state.ifState<PickupsLoaded>(
      withState: (state) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          externalNhDocCubit.downloadNhDocImage(state.pickup);
        });
      },
      orElse: (state) {},
    );

    Widget reselectButton() {
      return context.watch<PickupsCubit>().state.ifState<PickupsLoaded>(
        withState: (state) {
          return ElevatedButton.icon(
            onPressed: (state.pickup.status == Status.STARTED ||
                    state.pickup.status == Status.REJECTED)
                ? () async {
                    await navigator.push(MaterialPageRoute(
                      builder: (context) => ScanNhDocPage(),
                    ));
                  }
                : null,
            icon: Icon(Icons.autorenew),
            label: Text(DccLocalizations.of(context)!
                .translate("externalNhDocPageRenewNhDoc")),
          );
        },
        orElse: (state) {
          return Container();
        },
      );
    }

    Widget displayNhDoc() {
      return BlocSubStateBuilder<ExternalNhDocCubit, ExternalNhDocState,
          ExternalNhDocLoadedInMemory>(
        subStateBuilder: (context, state) {
          return Image(
            image: state.memoryImage,
          );
        },
        fallbackBuilder: (context, state) {
          // If the NHDoc cubit ended with an error was caused by a broken upload,
          // then reload the previous image.  Otherwise the loading spinner will
          // just hang forever.
          if (state is ExternalNhDocUploadError) {
            pickupsCubit.state.ifState<PickupsLoaded>(
              withState: (state) {
                externalNhDocCubit.downloadNhDocImage(state.pickup);
              },
              orElse: (state) {},
            );
          } else if (state is ExternalNhDocDownloadError) {
            // FlushbarHelper.createError(
            //   message: state.message,
            //   duration: Duration(seconds: 3),
            // ).show(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: Duration(seconds: 3),
              ),
            );
          }
          return loading();
        },
      );
    }

    Widget appBar() {
      return AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            navigator.pop();
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                reselectButton(),
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            navigator.pop();
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                reselectButton(),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            displayNhDoc(),
          ],
        ),
      ),
    );
  }
}
