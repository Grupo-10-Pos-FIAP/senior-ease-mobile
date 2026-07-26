import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

/// Marca textual alinhada ao web (`.app-header__logo`): acompanha o nível de contraste.
class SeniorEaseBrand extends StatelessWidget {
  const SeniorEaseBrand({
    super.key,
    this.fontSize,
    this.onTap,
  });

  /// No header web: `font-size * 1.25` (= [AppDesignTokens.fontSizeTitle] com escala 1).
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
