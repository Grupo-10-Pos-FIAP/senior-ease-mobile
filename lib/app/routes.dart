import 'package:flutter/material.dart';
import 'package:senior_ease/app/profile_shell_screen.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:senior_ease/features/tasks/presentation/screens/activity_stage_screen.dart';
import 'package:senior_ease/features/tasks/presentation/screens/activity_steps_screen.dart';

Map<String, WidgetBuilder> buildRoutes() {
  return {
    RouteNames.home: (context) => const DashboardScreen(),
    RouteNames.steps: (context) => const ActivityStepsScreen(),
    RouteNames.stage: (context) => const ActivityStageScreen(),
    RouteNames.profile: (context) => const ProfileShellScreen(),
  };
}
