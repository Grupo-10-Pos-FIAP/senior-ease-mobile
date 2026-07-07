import 'package:flutter/material.dart';
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

    final child = loading
        ? SizedBox(
            width: AppDesignTokens.spacingLg,
            height: AppDesignTokens.spacingLg,
            child: const CircularProgressIndicator(strokeWidth: 2),
          )
        : _buildContent();

    final style = _buildStyle(context, isEnabled);

    return _buildButton(child, style, isEnabled);
  }

  Widget _buildContent() {
    final labelWidget = Flexible(
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(fontSize: 16),
      ),
    );

    if (_isIconOnly) {
      return Center(child: icon ?? labelWidget);
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          if (label.isNotEmpty) ...[const SizedBox(width: 8), labelWidget],
        ],
      );
    }

    return Center(child: labelWidget);
  }

  ButtonStyle _buildStyle(BuildContext context, bool isEnabled) {
    const buttonPadding = EdgeInsets.symmetric(horizontal: 16);
    const baseShape = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    );

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

  Widget _buildButton(Widget child, ButtonStyle style, bool isEnabled) {
    if (variant == ButtonVariant.outlined) {
      return OutlinedButton(
        onPressed: isEnabled ? onPressed : null,
        style: style,
        child: child,
      );
    }

    return FilledButton(
      onPressed: isEnabled ? onPressed : null,
      style: style,
      child: child,
    );
  }
}
