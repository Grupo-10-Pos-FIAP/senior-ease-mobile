import 'package:flutter/material.dart';
import 'package:senior_ease/app/routes.dart';
import 'package:senior_ease/app/splash_screen.dart';
import 'package:senior_ease/shared/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: buildRoutes(),
    );
  }
}
