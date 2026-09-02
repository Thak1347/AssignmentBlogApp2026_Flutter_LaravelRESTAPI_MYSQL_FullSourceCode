import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _storage = GetStorage();
  final _darkModeKey = 'dark_mode';

  final isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _storage.read<bool>(_darkModeKey) ?? false;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write(_darkModeKey, isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
