import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// Compat layer for Flutter2
extension Flutter2CubitCompat<T> on Cubit<T> {
  Cubit<T> get stream => this;
}

extension Flutter2BuildContextCompat<T> on BuildContext {
  // C watch<C extends Cubit<Object>>() => this.bloc<C>();
  // C watch<C extends Cubit<Object>>() =>
  //     this.read<C>(); // Use read for current instance
  C read<C extends Cubit<Object>>() => BlocProvider.of<C>(this);
}
