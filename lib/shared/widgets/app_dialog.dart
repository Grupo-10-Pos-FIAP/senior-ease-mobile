import 'package:flutter/material.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    super.key,
    required this.title,
    required this.description,
    required this.confirmLabel,
    this.cancelLabel = '',
    this.destructive = false,
    this.warning = false,
    this.isSuccess = false,
    this.confirmFirst = false,
  });

  final String title;
  final String description;
  final String confirmLabel;
  final String cancelLabel;
  final bool destructive;
  final bool warning;
  final bool isSuccess;
  final bool confirmFirst;

  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String description,
    required String confirmLabel,
    required String cancelLabel,
    bool destructive = false,
    bool onlyInBasicMode = false,
    bool confirmFirst = false,
  }) async {
    if (onlyInBasicMode && !sl<AppModeController>().isSimpleMode) {
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
        confirmFirst: confirmFirst,
      ),
    );
    return confirmed ?? false;
  }

  static Future<bool> warn(
    BuildContext context, {
    required String title,
    required String description,
    required String confirmLabel,
    required String cancelLabel,
    bool onlyInBasicMode = false,
  }) async {
    if (onlyInBasicMode && !sl<AppModeController>().isSimpleMode) {
      return true;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        description: description,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        warning: true,
      ),
    );
    return confirmed ?? false;
  }

  static Future<void> success(
    BuildContext context, {
    required String title,
    required String description,
    String closeLabel = 'Entendi',
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => AppDialog(
        title: title,
        description: description,
        confirmLabel: closeLabel,
        isSuccess: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: isSuccess
          ? AppDesignTokens.colorSuccessSurface
          : AppDesignTokens.colorBgLight,
      insetPadding: EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacingLg,
        vertical: AppDesignTokens.spacingXl,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          AppDesignTokens.borderRadiusDefault * 2,
        ),
        side: isSuccess
            ? BorderSide(color: AppDesignTokens.colorSuccessBorder, width: 3)
            : BorderSide.none,
      ),
      child: SizedBox(
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
                  color: isSuccess
                      ? AppDesignTokens.colorSuccessOnSurface
                      : AppDesignTokens.colorContentDefault,
                ),
              ),
              SizedBox(height: AppDesignTokens.spacingMd),
              Text(
                description,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  height: AppDesignTokens.lineHeightBody,
                  color: isSuccess
                      ? AppDesignTokens.colorSuccessOnSurface
                      : AppDesignTokens.colorContentSecondary,
                ),
              ),
              SizedBox(height: AppDesignTokens.spacingLg),
              if (isSuccess)
                AppButton(
                  label: confirmLabel,
                  variant: ButtonVariant.primary,
                  onPressed: () => Navigator.of(context).pop(),
                )
              else ..._stackedActions(context),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _stackedActions(BuildContext context) {
    final confirmButton = AppButton(
      label: confirmLabel,
      variant: warning ? ButtonVariant.warning : ButtonVariant.primary,
      backgroundColor: !warning && destructive
          ? AppDesignTokens.colorErrorOnSurface
          : null,
      onPressed: () => Navigator.of(context).pop(true),
    );
    final cancelButton = AppButton(
      label: cancelLabel,
      variant: ButtonVariant.outlined,
      backgroundColor: AppDesignTokens.colorPrimarySurface,
      onPressed: () => Navigator.of(context).pop(false),
    );

    // Warning and confirmFirst: confirm on top. Otherwise cancel first.
    final confirmOnTop = warning || confirmFirst;
    return [
      if (confirmOnTop) confirmButton else cancelButton,
      SizedBox(height: AppDesignTokens.spacingMd),
      if (confirmOnTop) cancelButton else confirmButton,
    ];
  }
}
