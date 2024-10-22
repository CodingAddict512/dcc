import 'dart:io';

import 'package:dcc/cubits/external_nh_doc_cubit.dart';
import 'package:dcc/cubits/pickups_cubit.dart';
import 'package:dcc/cubits/states/external_nh_doc_state.dart';
import 'package:dcc/cubits/states/pickups_state.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/widgets/pickup_details/scan_nh_doc_dialog.dart';
import 'package:filesize/filesize.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';

class ScanNhDocPage extends StatefulWidget {
  ScanNhDocPage();

  @override
  State<StatefulWidget> createState() => _ScanNhDocPageState();
}

class _ScanNhDocPageState extends State<ScanNhDocPage> {
  File _file;

  _ScanNhDocPageState();

  @override
  Widget build(BuildContext context) {
    final externalNhDocCubit = context.watch<ExternalNhDocCubit>();
    final pickupsCubit = context.watch<PickupsCubit>();
    final navigator = Navigator.of(context);
    final localizations = DccLocalizations.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_file == null) {
        await _showNhDocDialog();
        if (_file == null) {
          navigator.pop();
        }
      }
    });

    Widget displayImage() {
      if (_file == null) {
        return Container();
      }

      return Image(
        image: FileImage(_file),
      );
    }

    Widget confirmButton() {
      return RaisedButton.icon(
        color: Colors.green,
        onPressed: () async {
          pickupsCubit.state.ifState<PickupsLoaded>(
            withState: (state) async {
              await externalNhDocCubit.uploadNhDocImage(_file, state.pickup);
              final externalNhDocCubitState = externalNhDocCubit.state;
              if (externalNhDocCubitState is ExternalNhDocDownloaded || externalNhDocCubitState is ExternalNhDocLoadedInMemory) {
                navigator.pop();
              } else if (externalNhDocCubitState is ExternalNhDocError) {
                FlushbarHelper.createError(
                    message: externalNhDocCubitState.message,
                    duration: Duration(seconds: 3),
                ).show(context);
              }
            },
          );
        },
        icon: Icon(Icons.check),
        label: Text(localizations.translate("scanNhDocPageConfirm")),
      );
    }

    Widget reselectButton() {
      return ElevatedButton.icon(
        onPressed: () => _showNhDocDialog(),
        icon: Icon(Icons.autorenew),
        label: Text(localizations.translate("scanNhDocPageReselect")),
      );
    }

    Widget imageInfo() {
      if (_file == null) {
        return Text("0");
      }
      final size = _file.lengthSync();
      return Text("${filesize(size)}");
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            TextButton(
              onPressed: () => navigator.pop(),
              child: Text(localizations.translate("scanNhDocCancel")),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                confirmButton(),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            displayImage(),
            // ImageFileInfo(_file),
            imageInfo(),
            reselectButton(),
          ],
        ),
      ),
    );
  }

  Future<void> _showNhDocDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => ScanNhDocDialog(),
    );
    if (result is File && mounted) {
      setState(() {
        _file = result;
      });
    }
  }
}
