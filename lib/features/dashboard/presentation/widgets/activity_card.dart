import 'package:flutter/material.dart';
import 'package:senior_ease/features/dashboard/domain/entities/activity.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
    this.onComplete,
    this.onHowTo,
  });

  final Activity activity;
  final VoidCallback? onComplete;
  final VoidCallback? onHowTo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDesignTokens.spacingLg),
      padding: EdgeInsets.all(AppDesignTokens.spacingLg),
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
            activity.title,
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeTitle,
              fontWeight: AppDesignTokens.fontWeightBold,
              color: AppDesignTokens.colorContentDefault,
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingMd),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 18,
                color: AppDesignTokens.colorContentSecondary,
              ),
              SizedBox(width: AppDesignTokens.spacingSm),
              Text(
                activity.dateRange,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  color: AppDesignTokens.colorContentSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDesignTokens.spacingLg),
          if (activity.status != ActivityStatus.active)
            Container(
              padding: EdgeInsets.symmetric(
                vertical: AppDesignTokens.spacingSm,
                horizontal: AppDesignTokens.spacingMd,
              ),
              decoration: BoxDecoration(
                color: activity.status == ActivityStatus.completed
                    ? AppDesignTokens.colorBadgeScheduledBackground
                    : AppDesignTokens.colorErrorSurface,
                borderRadius: BorderRadius.circular(
                  AppDesignTokens.borderRadiusDefault,
                ),
              ),
              child: Text(
                activity.status == ActivityStatus.completed
                    ? 'Atividade concluída'
                    : 'Atividade expirada',
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  fontWeight: AppDesignTokens.fontWeightSemibold,
                  color: activity.status == ActivityStatus.completed
                      ? AppDesignTokens.colorBadgeScheduledForeground
                      : AppDesignTokens.colorErrorOnSurface,
                ),
              ),
            ),
          if (activity.status != ActivityStatus.active)
            SizedBox(height: AppDesignTokens.spacingLg),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppButton(
                label: 'Concluir atividade',
                onPressed: activity.status == ActivityStatus.active
                    ? (onComplete ?? () {})
                    : null,
                variant: ButtonVariant.primary,
                icon: const Icon(Icons.check),
              ),
              SizedBox(height: AppDesignTokens.spacingMd),
              AppButton(
                label: 'Como fazer essa atividade?',
                onPressed: onHowTo ?? () {},
                variant: ButtonVariant.outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
