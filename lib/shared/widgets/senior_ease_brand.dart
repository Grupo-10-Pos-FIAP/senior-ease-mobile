import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class SeniorEaseBrand extends StatelessWidget {
  const SeniorEaseBrand({
    super.key,
    this.fontSize,
    this.onTap,
  });

  final double? fontSize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final size = fontSize ?? AppDesignTokens.fontSizeTitle;
    final text = Text(
      'SeniorEASE',
      style: TextStyle(
        color: AppDesignTokens.colorPrimary,
        fontSize: size,
        fontWeight: AppDesignTokens.fontWeightBold,
        letterSpacing: size * 0.02,
        height: AppDesignTokens.lineHeightTitle,
      ),
    );

    if (onTap == null) return text;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: text,
    );
  }
}
