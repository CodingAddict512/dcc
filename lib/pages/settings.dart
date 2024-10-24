import 'package:dcc/cubits/user_cubit.dart';
import 'package:dcc/localization/app_localizations.dart';
import 'package:dcc/pages/version_footer.dart';
import 'package:dcc/widgets/settings/language_selection.dart';
import 'package:dcc/widgets/settings/logout_button.dart';
import 'package:dcc/widgets/settings/theme_selection.dart';
import 'package:flutter/material.dart';
import 'package:dcc/extensions/compat.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  Widget _logout() {
    return Padding(
      padding: EdgeInsets.only(right: 16.0),
      child: Row(
        children: [
          LogoutButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userCubit = context.watch<IUserCubit>();

    List<Widget> appBarActions = [];

    if (userCubit.state.isLoggedIn()) {
      // If the user is not logged in, the log out button does not do anything
      // useful, so we might as well hide it.
      appBarActions.add(_logout());
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
              DccLocalizations.of(context)!.translate("settingsPageSettings")),
          actions: appBarActions,
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
                delegate: SliverChildListDelegate([
              ListView(
                shrinkWrap: true,
                children: [
                  LanguageSelection(),
                  ThemeSelection(),
                ],
              )
            ])),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 50,
                  child: Center(child: VersionFooterWidget()),
                ),
              ),
            )
          ],
        ));
  }
}
