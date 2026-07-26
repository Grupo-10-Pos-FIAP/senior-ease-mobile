import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/reinforced_focus_ring.dart';

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
      overline = null,
      onTap = null,
      selected = false,
      _isSimple = false;

  const AppCard.simple({
    super.key,
    required this.title,
    this.subtitle,
    this.overline,
    this.selected = false,
    this.onTap,
  }) : options = const [],
       _isSimple = true;

  final List<AppCardItem> options;
  final String? title;
  final Object? subtitle;
  final String? overline;
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
      margin: EdgeInsets.only(bottom: AppDesignTokens.spacingMd),
      color: _cardColorFor(selected),
      pressedColor: _cardPressedColorFor(selected),
      border: _cardBorderFor(selected),
      builder: (context, _) {
        final highlighted = selected;
        final contentColor = highlighted
            ? AppDesignTokens.colorPrimary
            : AppDesignTokens.colorContentDefault;
        final secondaryContentColor = highlighted
            ? AppDesignTokens.colorPrimary
            : AppDesignTokens.colorContentSecondary;
        return Padding(
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
                    if (overline != null) ...[
                      Text(
                        overline!,
                        style: TextStyle(
                          fontSize: AppDesignTokens.fontSizeSmall,
                          fontWeight: AppDesignTokens.fontWeightSemibold,
                          color: secondaryContentColor,
                        ),
                      ),
                      SizedBox(height: AppDesignTokens.spacingXs),
                    ],
                    Text(
                      title ?? '',
                      style: TextStyle(
                        fontSize: AppDesignTokens.fontSizeBody,
                        fontWeight: AppDesignTokens.fontWeightSemibold,
                        color: contentColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: AppDesignTokens.spacingXs),
                      if (subtitle is Widget)
                        subtitle as Widget
                      else
                        Text(
                          subtitle as String,
                          style: TextStyle(
                            fontSize: AppDesignTokens.fontSizeCaption,
                            fontWeight: AppDesignTokens.fontWeightMedium,
                            color: secondaryContentColor,
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
        );
      },
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

/// Resting background: selected items get a light lavender tint so the
/// marked option stands out at all times, not just while being touched.
Color _cardColorFor(bool selected) {
  return selected
      ? AppDesignTokens.colorCardSelectedBackground
      : AppDesignTokens.colorBgLight;
}

/// Background shown while the card is being pressed. Selected items stay on
/// their strong resting color; unselected items get a light preview tint.
Color _cardPressedColorFor(bool selected) {
  return selected
      ? AppDesignTokens.colorCardSelectedBackground
      : AppDesignTokens.colorPrimarySurface;
}

/// Border: selected items get the brand primary color to reinforce the
/// selection alongside the lavender background.
Border _cardBorderFor(bool selected) {
  return Border.all(
    color: selected
        ? AppDesignTokens.colorPrimary
        : AppDesignTokens.colorBorderDefault,
        width: selected ? 1.5 : 1.0,
  );
}

class _AppCardItemWidget extends StatelessWidget {
  const _AppCardItemWidget({required this.item});

  final AppCardItem item;

  @override
  Widget build(BuildContext context) {
    return _TappableCard(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(AppDesignTokens.borderRadiusDefault),
      margin: EdgeInsets.only(bottom: AppDesignTokens.spacingMd),
      color: _cardColorFor(item.selected),
      pressedColor: _cardPressedColorFor(item.selected),
      border: _cardBorderFor(item.selected),
      padding: EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacingMd,
        vertical: AppDesignTokens.spacingMd,
      ),
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  fontWeight: item.selected ? AppDesignTokens.fontWeightSemibold : AppDesignTokens.fontWeightMedium,
                  color: item.selected
                      ? AppDesignTokens.colorPrimary
                      : AppDesignTokens.colorContentDefault,
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
        );
      },
    );
  }
}

class _TappableCard extends StatefulWidget {
  const _TappableCard({
    required this.onTap,
    required this.borderRadius,
    required this.color,
    required this.pressedColor,
    required this.border,
    required this.builder,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
  });

  final VoidCallback? onTap;
  final BorderRadius borderRadius;
  final Color color;
  final Color pressedColor;
  final Border border;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Widget Function(BuildContext context, bool pressed) builder;

  @override
  State<_TappableCard> createState() => _TappableCardState();
}

class _TappableCardState extends State<_TappableCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final reinforced = sl<AppModeController>().reinforcedVisualFeedback;

    final effectiveOnTap = widget.onTap == null
        ? null
        : reinforced
        ? () {
            HapticFeedback.mediumImpact();
            widget.onTap!();
          }
        : widget.onTap;

    return ReinforcedFocusRing(
      enabled: reinforced,
      borderRadius: widget.borderRadius,
      builder: (context, focusNode) => Listener(
        onPointerDown: widget.onTap == null
            ? null
            : (_) => _setPressed(true),
        onPointerUp: widget.onTap == null ? null : (_) => _setPressed(false),
        onPointerCancel: widget.onTap == null
            ? null
            : (_) => _setPressed(false),
        child: Material(
          color: Colors.transparent,
          borderRadius: widget.borderRadius,
          child: InkWell(
            onTap: effectiveOnTap,
            borderRadius: widget.borderRadius,
            focusNode: focusNode,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              curve: Curves.easeOut,
              margin: widget.margin,
              padding: widget.padding,
              decoration: BoxDecoration(
                color: _pressed ? widget.pressedColor : widget.color,
                borderRadius: widget.borderRadius,
                border: widget.border,
              ),
              child: widget.builder(context, _pressed),
            ),
          ),
        ),
      ),
    );
  }
}
