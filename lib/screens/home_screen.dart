import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: SvgPicture.asset(
          'lib/assets/logo.svg',
          width: 140,
          fit: BoxFit.contain,
        ),
      ),
      body: Container(
        color: const Color(0xFFF9F9F9),
        child: const Center(child: Text('Welcome to SeniorEase!')),
      ),
    );
  }
}
