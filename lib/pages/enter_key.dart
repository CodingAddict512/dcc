import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/otp_code_parser.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';

class EnterKeyPage extends StatelessWidget {
  final TextEditingController _textController = new TextEditingController();

  Widget _loading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    final userCubit = context.watch<IUserCubit>();
    final navigator = Navigator.of(context);

    Widget _enterKeyPage() {
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
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                style: TextStyle(fontSize: 20.0),
                controller: _textController,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              child: Text(DccLocalizations.of(context).translate("enterKeyPageSubmit")),
              onPressed: () async {
                final otpCodeParser = OTPCodeParser();
                if (otpCodeParser.parse(_textController.text)) {
                  await userCubit.otpLogin(otpCodeParser.email, otpCodeParser.otp, otpCodeParser.verifyUrl);
                  navigator.pop();
                } else {
                  // We are deliberately vague in the error message.  It is not like
                  // the user is expected "fix" the setup code anyway.
                  FlushbarHelper.createError(message: DccLocalizations.of(context).translate("scanPageInvalidSetupCode"), duration: Duration(seconds: 3)).show(context);
                }
              },
            )
          ],
        ),
      );
    }

    return BlocSubStateBuilder<IUserCubit, UserState, UserLoading>(
      subStateBuilder: (context, state) => _loading(),
      fallbackBuilder: (context, state) => _enterKeyPage(),
    );
  }
}
