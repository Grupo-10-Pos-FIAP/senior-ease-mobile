import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class AppTabs extends StatelessWidget {
  const AppTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: List.generate(tabs.length, (index) {
            final isSelected = index == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDesignTokens.spacingMd,
                  ),
                  child: Text(
                    tabs[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeBody,
                      fontWeight: isSelected
                          ? AppDesignTokens.fontWeightSemibold
                          : AppDesignTokens.fontWeightRegular,
                      color: isSelected
                          ? AppDesignTokens.colorContentDefault
                          : AppDesignTokens.colorContentSecondary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        // A single continuous line, bottom-aligned so every segment shares
        // the same baseline — the selected tab's segment is thicker and
        // colored, the rest is the thin divider — so the indicator is
        // always exactly on the divider instead of two separately
        // positioned bars.
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(tabs.length, (index) {
            final isSelected = index == selectedIndex;
            return Expanded(
              child: Container(
                height: isSelected ? 3 : 1,
                color: isSelected
                    ? AppDesignTokens.colorPrimary
                    : AppDesignTokens.colorGray200,
              ),
            );
          }),
        ),
      ],
    );
  }
}
