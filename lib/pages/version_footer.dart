import 'package:dcc/cubits/states/version_state.dart';
import 'package:dcc/cubits/version_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionFooterWidget extends StatelessWidget {

  Widget loading() => Center(child: CircularProgressIndicator());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VersionCubit, VersionState>(
      builder: (context, state) {
        if (state is VersionLoaded) {
          PackageInfo pkgInfo = state.packageInfo;
          return Text("${pkgInfo.appName} v${pkgInfo.version} (b${pkgInfo.buildNumber})");
        }
        return loading();
      },
    );
  }
}
