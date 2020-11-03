import 'package:flutter_chat/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class KeyStorageService {
  bool hasNotificationsEnabled;
}

class KeyStorageServiceImpl implements KeyStorageService {
  static const notifications_key = 'notifications_key';

  static KeyStorageServiceImpl _instance;
  static SharedPreferences _preferences;

  static Future<KeyStorageServiceImpl> getInstance() async {
    _instance ??= KeyStorageServiceImpl();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  @override
  bool get hasNotificationsEnabled => _getFromDisk(notifications_key) ?? false;

  @override
  set hasNotificationsEnabled(bool value) => _saveToDisk(notifications_key, value);

  dynamic _getFromDisk(String key) {
    final value = _preferences.get(key);
    Log.d('LocalStorageService: (Fetching) key: $key value: $value');
    return value;
  }

  void _saveToDisk<T>(String key, T content) {
    Log.d('LocalStorageService: (Saving) key: $key value: $content');

    if (content is String) {
      _preferences.setString(key, content);
    }
    if (content is bool) {
      _preferences.setBool(key, content);
    }
    if (content is int) {
      _preferences.setInt(key, content);
    }
    if (content is double) {
      _preferences.setDouble(key, content);
    }
    if (content is List<String>) {
      _preferences.setStringList(key, content);
    }
  }
}
