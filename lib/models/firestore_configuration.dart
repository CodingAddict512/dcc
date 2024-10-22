import 'package:freezed_annotation/freezed_annotation.dart';

part 'firestore_configuration.freezed.dart';

@freezed
abstract class FirestoreConfiguration implements _$FirestoreConfiguration {

  FirestoreConfiguration._();

  factory FirestoreConfiguration({
    final String apiKey,
    final String googleAppId,
    final String projectId,
    final String messagingSenderId,
  }) = _FirestoreConfiguration;

  factory FirestoreConfiguration.fromPreferenceValue(String value) {
    List<String> values = value.split("\x1f");
    if (values.length != 5 || values[0] != "v1") {
      throw new Exception("Invalid firestore configuration");
    }
    return FirestoreConfiguration(
      apiKey: values[1],
      googleAppId: values[2],
      projectId: values[3],
      messagingSenderId: values[4],
    );
  }

  String toPreferenceValue() {
    return "v1"
        + "\x1f" + this.apiKey
        + "\x1f" + this.googleAppId
        + "\x1f" + this.projectId
        + "\x1f" + this.messagingSenderId
    ;
  }
}
