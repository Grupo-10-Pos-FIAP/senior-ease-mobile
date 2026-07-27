import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.errorText,
    this.enabled = true,
    this.hintText,
    this.helperText,
    this.onChanged,
    this.inputFormatters,
  });

  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? errorText;
  final bool enabled;
  final String? hintText;
  final String? helperText;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      enabled: enabled,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      style: TextStyle(
        fontSize: AppDesignTokens.fontSizeBody,
        color: enabled
            ? AppDesignTokens.colorContentDefault
            : AppDesignTokens.colorContentDisabled,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        helperText: helperText,
        errorText: errorText,
        suffixIcon: enabled
            ? null
            : Icon(
                Icons.lock_outline,
                color: AppDesignTokens.colorContentDisabled,
                size: 20,
              ),
        filled: true,
        fillColor: enabled
            ? AppDesignTokens.colorBgLight
            : AppDesignTokens.colorBgDisabled,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacingMd,
          vertical: AppDesignTokens.spacingMd,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDesignTokens.borderRadiusDefault,
          ),
          borderSide: BorderSide(color: AppDesignTokens.colorBorderDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDesignTokens.borderRadiusDefault,
          ),
          borderSide: BorderSide(color: AppDesignTokens.colorBorderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDesignTokens.borderRadiusDefault,
          ),
          borderSide: BorderSide(
            color: AppDesignTokens.colorBorderFocused,
            width: AppDesignTokens.borderWidthSmall,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDesignTokens.borderRadiusDefault,
          ),
          borderSide: BorderSide(color: AppDesignTokens.colorGray300),
        ),
      ),
    );
  }
}
