import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class AppLabel extends StatelessWidget {
  const AppLabel(this.text, {super.key, this.textAlign});

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: AppDesignTokens.fontSizeBody,
        fontWeight: AppDesignTokens.fontWeightMedium,
        color: AppDesignTokens.colorContentSecondary,
      ),
    );
  }
}
