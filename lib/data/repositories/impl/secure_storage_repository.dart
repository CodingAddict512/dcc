import 'package:dcc/data/repositories/secure_storage_repository_interface.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository extends ISecureStorageRepository {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<String> getKey(String key) {
    return secureStorage.read(key: key);
  }

  Future<void> setKey(String key, String value) {
    return secureStorage.write(key: key, value: value);
  }

  Future<void> deleteAll() {
    return secureStorage.deleteAll();
  }
}
