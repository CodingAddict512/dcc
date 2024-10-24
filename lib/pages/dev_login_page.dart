import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/firestore_configuration.dart';
import 'package:dcc/widgets/bloc_sub_state/bloc_sub_state_builder.dart';
// import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeveloperLoginPage extends StatelessWidget {
  final TextEditingController _apiKeyTextController =
      new TextEditingController();
  final TextEditingController _googleAppIdTextController =
      new TextEditingController();
  final TextEditingController _projectIdTextController =
      new TextEditingController();
  final TextEditingController _messagingSenderIdTextController =
      new TextEditingController();
  final TextEditingController _usernameTextController =
      new TextEditingController();
  final TextEditingController _passwordTextController =
      new TextEditingController();

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
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                style: TextStyle(fontSize: 20.0),
                controller: _apiKeyTextController,
                decoration: InputDecoration(
                  hintText:
                      "API Key", // [DEV-Only] Don't bother with translations
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                style: TextStyle(fontSize: 20.0),
                controller: _googleAppIdTextController,
                decoration: InputDecoration(
                  hintText:
                      "Google APP ID", // [DEV-Only] Don't bother with translations
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                style: TextStyle(fontSize: 20.0),
                controller: _projectIdTextController,
                decoration: InputDecoration(
                  hintText:
                      "Project ID", // [DEV-Only] Don't bother with translations
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                style: TextStyle(fontSize: 20.0),
                controller: _messagingSenderIdTextController,
                decoration: InputDecoration(
                  hintText:
                      "Message Sender ID", // [DEV-Only] Don't bother with translations
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                style: TextStyle(fontSize: 20.0),
                controller: _usernameTextController,
                decoration: InputDecoration(
                  hintText:
                      "Username", // [DEV-Only] Don't bother with translations
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                obscureText: true,
                style: TextStyle(fontSize: 20.0),
                controller: _passwordTextController,
                decoration: InputDecoration(
                  hintText:
                      "Password", // [DEV-Only] Don't bother with translations
                ),
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            ElevatedButton(
              child: Text(DccLocalizations.of(context)!
                  .translate("enterKeyPageSubmit")),
              onPressed: () async {
                FirestoreConfiguration config = FirestoreConfiguration(
                  apiKey: _apiKeyTextController.text,
                  googleAppId: _googleAppIdTextController.text,
                  projectId: _projectIdTextController.text,
                  messagingSenderId: _messagingSenderIdTextController.text,
                );
                await userCubit.devLoginWithEmailAndPassword(config,
                    _usernameTextController.text, _passwordTextController.text);
                if (userCubit.state is UserError) {
                  // FlushbarHelper.createError(
                  //         message: "Login failed.",
                  //         duration: Duration(seconds: 3))
                  //     .show(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Login failed."),
                      duration: Duration(seconds: 3),
                    ),
                  );
                } else {
                  navigator.pop();
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
