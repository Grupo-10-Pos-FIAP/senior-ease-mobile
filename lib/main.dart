import 'package:flutter/material.dart';
import 'package:senior_ease/screens/activity_stage_screen.dart';
import 'package:senior_ease/screens/activity_steps_screen.dart';
import 'package:senior_ease/screens/home_screen.dart';
import 'package:senior_ease/screens/profile_screen.dart';
import 'package:senior_ease/screens/splash_screen.dart';
import 'package:senior_ease/shared/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/steps': (context) => const ActivityStepsScreen(),
        '/stage': (context) => const ActivityStageScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
