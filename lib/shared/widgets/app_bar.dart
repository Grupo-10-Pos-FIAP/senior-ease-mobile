import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/senior_ease_brand.dart';

class SeniorEaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SeniorEaseAppBar({
    super.key,
    this.onLogoTap,
    this.onProfileTap,
    this.onLogoutTap,
  });

  final VoidCallback? onLogoTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppDesignTokens.colorBgLight,
      elevation: 0,
      toolbarHeight: preferredSize.height,
      centerTitle: false,
      shape: Border(
        bottom: BorderSide(color: AppDesignTokens.colorGray200, width: 1),
      ),
      titleSpacing: 8,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: SeniorEaseBrand(
          fontSize: AppDesignTokens.fontSizeH4,
          onTap: onLogoTap,
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: onProfileTap,
          icon: Icon(
            Icons.account_circle_outlined,
            color: AppDesignTokens.colorPrimary,
            size: 20,
          ),
          label: Text(
            'Perfil',
            style: TextStyle(
              color: AppDesignTokens.colorContentDefault,
              fontSize: AppDesignTokens.fontSizeBody,
              fontWeight: AppDesignTokens.fontWeightMedium,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(width: AppDesignTokens.spacingXs),
        TextButton.icon(
          onPressed: onLogoutTap,
          icon: Icon(
            Icons.logout,
            color: AppDesignTokens.colorPrimary,
            size: 18,
          ),
          label: Text(
            'Sair',
            style: TextStyle(
              color: AppDesignTokens.colorPrimary,
              fontSize: AppDesignTokens.fontSizeBody,
              fontWeight: AppDesignTokens.fontWeightSemibold,
            ),
          ),
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: AppDesignTokens.spacingSm,
              vertical: AppDesignTokens.spacingSm,
            ),
            backgroundColor: AppDesignTokens.colorGray100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                AppDesignTokens.borderRadiusDefault,
              ),
            ),
          ),
        ),
        SizedBox(width: AppDesignTokens.spacingSm),
      ],
    );
  }
}
