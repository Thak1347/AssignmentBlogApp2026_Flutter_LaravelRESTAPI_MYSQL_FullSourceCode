import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/app_config.dart';
import '../models/user_model.dart';

class StorageService {
  final GetStorage _storage = GetStorage();

  // Token Management
  void saveToken(String token) {
    _storage.write(AppConfig.tokenKey, token);
  }

  String? getToken() {
    return _storage.read<String>(AppConfig.tokenKey);
  }

  void removeToken() {
    _storage.remove(AppConfig.tokenKey);
  }

  bool hasToken() {
    return _storage.read<String>(AppConfig.tokenKey) != null;
  }

  // User Management
  void saveUser(UserModel user) {
    _storage.write(AppConfig.userKey, user.toJson());
  }

  UserModel? getUser() {
    final data = _storage.read<Map<String, dynamic>>(AppConfig.userKey);
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }

  void removeUser() {
    _storage.remove(AppConfig.userKey);
  }

  // Remember Me
  void setRememberMe(bool value) {
    _storage.write(AppConfig.rememberMeKey, value);
  }

  bool getRememberMe() {
    return _storage.read<bool>(AppConfig.rememberMeKey) ?? false;
  }

  // Clear All
  void clearAll() {
    _storage.erase();
  }

  // SharedPreferences for additional storage
  Future<void> saveToSharedPreferences(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String?> getFromSharedPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<void> removeFromSharedPreferences(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
