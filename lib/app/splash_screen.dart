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

    Future.delayed(const Duration(seconds: 4), () async {
      final auth = sl<AuthController>();
      var isSignedIn = auth.currentUser != null;

      if (isSignedIn && await auth.isCurrentAccountDeactivated()) {
        await auth.signOut();
        isSignedIn = false;
      }

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
