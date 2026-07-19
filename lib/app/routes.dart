import 'package:flutter/material.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/app/profile_shell_screen.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/auth/presentation/screens/login_screen.dart';
import 'package:senior_ease/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:senior_ease/features/tasks/presentation/screens/activity_stage_screen.dart';
import 'package:senior_ease/features/tasks/presentation/screens/activity_steps_screen.dart';

Map<String, WidgetBuilder> buildRoutes() {
  return {
    // Not `const` — a `const` child would be the exact same widget instance
    // on every rebuild, and Flutter skips rebuilding a subtree entirely
    // when it gets back an identical const widget. That would silently
    // defeat _reactiveToAppMode below: notifyListeners() would still fire,
    // but nothing under it would actually re-render.
    RouteNames.login: _reactiveToAppMode((context) => LoginScreen()),
    RouteNames.home: _reactiveToAppMode((context) => DashboardScreen()),
    RouteNames.steps: _reactiveToAppMode((context) => ActivityStepsScreen()),
    RouteNames.stage: _reactiveToAppMode((context) => ActivityStageScreen()),
    RouteNames.profile: _reactiveToAppMode((context) => ProfileShellScreen()),
  };
}

/// Routed screens sit on the Navigator's stack and aren't rebuilt just
/// because [MainApp]'s own top-level `ListenableBuilder` reran — that only
/// refreshes the static `AppDesignTokens` values, not already-mounted
/// screens. Subscribing each route to [AppModeController] directly makes
/// personalization changes (Settings save) apply immediately everywhere,
/// including screens already on the back stack, without needing to
/// navigate away first.
WidgetBuilder _reactiveToAppMode(WidgetBuilder builder) {
  return (context) => ListenableBuilder(
    listenable: sl<AppModeController>(),
    builder: (context, _) => builder(context),
  );
}
