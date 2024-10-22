import 'package:flutter/material.dart';

/// Nested [StreamBuilder]. Please note that updates to [stream1] will rebuild
/// the whole widget including [StreamBuilder] for [stream2].
class StreamBuilder2<S, T> extends StatelessWidget {
  const StreamBuilder2({
    this.key1,
    this.key2,
    this.initialData1,
    this.initialData2,
    this.stream1,
    this.stream2,
    @required this.builder,
  }) : assert(builder != null);

  final Key key1;
  final Key key2;

  final Widget Function(BuildContext context, AsyncSnapshot<S> snapshot1,
      AsyncSnapshot<T> snapshot2) builder;

  final S initialData1;
  final T initialData2;

  final Stream<S> stream1;
  final Stream<T> stream2;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<S>(
      key: key1,
      stream: stream1,
      initialData: initialData1,
      builder: (context, snapshot1) {
        return StreamBuilder<T>(
          key: key2,
          stream: stream2,
          initialData: initialData2,
          builder: (context, snapshot2) {
            return builder(context, snapshot1, snapshot2);
          },
        );
      },
    );
  }
}
