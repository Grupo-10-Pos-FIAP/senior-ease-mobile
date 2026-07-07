import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class AppTitle extends StatelessWidget {
  const AppTitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppDesignTokens.fontSizeTitle,
        fontWeight: AppDesignTokens.fontWeightSemibold,
        color: AppDesignTokens.colorContentDefault,
      ),
    );
  }
}
