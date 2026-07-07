import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_tabs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTab = 0;

  final List<String> _tabs = const ['Atividades', 'Concluídas', 'Expiradas'];

  final List<ActivityItem> _activities = const [
    ActivityItem(
      title: 'Oficina “Primeiros Passos no Digital”',
      dateRange: '05/06/2026 - 14/06/2026',
      status: ActivityStatus.active,
    ),
    ActivityItem(
      title: 'Curso “Como usar E-mail”',
      dateRange: '01/07/2026 - 16/07/2026',
      status: ActivityStatus.active,
    ),
    ActivityItem(
      title: 'Atividade “Videochamadas sem Medo”',
      dateRange: '14/08/2026 - 19/08/2026',
      status: ActivityStatus.active,
    ),
    ActivityItem(
      title: 'Oficina “Segurança online”',
      dateRange: '20/05/2026 - 25/05/2026',
      status: ActivityStatus.completed,
    ),
    ActivityItem(
      title: 'Curso “Configurar celular”',
      dateRange: '10/04/2026 - 15/04/2026',
      status: ActivityStatus.expired,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedStatus = ActivityStatus.values[_selectedTab];
    final items = _activities
        .where((activity) => activity.status == selectedStatus)
        .toList();

    return Scaffold(
      backgroundColor: AppDesignTokens.colorGray100,
      appBar: SeniorEaseAppBar(
        onProfileTap: () => Navigator.of(context).pushNamed('/profile'),
        onLogoutTap: () {},
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            AppTabs(
              tabs: _tabs,
              selectedIndex: _selectedTab,
              onTabSelected: (index) => setState(() => _selectedTab = index),
            ),
            const SizedBox(height: AppDesignTokens.spacingLg),
            ...items.map(_buildActivityCard),
            if (items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: AppDesignTokens.spacingLg),
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
      ),
    );
  }

  Widget _buildActivityCard(ActivityItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDesignTokens.spacingLg),
      padding: const EdgeInsets.all(AppDesignTokens.spacingLg),
      decoration: BoxDecoration(
        color: AppDesignTokens.colorWhite,
        borderRadius: BorderRadius.circular(
          AppDesignTokens.borderRadiusDefault,
        ),
        border: Border.all(color: AppDesignTokens.colorGray200),
        boxShadow: [
          BoxShadow(
            color: AppDesignTokens.colorGray300.withValues(alpha: 0.30),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title,
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeTitle,
              fontWeight: AppDesignTokens.fontWeightBold,
              color: AppDesignTokens.colorContentDefault,
            ),
          ),
          const SizedBox(height: AppDesignTokens.spacingMd),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 18,
                color: AppDesignTokens.colorContentSecondary,
              ),
              const SizedBox(width: AppDesignTokens.spacingSm),
              Text(
                item.dateRange,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  color: AppDesignTokens.colorContentSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDesignTokens.spacingLg),
          if (item.status != ActivityStatus.active)
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: AppDesignTokens.spacingSm,
                horizontal: AppDesignTokens.spacingMd,
              ),
              decoration: BoxDecoration(
                color: item.status == ActivityStatus.completed
                    ? AppDesignTokens.colorBadgeScheduledBackground
                    : AppDesignTokens.colorErrorSurface,
                borderRadius: BorderRadius.circular(
                  AppDesignTokens.borderRadiusDefault,
                ),
              ),
              child: Text(
                item.status == ActivityStatus.completed
                    ? 'Atividade concluída'
                    : 'Atividade expirada',
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  fontWeight: AppDesignTokens.fontWeightSemibold,
                  color: item.status == ActivityStatus.completed
                      ? AppDesignTokens.colorBadgeScheduledForeground
                      : AppDesignTokens.colorErrorOnSurface,
                ),
              ),
            ),
          if (item.status != ActivityStatus.active)
            const SizedBox(height: AppDesignTokens.spacingLg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: 'Concluir atividade',
                onPressed: item.status == ActivityStatus.active ? () {} : null,
                variant: ButtonVariant.primary,
                icon: const Icon(Icons.check),
              ),
              const SizedBox(height: AppDesignTokens.spacingMd),
              AppButton(
                label: 'Como fazer essa atividade?',
                onPressed: () {},
                variant: ButtonVariant.outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

enum ActivityStatus { active, completed, expired }

class ActivityItem {
  final String title;
  final String dateRange;
  final ActivityStatus status;

  const ActivityItem({
    required this.title,
    required this.dateRange,
    required this.status,
  });
}
