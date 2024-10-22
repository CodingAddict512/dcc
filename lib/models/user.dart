import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User implements _$User {
  User._();

  factory User({
    final String transporterId,
    final String driverId,
  }) = _User;
}
