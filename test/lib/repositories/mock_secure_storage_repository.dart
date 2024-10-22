import 'package:dcc/data/repositories/secure_storage_repository_interface.dart';

class MockSecureStorageRepository extends ISecureStorageRepository {
  final Map<String, String> storageMap = new Map();

  // Short-hand for initializing it in tests with a predefined value.
  MockSecureStorageRepository withKeySet(String key, String value) {
    storageMap[key] = value;
    return this;
  }

  Future<String> getUsername() async {
    return storageMap[StorageKeys.firestoreUsername];
  }

  Future<String> getPassword() async {
    return storageMap[StorageKeys.firestorePassword];
  }

  Future<String> getKey(String key) async {
    return storageMap[key];
  }

  Future<void> setKey(String key, String value) async {
    storageMap[key] = value;
  }

  @override
  Future<void> deleteAll() async {
    storageMap.clear();
  }
}
