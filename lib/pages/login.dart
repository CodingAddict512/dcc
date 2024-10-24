// import 'package:dcc/cubits/states/user_state.dart';
// import 'package:dcc/cubits/user_cubit.dart';
// import 'package:dcc/localization/app_localizations.dart';
// import 'package:dcc/models/user_error_type.dart';
// import 'package:dcc/pages/enter_key.dart';
// import 'package:dcc/pages/scan_page.dart';
// import 'package:dcc/pages/settings.dart';
// import 'package:flushbar/flushbar_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'dev_login_page.dart';

// class LoginPage extends StatelessWidget {
//   static const _padding = 16.0;
//   static const _innerPadding = 8.0;
//   static const _buttonInnerPadding = 16.0;

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     final localization = DccLocalizations.of(context);
//     final navigator = Navigator.of(context);

//     void returnToPreviousPage() {
//       Navigator.pop(context);
//     }

//     Widget loading() {
//       return Center(
//         child: CircularProgressIndicator(),
//       );
//     }

//     Widget _qr_button() {
//       return Padding(
//         padding: EdgeInsets.all(_innerPadding),
//         child: Padding(
//           padding: EdgeInsets.all(_buttonInnerPadding),
//           child: ElevatedButton(
//             child: Text(localization.translate("loginBtnSignInWithQr")),
//             onPressed: () async {
//               final success = await navigator.push(MaterialPageRoute(
//                 builder: (context) => ScanPage(),
//               ));
//               if (success is bool && !success) {
//                 // Scan page can not show Flushbar using qr handler context.
//                 // We are deliberately vague in the error message.  It is not like
//                 // the user is expected "fix" the QR code anyway.
//                 FlushbarHelper.createError(
//                   message: localization.translate("scanPageInvalidQr"),
//                   duration: Duration(seconds: 3),
//                 ).show(context);
//               }
//             },
//           ),
//         )
//       );
//     }

//     Widget _key_button() {
//       return Padding(
//         padding: EdgeInsets.all(_innerPadding),
//         child: Padding(
//           padding: EdgeInsets.all(_buttonInnerPadding),
//           child: ElevatedButton(
//             child: Text(localization.translate("loginBtnSignInWithKey")),
//             onPressed: () {
//               navigator.push(MaterialPageRoute(
//                 builder: (context) => EnterKeyPage(),
//               ));
//             },
//           ),
//         ),
//       );
//     }

//     Widget _settings_page_button() {
//       return Padding(
//         padding: EdgeInsets.all(_innerPadding),
//         child: Padding(
//           padding: EdgeInsets.all(_buttonInnerPadding),
//           child: ElevatedButton(
//             child: Text(DccLocalizations.of(context).translate("settingsPageSettings")),
//             onPressed: () {
//               navigator.push(MaterialPageRoute(
//                 builder: (context) => SettingsPage(),
//               ));
//             },
//           ),
//         ),
//       );
//     }

//     Widget _developer_only_expert_login_button() {
//       return Padding(
//         padding: EdgeInsets.all(_innerPadding),
//         child: Padding(
//           padding: EdgeInsets.all(_buttonInnerPadding),
//           child: ElevatedButton(
//             child: Text("Developer login (Dev mode only)"), /* No translation needed (dev builds only)*/
//             onPressed: () {
//               navigator.push(MaterialPageRoute(
//                 builder: (context) => DeveloperLoginPage(),
//               ));
//             },
//           ),
//         ),
//       );
//     }

//     Widget loginForm() {
//       List<Widget> loginOptions = [
//         _qr_button(),
//         _key_button(),
//       ];
//       // Abuse assert to tell dev builds from production builds.
//       assert(() {
//         loginOptions.add(_developer_only_expert_login_button());
//         return true;
//       }());
//       loginOptions.add(_settings_page_button());
//       return Padding(
//         padding: EdgeInsets.symmetric(horizontal: _padding),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: loginOptions,
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: null,
//       body: BlocConsumer<IUserCubit, UserState>(
//         listener: (context, state) {
//           if (state is UserError) {
//             String message = null;
//             if (state.errorType != UserErrorType.UNKNOWN) {
//               message = localization.translate(state.errorType.messageTranslationKey());
//             }
//             FlushbarHelper.createError(
//               message: message ?? state.message,
//               duration: Duration(seconds: 3),
//             ).show(context);
//           } else if (state is UserLoggedIn) {
//             returnToPreviousPage();
//           }
//         },
//         builder: (context, state) {
//           if (state is UserError || state is UserInitial) {
//             return loginForm();
//           }
//           return loading();
//         },
//       ),
//     );
//   }
// }

