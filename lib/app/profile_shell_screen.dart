import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/features/profile/presentation/controllers/profile_info_controller.dart';
import 'package:senior_ease/features/profile/presentation/screens/profile_info_screen.dart';
import 'package:senior_ease/features/settings/presentation/controllers/settings_controller.dart';
import 'package:senior_ease/features/settings/presentation/screens/settings_screen.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_tabs.dart';

/// Pure navigation/composition — hosts the "Personalização"/"Informações"
/// tabs and renders the profile and settings feature screens. No
/// business logic lives here.
class ProfileShellScreen extends StatefulWidget {
  const ProfileShellScreen({super.key});

  @override
  State<ProfileShellScreen> createState() => _ProfileShellScreenState();
}

class _ProfileShellScreenState extends State<ProfileShellScreen> {
  int _selectedTab = 0;

  final List<String> _tabs = const ['Personalização', 'Informações'];

  @override
  void initState() {
    super.initState();
    // sl<SettingsController>()/sl<ProfileInfoController>() are GetIt
    // singletons shared for the app's lifetime, not owned by this screen —
    // load() is kicked off once per visit here (not via Provider's `create`,
    // which would dispose the shared instance when this screen is popped,
    // breaking every later visit).
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
      child: Scaffold(
        backgroundColor: AppDesignTokens.colorGray100,
        appBar: SeniorEaseAppBar(onProfileTap: () {}, onLogoutTap: () {}),
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
                  children: const [SettingsScreen(), ProfileInfoScreen()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
