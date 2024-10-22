import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocSubStateBuilder<C extends Cubit<S>, S, T extends S>
    extends BlocBuilder<C, S> {
  BlocSubStateBuilder({
    Key key,
    @required this.subStateBuilder,
    @required this.fallbackBuilder,
    C cubit,
    BlocBuilderCondition<S> buildWhen,
  })  : assert(subStateBuilder != null && fallbackBuilder != null),
        super(
          key: key,
          builder: (context, state) {
            if (state is T) {
              return subStateBuilder(context, state);
            }
            return fallbackBuilder(context, state);
          },
          cubit: cubit,
          buildWhen: buildWhen,
        );

  final BlocWidgetBuilder<T> subStateBuilder;
  final BlocWidgetBuilder<S> fallbackBuilder;
}