import 'package:dcc/cubits/states/user_state.dart';
import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/models/user_error_type.dart';
import 'package:dcc/pages/enter_key.dart';
import 'package:dcc/pages/scan_page.dart';
import 'package:dcc/pages/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'dev_login_page.dart';

class LoginPage extends StatelessWidget {
  static const _padding = 16.0;
  static const _innerPadding = 8.0;
  static const _buttonInnerPadding = 16.0;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final localization = DccLocalizations.of(context);
    final navigator = Navigator.of(context);

    void returnToPreviousPage() {
      Navigator.pop(context);
    }

    Widget loading() {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // Function to show a SnackBar
    void showErrorSnackBar(BuildContext context, String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }

    Widget _qr_button() {
      return Padding(
        padding: EdgeInsets.all(_innerPadding),
        child: Padding(
          padding: EdgeInsets.all(_buttonInnerPadding),
          child: ElevatedButton(
            child: Text(localization!.translate("loginBtnSignInWithQr")),
            onPressed: () async {
              final success = await navigator.push(MaterialPageRoute(
                builder: (context) => ScanPage(),
              ));
              if (success is bool && !success) {
                showErrorSnackBar(
                  context,
                  localization!.translate("scanPageInvalidQr"),
                );
              }
            },
          ),
        ),
      );
    }

    Widget _key_button() {
      return Padding(
        padding: EdgeInsets.all(_innerPadding),
        child: Padding(
          padding: EdgeInsets.all(_buttonInnerPadding),
          child: ElevatedButton(
            child: Text(localization!.translate("loginBtnSignInWithKey")),
            onPressed: () {
              navigator.push(MaterialPageRoute(
                builder: (context) => EnterKeyPage(),
              ));
            },
          ),
        ),
      );
    }

    Widget _settings_page_button() {
      return Padding(
        padding: EdgeInsets.all(_innerPadding),
        child: Padding(
          padding: EdgeInsets.all(_buttonInnerPadding),
          child: ElevatedButton(
            child: Text(DccLocalizations.of(context)!
                .translate("settingsPageSettings")),
            onPressed: () {
              navigator.push(MaterialPageRoute(
                builder: (context) => SettingsPage(),
              ));
            },
          ),
        ),
      );
    }

    Widget _developer_only_expert_login_button() {
      return Padding(
        padding: EdgeInsets.all(_innerPadding),
        child: Padding(
          padding: EdgeInsets.all(_buttonInnerPadding),
          child: ElevatedButton(
            child: Text("Developer login (Dev mode only)"),
            /* No translation needed (dev builds only)*/
            onPressed: () {
              navigator.push(MaterialPageRoute(
                builder: (context) => DeveloperLoginPage(),
              ));
            },
          ),
        ),
      );
    }

    Widget loginForm() {
      List<Widget> loginOptions = [
        _qr_button(),
        _key_button(),
      ];
      // Abuse assert to tell dev builds from production builds.
      assert(() {
        loginOptions.add(_developer_only_expert_login_button());
        return true;
      }());
      loginOptions.add(_settings_page_button());
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: _padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: loginOptions,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: null,
      body: BlocConsumer<IUserCubit, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            String message = "";
            if (state.errorType != UserErrorType.UNKNOWN) {
              message = localization!.translate(state.errorType.name);
            }
            showErrorSnackBar(
              context,
              message ?? state.message,
            );
          } else if (state is UserLoggedIn) {
            returnToPreviousPage();
          }
        },
        builder: (context, state) {
          if (state is UserError || state is UserInitial) {
            return loginForm();
          }
          return loading();
        },
      ),
    );
  }
}
