import 'dart:async';

import 'package:flutter/material.dart';

import '../utils/auth_guard.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = lightTheme;
  static ThemeData dark = darkTheme;

  /// الحصول على التيم الفاتح حسب نوع المستخدم
  static ThemeData getLightTheme(UserRole role) {
    switch (role) {
      case UserRole.traveler:
        return lightTheme;
      case UserRole.admin:
      case UserRole.business:
        // Create a consistent light theme instead of using ThemeData.light()
        return _createConsistentLightTheme();
    }
  }

  /// الحصول على التيم الداكن حسب نوع المستخدم
  static ThemeData getDarkTheme(UserRole role) {
    switch (role) {
      case UserRole.traveler:
        return darkTheme;
      case UserRole.admin:
      case UserRole.business:
        // Return the same consistent light theme for admin/business
        return _createConsistentLightTheme();
    }
  }

  /// Create a consistent light theme for admin/business users
  static ThemeData _createConsistentLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      ),
      // Ensure consistent TextTheme configuration
      textTheme: const TextTheme().apply(
        bodyColor: Colors.black87,
        displayColor: Colors.black87,
      ),
      // Add other consistent theme properties as needed
    );
  }

  static bool canChangeTheme(UserRole role) {
    return role == UserRole.traveler;
  }
}

class ThemeRoleManager {
  static UserRole _currentRole = UserRole.traveler;
  static UserRole? _temporaryRole;
  
  // Add a stream controller to notify about role changes
  static final _roleController = StreamController<UserRole>.broadcast();
  static Stream<UserRole> get roleStream => _roleController.stream;

  static UserRole get currentRole => _temporaryRole ?? _currentRole;

  static Future<void> setTemporaryRole(UserRole role) async {
    _temporaryRole = role;
    _roleController.add(role);
  }

  static Future<void> setRole(UserRole role) async {
    _currentRole = role;
    _temporaryRole = null;
    await AuthGuard.saveUserRole(role);
    _roleController.add(role);
  }

  static Future<UserRole> loadRole() async {
    final savedRole = await AuthGuard.getUserRole();
    _currentRole = savedRole ?? UserRole.traveler;
    _temporaryRole = null;
    return _currentRole;
  }

  static void clearTemporaryRole() {
    _temporaryRole = null;
    _roleController.add(_currentRole);
  }

  static ThemeData getCurrentLightTheme() {
    return AppTheme.getLightTheme(currentRole);
  }

  static ThemeData getCurrentDarkTheme() {
    return AppTheme.getDarkTheme(currentRole);
  }

  static bool canCurrentUserChangeTheme() {
    return AppTheme.canChangeTheme(currentRole);
  }

  static ThemeMode getThemeModeForRole() {
    if (currentRole == UserRole.admin || currentRole == UserRole.business) {
      return ThemeMode.light;
    }
    return ThemeMode.system;
  }

  static Future<void> updateRoleFromAuth() async {
    final role = await AuthGuard.getUserRole();
    if (role != null) {
      _currentRole = role;
      _roleController.add(role);
    }
    _temporaryRole = null;
  }

  static bool hasTemporaryRole() {
    return _temporaryRole != null;
  }

  static UserRole? getTemporaryRole() {
    return _temporaryRole;
  }

  // Dispose method to clean up the stream controller
  static void dispose() {
    _roleController.close();
  }
}