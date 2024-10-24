import 'dart:io';

import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/models/otp_code_parser.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ScanPage extends StatefulWidget {
  ScanPage() : super();

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final _formKey = GlobalKey<FormState>();
  QRViewController? controller;

  Widget _loading() => Center(child: CircularProgressIndicator());

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);
    final theme = Theme.of(context);

    void _onQRViewCreated(QRViewController controller) {
      this.controller = controller;

      controller.scannedDataStream.first.then((scanData) {
        final otpCodeParser = OTPCodeParser();
        if (otpCodeParser.parse(scanData.code!)) {
          final userCubit = context.watch<IUserCubit>();
          // Start the login; if it fails, then the login widget will pickup it up.
          userCubit.otpLogin(otpCodeParser.email!, otpCodeParser.otp!,
              otpCodeParser.verifyUrl!);
          navigator.pop(true);
        } else {
          navigator.pop(false);
        }
      });
    }

    Widget _scanPage() {
      return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              navigator.pop();
            },
          ),
        ),
        backgroundColor: theme.colorScheme.surface,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              // child: Center(),
              child: QRView(
                key: _formKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return BlocSubStateBuilder<IUserCubit, UserState, UserLoading>(
      subStateBuilder: (context, state) => _loading(),
      fallbackBuilder: (context, state) => _scanPage(),
    );
  }

  @override
  void dispose() {
    // controller.dispose();
    super.dispose();
  }
}
