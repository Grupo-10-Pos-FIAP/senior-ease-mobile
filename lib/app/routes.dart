import 'package:flutter/material.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/app/profile_shell_screen.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/auth/presentation/screens/login_screen.dart';
import 'package:senior_ease/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:senior_ease/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:senior_ease/features/tasks/presentation/screens/activity_stage_screen.dart';
import 'package:senior_ease/features/tasks/presentation/screens/activity_steps_screen.dart';

Map<String, WidgetBuilder> buildRoutes() {
  return {
    RouteNames.login: _reactiveToAppMode((context) => LoginScreen()),
    RouteNames.home: _reactiveToAppMode((context) => DashboardScreen()),
    RouteNames.steps: _reactiveToAppMode((context) => ActivityStepsScreen()),
    RouteNames.stage: _reactiveToAppMode((context) => ActivityStageScreen()),
    RouteNames.profile: _reactiveToAppMode((context) => ProfileShellScreen()),
    RouteNames.editProfile: _reactiveToAppMode(
      (context) => EditProfileScreen(),
    ),
  };
}

WidgetBuilder _reactiveToAppMode(WidgetBuilder builder) {
  return (context) => ListenableBuilder(
    listenable: sl<AppModeController>(),
    builder: (context, _) => builder(context),
  );
}
