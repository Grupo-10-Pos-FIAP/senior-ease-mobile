import 'package:flutter/material.dart';
import 'package:senior_ease/features/profile/domain/entities/user_profile.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';

/// Banner de perfil incompleto alinhado ao web `IncompleteProfileCallout`.
class IncompleteProfileCallout extends StatelessWidget {
  const IncompleteProfileCallout({
    super.key,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final hasAction = actionLabel != null && onAction != null;

    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(
          AppDesignTokens.spacingMd + AppDesignTokens.spacingXs,
        ),
        decoration: BoxDecoration(
          color: AppDesignTokens.colorWarningSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppDesignTokens.colorWarningBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: AppDesignTokens.colorFeedbackWarning,
                  size: 24,
                ),
                SizedBox(width: AppDesignTokens.spacingSm),
                Expanded(
                  child: Text(
                    incompleteProfileName,
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeBody,
                      fontWeight: AppDesignTokens.fontWeightBold,
                      height: AppDesignTokens.lineHeightBody,
                      color: AppDesignTokens.colorContentDefault,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppDesignTokens.spacingSm),
            Text(
              description,
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeBody,
                height: AppDesignTokens.lineHeightBody,
                color: AppDesignTokens.colorContentSecondary,
              ),
            ),
            if (hasAction) ...[
              SizedBox(height: AppDesignTokens.spacingSm),
              AppButton(
                label: actionLabel!,
                onPressed: onAction,
                variant: ButtonVariant.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
