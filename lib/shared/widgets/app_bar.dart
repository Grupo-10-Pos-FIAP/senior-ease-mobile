import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class SeniorEaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SeniorEaseAppBar({super.key, this.onProfileTap, this.onLogoutTap});

  final VoidCallback? onProfileTap;
  final VoidCallback? onLogoutTap;

  @override
  Size get preferredSize => const Size.fromHeight(84);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppDesignTokens.colorWhite,
      elevation: 0,
      toolbarHeight: preferredSize.height,
      centerTitle: false,
      shape: Border(
        bottom: BorderSide(color: AppDesignTokens.colorGray200, width: 1),
      ),
      title: SvgPicture.asset(
        'lib/assets/logo.svg',
        height: 32,
        fit: BoxFit.contain,
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
            'Meu perfil',
            style: TextStyle(
              color: AppDesignTokens.colorContentDefault,
              fontSize: AppDesignTokens.fontSizeBody,
              fontWeight: AppDesignTokens.fontWeightMedium,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(width: AppDesignTokens.spacingSm),
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
              horizontal: AppDesignTokens.spacingMd,
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
        SizedBox(width: AppDesignTokens.spacingMd),
      ],
    );
  }
}
