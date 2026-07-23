import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

/// Standard inline warning banner — icon, bold title and a message below.
class AppWarningBanner extends StatelessWidget {
  const AppWarningBanner({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppDesignTokens.colorFeedbackWarning.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(
          AppDesignTokens.borderRadiusDefault,
        ),
        border: Border.all(color: AppDesignTokens.colorFeedbackWarning),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppDesignTokens.colorFeedbackWarning,
          ),
          SizedBox(width: AppDesignTokens.spacingSm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeBody,
                    fontWeight: AppDesignTokens.fontWeightSemibold,
                    color: AppDesignTokens.colorContentDefault,
                  ),
                ),
                SizedBox(height: AppDesignTokens.spacingXs),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeBody,
                    color: AppDesignTokens.colorContentSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
