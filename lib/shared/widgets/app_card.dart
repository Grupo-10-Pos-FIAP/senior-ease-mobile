import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class AppCardItem {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  AppCardItem({
    required this.label,
    required this.selected,
    required this.onTap,
  });
}

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.options, this.title})
    : subtitle = null,
      onTap = null,
      selected = false,
      _isSimple = false;

  /// Construtor para card simples (estilo de seleção antiga)
  const AppCard.simple({
    super.key,
    required this.title,
    this.subtitle,
    this.selected = false,
    this.onTap,
  }) : options = const [],
       _isSimple = true;

  final List<AppCardItem> options;
  final String? title;
  final String? subtitle;
  final bool selected;
  final VoidCallback? onTap;
  final bool _isSimple;

  @override
  Widget build(BuildContext context) {
    if (_isSimple) {
      return _buildSimpleCard();
    }
    return _buildOptionsCard();
  }

  Widget _buildSimpleCard() {
    return _TappableCard(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDesignTokens.borderRadiusDefault),
      child: Container(
        margin: EdgeInsets.only(bottom: AppDesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: selected
              ? AppDesignTokens.colorPrimarySurface
              : AppDesignTokens.colorBgLight,
          borderRadius: BorderRadius.circular(
            AppDesignTokens.borderRadiusDefault,
          ),
          border: Border.all(color: AppDesignTokens.colorGray200),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingMd,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? '',
                      style: TextStyle(
                        fontSize: AppDesignTokens.fontSizeBody,
                        fontWeight: AppDesignTokens.fontWeightSemibold,
                        color: AppDesignTokens.colorContentDefault,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: AppDesignTokens.spacingXs),
                      Text(
                        subtitle!,
                        style: TextStyle(
                          fontSize: AppDesignTokens.fontSizeCaption,
                          fontWeight: AppDesignTokens.fontWeightMedium,
                          color: AppDesignTokens.colorContentSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (selected) SizedBox(width: AppDesignTokens.spacingSm),
              if (selected)
                Icon(
                  Icons.check_circle,
                  color: AppDesignTokens.colorPrimary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: EdgeInsets.only(
              left: AppDesignTokens.spacingMd,
              right: AppDesignTokens.spacingMd,
              bottom: AppDesignTokens.spacingSm,
            ),
            child: Text(
              title!,
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeBody,
                fontWeight: AppDesignTokens.fontWeightSemibold,
                color: AppDesignTokens.colorContentDefault,
              ),
            ),
          ),
        ],
        ...options.map((item) => _AppCardItemWidget(item: item)),
      ],
    );
  }
}

class _AppCardItemWidget extends StatelessWidget {
  const _AppCardItemWidget({required this.item});

  final AppCardItem item;

  @override
  Widget build(BuildContext context) {
    return _TappableCard(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(AppDesignTokens.borderRadiusDefault),
      child: Container(
        margin: EdgeInsets.only(bottom: AppDesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: item.selected
              ? AppDesignTokens.colorPrimarySurface
              : AppDesignTokens.colorBgLight,
          borderRadius: BorderRadius.circular(
            AppDesignTokens.borderRadiusDefault,
          ),
          border: Border.all(color: AppDesignTokens.colorGray200),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacingMd,
          vertical: AppDesignTokens.spacingMd,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  fontWeight: AppDesignTokens.fontWeightMedium,
                  color: AppDesignTokens.colorContentDefault,
                ),
              ),
            ),
            if (item.selected)
              Icon(
                Icons.check_circle,
                color: AppDesignTokens.colorPrimary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

/// Wraps card content with a tap handler — every card gets a visible
/// press highlight via [InkWell] (using the contrast-adjusted gray scale,
/// so it stays visible regardless of contrast level, unlike a fixed brand
/// color would). With "Feedback visual reforçado" on, taps additionally
/// get haptic feedback, for touch confirmation that's unmistakable for
/// low-vision users.
class _TappableCard extends StatelessWidget {
  const _TappableCard({
    required this.onTap,
    required this.borderRadius,
    required this.child,
  });

  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final reinforced = sl<AppModeController>().reinforcedVisualFeedback;

    final effectiveOnTap = onTap == null
        ? null
        : reinforced
        ? () {
            HapticFeedback.mediumImpact();
            onTap!();
          }
        : onTap;

    return Material(
      color: Colors.transparent,
      borderRadius: borderRadius,
      child: InkWell(
        onTap: effectiveOnTap,
        borderRadius: borderRadius,
        splashColor: AppDesignTokens.colorGray500.withValues(alpha: 0.4),
        highlightColor: AppDesignTokens.colorGray500.withValues(alpha: 0.3),
        child: child,
      ),
    );
  }
}
