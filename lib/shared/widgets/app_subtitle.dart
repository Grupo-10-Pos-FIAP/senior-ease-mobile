import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class AppSubtitle extends StatelessWidget {
  const AppSubtitle({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: AppDesignTokens.fontSizeSubtitle,
        fontWeight: AppDesignTokens.fontWeightSemibold,
        color: AppDesignTokens.colorContentDefault,
      ),
    );
  }
}
