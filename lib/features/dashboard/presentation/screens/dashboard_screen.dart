import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:senior_ease/features/dashboard/presentation/widgets/activity_card.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_tabs.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DashboardController>(
      create: (_) => sl<DashboardController>()..load(),
      child: Scaffold(
        backgroundColor: AppDesignTokens.colorGray100,
        appBar: SeniorEaseAppBar(
          onProfileTap: () =>
              Navigator.of(context).pushNamed(RouteNames.profile),
          onLogoutTap: () {},
        ),
        body: SafeArea(
          bottom: false,
          child: Consumer<DashboardController>(
            builder: (context, controller, _) {
              final items = controller.filteredActivities;
              return ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDesignTokens.spacingMd,
                  vertical: AppDesignTokens.spacingLg,
                ),
                children: [
                  AppTabs(
                    tabs: controller.tabLabels,
                    selectedIndex: controller.selectedTab,
                    onTabSelected: controller.selectTab,
                  ),
                  const SizedBox(height: AppDesignTokens.spacingLg),
                  if (!controller.isLoading)
                    ...items.map(
                      (activity) => ActivityCard(
                        activity: activity,
                        onHowTo: () =>
                            Navigator.of(context).pushNamed(RouteNames.steps),
                      ),
                    ),
                  if (!controller.isLoading && items.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: AppDesignTokens.spacingLg,
                      ),
                      child: Text(
                        'Nenhuma atividade disponível.',
                        style: TextStyle(
                          color: AppDesignTokens.colorContentSecondary,
                          fontSize: AppDesignTokens.fontSizeBody,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
