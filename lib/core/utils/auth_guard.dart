import 'dart:developer';

import '../api/api_constants.dart';
import '../cache/shared_pref_helper.dart';
import '../routes/routes.dart';

enum UserRole { admin, business, traveler }

class AuthGuard {
  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await SharedPrefHelper.getSecuredString(SharedPrefKeys.token);
    log('Token from SharedPrefs: ${token.isNotEmpty ? "EXISTS ✅" : "EMPTY ❌"}');
    return token.isNotEmpty;
  }

  // Save user role
  static Future<void> saveUserRole(UserRole role) async {
    await SharedPrefHelper.setData(SharedPrefKeys.userRole, role.name);
    log('User role saved: ${role.name}');
  }

  // Get saved user role
  static Future<UserRole?> getUserRole() async {
    final roleString = await SharedPrefHelper.getString(
      SharedPrefKeys.userRole,
    );
    if (roleString.isEmpty) return null;

    try {
      final role = UserRole.values.firstWhere((r) => r.name == roleString);
      log('User role retrieved: ${role.name}');
      return role;
    } catch (e) {
      log('Error getting user role: $e');
      return null;
    }
  }

  // Get initial route based on auth status and role
  static Future<String> getInitialRoute() async {
    final isAuthenticated = await isLoggedIn();
    final savedRole = await getUserRole();

    // If user is not authenticated, check if they have selected a role
    if (!isAuthenticated) {
      if (savedRole == null) {
        // No role selected, go to role selection
        log('No role selected, going to role selection');
        return Routes.roleSelection;
      } else {
        // Role selected but not authenticated, go to appropriate login
        final route = _getLoginRouteForRole(savedRole);
        log('User role: ${savedRole.name}, going to login: $route');
        return route;
      }
    }

    // User is authenticated, go to appropriate main screen
    final route = _getMainRouteForRole(savedRole ?? UserRole.traveler);
    log(
      'User authenticated with role: ${savedRole?.name ?? 'traveler'}, Route: $route',
    );
    return route;
  }

  // Get login route based on role
  static String _getLoginRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Routes.adminLogin;
      case UserRole.business:
        return Routes.businessLogin;
      case UserRole.traveler:
        return Routes.travelerLogin;
    }
  }

  // Get main route based on role

  static String _getMainRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return Routes.host; // Use existing host screen for now
      case UserRole.business:
        return Routes.host; // Use existing host screen for now
      case UserRole.traveler:
        return Routes.host;
    }
  }

  // Logout user
  static Future<void> logout() async {
    await SharedPrefHelper.clearAllData();
    await SharedPrefHelper.clearAllSecuredData();
    log('User logged out');
  }

  // Check if this is first time user
  static Future<bool> isFirstTime() async {
    final isFirst = await SharedPrefHelper.getBool(SharedPrefKeys.isFirstTime);
    log('Is first time: ${!isFirst}');
    return !isFirst; // Returns true if it's first time (default false)
  }

  // Set first time to false
  static Future<void> setNotFirstTime() async {
    await SharedPrefHelper.setData(SharedPrefKeys.isFirstTime, true);
    log('First time set to false');
  }

  // Clear user role (useful for testing or changing role)
  static Future<void> clearUserRole() async {
    await SharedPrefHelper.removeData(SharedPrefKeys.userRole);
    log('User role cleared');
  }
}
