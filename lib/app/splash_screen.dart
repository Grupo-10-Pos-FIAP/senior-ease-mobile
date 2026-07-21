import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/settings/presentation/controllers/settings_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simular carregamento do app
    Future.delayed(const Duration(seconds: 4), () async {
      final auth = sl<AuthController>();
      var isSignedIn = auth.currentUser != null;
      // Firebase Auth's own session says nothing about "Excluir conta" —
      // that only flags Firestore. A device that was already signed in
      // when the account got deactivated (elsewhere, or in a previous
      // session) needs to be caught here too, not just at the login form.
      if (isSignedIn && await auth.isCurrentAccountDeactivated()) {
        await auth.signOut();
        isSignedIn = false;
      }
      // Personalization (contrast, font size, etc.) otherwise only synced
      // once the Settings screen was visited — load it before the first
      // screen after splash builds, so Dashboard reflects it immediately
      // instead of showing default styling until the user opens Settings.
      if (isSignedIn) {
        await sl<SettingsController>().load();
      }
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacementNamed(isSignedIn ? RouteNames.home : RouteNames.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              'lib/assets/img-loading-initial.svg',
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Align(
            alignment: const FractionalOffset(0.5, 0.60),
            child: const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
