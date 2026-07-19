import 'package:flutter/material.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';

/// Standard confirmation dialog — title, description, "Cancelar" +
/// a primary or destructive confirm action.
class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmLabel,
    this.cancelLabel = 'Cancelar',
    this.destructive = false,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final String cancelLabel;
  final bool destructive;

  /// Shows the confirmation dialog and resolves to whether the user
  /// confirmed. When [skipInSimpleMode] is true and the app is in Simple
  /// mode, the dialog is never shown and this resolves to `true` right
  /// away — Simple mode favors fewer steps, so only actions explicitly
  /// marked as always-confirm (e.g. deleting the account) should still
  /// interrupt that flow.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String description,
    required String confirmLabel,
    String cancelLabel = 'Cancelar',
    bool destructive = false,
    bool skipInSimpleMode = true,
  }) async {
    if (skipInSimpleMode && sl<AppModeController>().isSimpleMode) {
      return true;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        description: description,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        destructive: destructive,
      ),
    );
    return confirmed ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppDesignTokens.colorWhite,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacingLg,
        vertical: AppDesignTokens.spacingXl,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppDesignTokens.borderRadiusDefault * 2,
        ),
      ),
      child: SizedBox(
        // Dialog's own intrinsic-width behavior left the confirm button too
        // narrow to fit its label — claim the space insetPadding leaves
        // available instead of guessing at it.
        width: MediaQuery.sizeOf(context).width - AppDesignTokens.spacingLg * 2,
        child: Padding(
          padding: EdgeInsets.all(AppDesignTokens.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeH4,
                  fontWeight: AppDesignTokens.fontWeightBold,
                  color: AppDesignTokens.colorContentDefault,
                ),
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
              SizedBox(height: AppDesignTokens.spacingLg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: AppButton(
                      label: cancelLabel,
                      variant: ButtonVariant.lightIcon,
                      backgroundColor: AppDesignTokens.colorPrimarySurface,
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  SizedBox(width: AppDesignTokens.spacingMd),
                  Flexible(
                    child: AppButton(
                      label: confirmLabel,
                      variant: ButtonVariant.primary,
                      backgroundColor: destructive
                          ? AppDesignTokens.colorErrorOnSurface
                          : null,
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
