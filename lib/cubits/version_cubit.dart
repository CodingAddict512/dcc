import 'package:dcc/cubits/states/version_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionCubit extends Cubit<VersionState> {
  VersionCubit() : super(VersionNotLoaded()) {
    this._ensureLoaded();
  }

  factory VersionCubit.fromContext(BuildContext context) => VersionCubit();

  void _ensureLoaded() async {
    if (!(state is VersionLoaded)) {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      emit(VersionLoaded(packageInfo: packageInfo));
    }
  }

}
