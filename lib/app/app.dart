import 'package:flutter/material.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/app/routes.dart';
import 'package:senior_ease/app/splash_screen.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/theme/app_theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuilds the whole app whenever personalization changes (Settings
    // save, or the post-login/startup sync), so every screen re-reads the
    // just-updated AppDesignTokens getters immediately — no restart needed.
    return ListenableBuilder(
      listenable: sl<AppModeController>(),
      builder: (context, _) {
        final appMode = sl<AppModeController>();
        AppDesignTokens.configure(
          fontScale: appMode.fontScale,
          spacingScale: appMode.spacingScale,
          contrast: appMode.contrastLevel,
        );
        return MaterialApp(
          theme: AppTheme.lightTheme,
          home: const SplashScreen(),
          routes: buildRoutes(),
        );
      },
    );
  }
}
