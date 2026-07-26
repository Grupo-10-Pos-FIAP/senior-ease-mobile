import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class GuidedTutorialHeader extends StatelessWidget {
  const GuidedTutorialHeader({super.key, required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacingLg,
        vertical: AppDesignTokens.spacingMd,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppDesignTokens.colorBorderDefault),
        ),
      ),
      child: Text(
        hint,
        style: TextStyle(
          fontSize: AppDesignTokens.fontSizeBody,
          height: AppDesignTokens.lineHeightBody,
          color: AppDesignTokens.colorContentSecondary,
        ),
      ),
    );
  }
}
