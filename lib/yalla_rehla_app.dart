import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';

import 'core/routes/app_router.dart';
import 'core/themes/app_theme.dart';
import 'core/themes/cubit/locale_cubit.dart';
import 'core/themes/cubit/theme_cubit.dart';
import 'core/utils/auth_guard.dart';
import 'core/utils/languages.dart';
import 'generated/l10n.dart';

final sl = GetIt.instance;

class YallaRehlaApp extends StatefulWidget {
  final String initialRoute;
  const YallaRehlaApp({super.key, required this.initialRoute});

  @override
  State<YallaRehlaApp> createState() => _YallaRehlaAppState();
}

class _YallaRehlaAppState extends State<YallaRehlaApp> {
  UserRole _currentUserRole = UserRole.traveler;
  StreamSubscription<UserRole>? _roleSubscription;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    _setupRoleListener();
  }

  @override
  void dispose() {
    _roleSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadUserRole() async {
    final role = await ThemeRoleManager.loadRole();
    if (mounted) {
      setState(() {
        _currentUserRole = role;
      });
    }
  }

  void _setupRoleListener() {
    _roleSubscription = ThemeRoleManager.roleStream.listen((role) {
      if (mounted) {
        setState(() {
          _currentUserRole = role;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sl<ThemeCubit>()),
        BlocProvider.value(value: sl<LocaleCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              // Get themes based on current role
              final lightTheme = AppTheme.getLightTheme(_currentUserRole);
              final darkTheme = AppTheme.getDarkTheme(_currentUserRole);

              // Determine effective theme mode
              ThemeMode effectiveThemeMode;
              if (_currentUserRole == UserRole.admin ||
                  _currentUserRole == UserRole.business) {
                effectiveThemeMode = ThemeMode.light;
              } else {
                effectiveThemeMode = themeMode;
              }

              return MaterialApp(
                title: 'Travel Explorer',
                debugShowCheckedModeBanner: false,
                locale: locale,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: Languages.all,
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: effectiveThemeMode,
                onGenerateRoute: AppRouter.generateRoute,
                initialRoute: widget.initialRoute,
              );
            },
          );
        },
      ),
    );
  }
}
