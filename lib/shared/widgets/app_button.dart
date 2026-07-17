import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

enum ButtonVariant {
  primary,
  primaryIcon,
  primaryLeading,
  lightIcon,
  outlined,
  negative,
  negativeLeading,
  secondary,
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.loading = false,
    this.enabled = true,
    this.variant = ButtonVariant.primary,
    this.backgroundColor,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool enabled;
  final ButtonVariant variant;
  final Color? backgroundColor;
  final Widget? icon;

  static const double _buttonHeight = 48;

  bool get _isIconOnly =>
      variant == ButtonVariant.primaryIcon ||
      variant == ButtonVariant.lightIcon;

  @override
  Widget build(BuildContext context) {
    final isEnabled = enabled && !loading;
    final reinforced = sl<AppModeController>().reinforcedVisualFeedback;

    final child = loading
        ? SizedBox(
            width: AppDesignTokens.spacingLg,
            height: AppDesignTokens.spacingLg,
            child: const CircularProgressIndicator(strokeWidth: 2),
          )
        : _buildContent();

    final style = _buildStyle(context, isEnabled, reinforced);

    return _buildButton(child, style, isEnabled, reinforced);
  }

  Widget _buildContent() {
    final text = Text(
      label,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
      style: const TextStyle(fontSize: 16),
    );

    if (_isIconOnly) {
      return Center(child: icon ?? text);
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          // Flexible only makes sense here, next to a fixed-size icon in a
          // Row — Center (below) isn't a Flex, so a bare Flexible under it
          // throws "Incorrect use of ParentDataWidget".
          if (label.isNotEmpty) ...[
            const SizedBox(width: 8),
            Flexible(child: text),
          ],
        ],
      );
    }

    return Center(child: text);
  }

  ButtonStyle _buildStyle(
    BuildContext context,
    bool isEnabled,
    bool reinforced,
  ) {
    const buttonPadding = EdgeInsets.symmetric(horizontal: 16);
    const baseShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

    final style = _styleForVariant(buttonPadding, baseShape);
    if (!reinforced) return style;

    // "Feedback visual reforçado": a clearly visible ring on focus/press,
    // on top of whatever the variant's own style already does.
    return style.copyWith(
      side: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.focused) ||
            states.contains(WidgetState.pressed)) {
          return const BorderSide(
            color: AppDesignTokens.colorFeedbackInfo,
            width: AppDesignTokens.borderWidthMedium,
          );
        }
        return null;
      }),
    );
  }

  ButtonStyle _styleForVariant(
    EdgeInsets buttonPadding,
    RoundedRectangleBorder baseShape,
  ) {
    switch (variant) {
      case ButtonVariant.primaryIcon:
      case ButtonVariant.primaryLeading:
      case ButtonVariant.primary:
        return FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(_buttonHeight),
          padding: buttonPadding,
          backgroundColor:
              backgroundColor ?? AppDesignTokens.buttonBrandBgDefault,
          foregroundColor: AppDesignTokens.buttonBrandContentDefault,
          shape: baseShape,
        );
      case ButtonVariant.lightIcon:
        return FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(_buttonHeight),
          padding: buttonPadding,
          backgroundColor: backgroundColor ?? AppDesignTokens.colorSoft,
          foregroundColor: AppDesignTokens.colorPrimary,
          shape: baseShape,
        );
      case ButtonVariant.outlined:
        return OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(_buttonHeight),
          padding: buttonPadding,
          backgroundColor: AppDesignTokens.buttonOutlinedBgDefault,
          foregroundColor: AppDesignTokens.buttonOutlinedContentDefault,
          side: BorderSide(color: AppDesignTokens.buttonOutlinedBorderDefault),
          shape: baseShape,
        );
      case ButtonVariant.negativeLeading:
      case ButtonVariant.negative:
        return FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(_buttonHeight),
          padding: buttonPadding,
          backgroundColor:
              backgroundColor ?? AppDesignTokens.buttonNegativeBgDefault,
          foregroundColor: backgroundColor != null
              ? AppDesignTokens.colorErrorOnSurface
              : AppDesignTokens.buttonNegativeContentDefault,
          shape: baseShape,
        );
      case ButtonVariant.secondary:
        return FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(_buttonHeight),
          padding: buttonPadding,
          backgroundColor:
              backgroundColor ?? AppDesignTokens.buttonSecondaryBgDefault,
          foregroundColor: AppDesignTokens.buttonSecondaryContentDefault,
          shape: baseShape,
        );
    }
  }

  Widget _buildButton(
    Widget child,
    ButtonStyle style,
    bool isEnabled,
    bool reinforced,
  ) {
    final effectiveOnPressed = isEnabled
        ? _withHaptics(onPressed, reinforced)
        : null;

    if (variant == ButtonVariant.outlined) {
      return OutlinedButton(
        onPressed: effectiveOnPressed,
        style: style,
        child: child,
      );
    }

    return FilledButton(
      onPressed: effectiveOnPressed,
      style: style,
      child: child,
    );
  }

  VoidCallback? _withHaptics(VoidCallback? callback, bool reinforced) {
    if (callback == null || !reinforced) return callback;
    return () {
      HapticFeedback.mediumImpact();
      callback();
    };
  }
}
