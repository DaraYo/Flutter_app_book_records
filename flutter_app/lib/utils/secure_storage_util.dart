import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageUtil {
  static SecureStorageUtil _secureStorageUtil;
  static FlutterSecureStorage _secureAppStorage;

  static Future<SecureStorageUtil> getInstance() async {
    if (_secureStorageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = SecureStorageUtil._();
      await secureStorage._init();
      _secureStorageUtil = secureStorage;
    }
    return _secureStorageUtil;
  }

  SecureStorageUtil._();
  Future _init() async {
    _secureAppStorage = FlutterSecureStorage();
  }

  static Future<String> read(String key, {String defValue = ''}) async {
    if (_secureAppStorage == null) return defValue;
    return await _secureAppStorage.read(key: key);
  }

  static Future<Map<String, String>> readAll(String key) async {
    if (_secureAppStorage == null) return null;
    return await _secureAppStorage.readAll();
  }

  static Future<void> write(String key, String value) async {
    if (_secureAppStorage == null) return null;
    return await _secureAppStorage.write(key: key, value: value);
  }

  static Future<void> delete(String key) async {
    if (_secureAppStorage == null) return null;
    return await _secureAppStorage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    if (_secureAppStorage == null) return null;
    return await _secureAppStorage.deleteAll();
  }
}
