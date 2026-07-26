import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/logout_action.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:senior_ease/features/dashboard/presentation/widgets/activity_card.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_dialog.dart';
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
          onLogoutTap: () => confirmAndSignOut(context),
        ),
        body: SafeArea(
          bottom: false,
          child: Consumer<DashboardController>(
            builder: (context, controller, _) {
              final items = controller.filteredActivities;
              return RefreshIndicator(
                onRefresh: controller.refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDesignTokens.spacingMd,
                    vertical: AppDesignTokens.spacingLg,
                  ),
                  children: [
                    AppTabs(
                      tabs: controller.tabLabels,
                      selectedIndex: controller.selectedTab,
                      onTabSelected: controller.selectTab,
                    ),
                    SizedBox(height: AppDesignTokens.spacingLg),
                    if (!controller.isLoading)
                      ...items.map(
                        (activity) => ActivityCard(
                          activity: activity,
                          onComplete: () async {
                            final confirmed = await AppDialog.confirm(
                              context,
                              title: activity.started
                                  ? 'Continuar esta atividade?'
                                  : 'Iniciar esta atividade?',
                              description: activity.started
                                  ? 'Você vai continuar "${activity.title}" a partir do primeiro passo pendente. Deseja continuar agora?'
                                  : 'Você vai iniciar "${activity.title}" a partir do primeiro passo. Deseja começar agora?',
                              confirmLabel: activity.started
                                  ? 'Sim, continuar'
                                  : 'Sim, iniciar',
                              cancelLabel: 'Não, ainda não',
                              onlyInBasicMode: true,
                            );
                            if (!confirmed) return;
                            if (!context.mounted) return;
                            // Opens the real activity flow — never the
                            // pedagogical guide. Resume after the last
                            // completed step, or from the start.
                            await Navigator.of(context).pushNamed(
                              RouteNames.stage,
                              arguments: (
                                activityId: activity.id,
                                initialStepIndex: activity.completedStepsCount,
                              ),
                            );
                            if (context.mounted) controller.refresh();
                          },
                          onHowTo: () => Navigator.of(
                            context,
                          ).pushNamed(RouteNames.steps, arguments: activity.id),
                        ),
                      ),
                    if (!controller.isLoading && items.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
