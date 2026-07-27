import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/auth/logout_action.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';
import 'package:senior_ease/features/profile/presentation/screens/profile_info_screen.dart';
import 'package:senior_ease/features/settings/presentation/controllers/settings_controller.dart';
import 'package:senior_ease/features/settings/presentation/screens/settings_screen.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_tabs.dart';

class ProfileShellScreen extends StatefulWidget {
  const ProfileShellScreen({super.key});

  @override
  State<ProfileShellScreen> createState() => _ProfileShellScreenState();
}

class _ProfileShellScreenState extends State<ProfileShellScreen> {
  int _selectedTab = 0;

  final List<String> _tabs = const ['Personalização', 'Informações da conta'];

  @override
  void initState() {
    super.initState();
    sl<SettingsController>().load();
    sl<ProfileInfoController>().load();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsController>.value(
          value: sl<SettingsController>(),
        ),
        ChangeNotifierProvider<ProfileInfoController>.value(
          value: sl<ProfileInfoController>(),
        ),
      ],
      // AppDesignTokens colors are plain static getters, not an
      // InheritedWidget — the IndexedStack below keeps both tabs alive, so
      // without this listener the inactive tab never re-reads them and
      // stays painted with whatever contrast/font/spacing was active the
      // first time it was built.
      child: ListenableBuilder(
        listenable: sl<AppModeController>(),
        builder: (context, _) => Scaffold(
          backgroundColor: AppDesignTokens.colorGray100,
          appBar: SeniorEaseAppBar(
            onLogoTap: () => Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(RouteNames.home, (route) => false),
            onProfileTap: () =>
                Navigator.of(context).pushNamed(RouteNames.profile),
            onLogoutTap: () => confirmAndSignOut(context),
          ),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppDesignTokens.spacingMd,
                    AppDesignTokens.spacingLg,
                    AppDesignTokens.spacingMd,
                    AppDesignTokens.spacingLg,
                  ),
                  child: AppTabs(
                    tabs: _tabs,
                    selectedIndex: _selectedTab,
                    onTabSelected: (index) =>
                        setState(() => _selectedTab = index),
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedTab,
                    // Not const: a fresh instance each rebuild is what lets
                    // Flutter's identical() check above actually rebuild
                    // the inactive tab instead of skipping it.
                    children: [SettingsScreen(), ProfileInfoScreen()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
