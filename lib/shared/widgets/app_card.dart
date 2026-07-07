import 'package:flutter/material.dart';
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: selected
              ? AppDesignTokens.colorPrimarySurface
              : AppDesignTokens.colorWhite,
          borderRadius: BorderRadius.circular(
            AppDesignTokens.borderRadiusDefault,
          ),
          border: Border.all(color: AppDesignTokens.colorGray200),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
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
                      const SizedBox(height: AppDesignTokens.spacingXs),
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
              if (selected) const SizedBox(width: AppDesignTokens.spacingSm),
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
            padding: const EdgeInsets.only(
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
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDesignTokens.spacingMd),
        decoration: BoxDecoration(
          color: item.selected
              ? AppDesignTokens.colorPrimarySurface
              : AppDesignTokens.colorWhite,
          borderRadius: BorderRadius.circular(
            AppDesignTokens.borderRadiusDefault,
          ),
          border: Border.all(color: AppDesignTokens.colorGray200),
        ),
        padding: const EdgeInsets.symmetric(
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
