import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class AppInfo extends StatelessWidget {
  const AppInfo(this.text, {super.key, this.textAlign});

  final String text;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: AppDesignTokens.fontSizeBody,
        fontWeight: AppDesignTokens.fontWeightRegular,
        color: AppDesignTokens.colorContentSecondary,
      ),
    );
  }
}