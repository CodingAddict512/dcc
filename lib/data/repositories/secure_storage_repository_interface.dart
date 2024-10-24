class StorageKeys {
  static const String firestoreUsername = "firestoreUsername";
  static const String firestorePassword = "firestorePassword";
}

abstract class ISecureStorageRepository {
  Future<String> getUsername() => getKey(StorageKeys.firestoreUsername);
  Future<String> getPassword() => getKey(StorageKeys.firestorePassword);

  Future<void> setUsername(String value) => setKey(StorageKeys.firestoreUsername, value);
  Future<void> setPassword(String value) => setKey(StorageKeys.firestorePassword, value);

  // Returns null if key is not set
  Future<String> getKey(String keyName);
  Future<void> setKey(String keyName, String value);

  Future<void> deleteAll();
}
