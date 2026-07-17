import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: AppDesignTokens.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeSmall,
              color: AppDesignTokens.colorContentSecondary,
              fontWeight: AppDesignTokens.fontWeightBold,
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingSm),
          Text(
            value,
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeBody,
              color: AppDesignTokens.colorContentDefault,
              fontWeight: AppDesignTokens.fontWeightSemibold,
            ),
          ),
        ],
      ),
    );
  }
}
