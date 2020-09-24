import 'package:shared_preferences/shared_preferences.dart';

class StorageUtil {
  static StorageUtil _storageUtil;
  static SharedPreferences _preferences;

  static Future<StorageUtil> getInstance() async {
    if (_storageUtil == null) {
      // keep local instance till it is fully initialized.
      var secureStorage = StorageUtil._();
      await secureStorage._init();
      _storageUtil = secureStorage;
    }
    return _storageUtil;
  }

  StorageUtil._();
  Future _init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // get string
  static String getString(String key, {String defValue = ''}) {
    if (_preferences == null) return defValue;
    return _preferences.getString(key) ?? defValue;
  }

  // put string
  static Future<bool> putString(String key, String value) {
    if (_preferences == null) return null;
    return _preferences.setString(key, value);
  }

  // get int
  static int getInt(String key, {int defValue = 2}) {
    if (_preferences == null) return defValue;
    return _preferences.getInt(key) ?? defValue;
  }

  // put int
  static Future<bool> putInt(String key, int value) {
    if (_preferences == null) return null;
    return _preferences.setInt(key, value);
  }

  // get bool
  static bool getBool(String key, {bool defValue}) {
    if (_preferences == null) return defValue;
    return _preferences.getBool(key) ?? defValue;
  }

  // put bool
  static Future<bool> putBool(String key, bool value) {
    if (_preferences == null) return null;
    return _preferences.setBool(key, value);
  }

  // get string list
  static List<String> getStringList(String key, {List<String> defValue}) {
    if (_preferences == null) return defValue;
    return _preferences.getStringList(key) ?? defValue;
  }

  // put string list
  static Future<bool> putStringList(String key, String value) {
    if (_preferences == null) return null;
    List<String> storageValues = getStringList(key);
    if (storageValues != null && storageValues.contains(value)) {
      storageValues.remove(value);
    } else {
      if (storageValues != null) {
        storageValues.add(value);
      } else {
        storageValues = new List<String>();
        storageValues.add(value);
      }
    }
    return _preferences.setStringList(key, storageValues);
  }
}
