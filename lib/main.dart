import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'core/api/api_config.dart';
import 'core/di/dependency_injection.dart';
import 'core/routes/routes.dart';
import 'core/utils/auth_guard.dart';
import 'core/utils/bloc_setup.dart';
import 'features/user/chat/services/chat_bot_service.dart';
import 'yalla_rehla_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // إضافة هذا السطر لتجاهل مشاكل SSL (للتطوير فقط)
  HttpOverrides.global = MyHttpOverrides();

  final geminiApiKey = ApiConfig.getGeminiApiKey();

  if (geminiApiKey != null) {
    ChatBotService.initialize(geminiApiKey: geminiApiKey);
    log('✅ ChatBotService initialized with Gemini API');
  } else {
    ChatBotService.initialize();
    log('⚠️ ChatBotService initialized without Gemini API');
  }

  // طباعة حالة مفاتيح الـ API (اختياري)
  if (ApiConfig.isDevelopment) {
    ApiConfig.printApiKeysStatus();
  }

  try {
    await setupGetIt();
    log('GetIt setup completed successfully');
  } catch (e) {
    log('Error setting up GetIt: $e');
  }

  // Initialize BLoC system
  await initBloc();

  // Initialize Hydrated Bloc
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );

  // Get the correct initial route based on user state
  final initialRoute = await _getCorrectInitialRoute();
  log('Initial Route: $initialRoute');

  runApp(YallaRehlaApp(initialRoute: initialRoute));
}

/// Determines the correct initial route based on user's state
Future<String> _getCorrectInitialRoute() async {
  try {
    // Check if it's the first time user opens the app
    final isFirstTime = await AuthGuard.isFirstTime();

    if (isFirstTime) {
      log('First time user - showing onboarding');
      return Routes.onboarding1;
    }

    // If not first time, use AuthGuard to determine the correct route
    // This will check both authentication status and saved role
    final authRoute = await AuthGuard.getInitialRoute();
    log('Returning user - route: $authRoute');
    return authRoute;
  } catch (e) {
    log('Error determining initial route: $e');
    // Fallback to onboarding if there's an error
    return Routes.onboarding1;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

// Test credentials:
// Email: a123@gmail.com
// Password: 123456789@mA
// m7m7
// mm111@gmail.com
// 01060796400
