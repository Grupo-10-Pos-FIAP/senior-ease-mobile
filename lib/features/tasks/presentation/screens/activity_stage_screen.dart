import 'package:flutter/material.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/complete_step.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_card.dart';

typedef ActivityStageArgs = ({String activityId, TaskStep step});

/// Per-step detail view: renders the step's reading content or quiz
/// question/options (from Firestore, via route arguments), and marks the
/// step complete on Firestore when the user acts on it — no right/wrong
/// checking for quiz steps, picking an option is enough (reflection-style).
class ActivityStageScreen extends StatefulWidget {
  const ActivityStageScreen({super.key});

  @override
  State<ActivityStageScreen> createState() => _ActivityStageScreenState();
}

class _ActivityStageScreenState extends State<ActivityStageScreen> {
  bool _isSubmitting = false;

  Future<void> _complete(String activityId, String stepId) async {
    setState(() => _isSubmitting = true);
    await sl<CompleteStep>()(
      CompleteStepParams(activityId: activityId, stepId: stepId),
    );
    if (!mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ActivityStageArgs;
    final step = args.step;

    return Scaffold(
      backgroundColor: AppDesignTokens.colorGray100,
      appBar: SeniorEaseAppBar(
        onProfileTap: () => Navigator.of(context).pushNamed(RouteNames.profile),
        onLogoutTap: () async {
          await sl<AuthController>().signOut();
          if (context.mounted) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil(RouteNames.login, (route) => false);
          }
        },
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            Text(
              step.label,
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeH4,
                fontWeight: AppDesignTokens.fontWeightBold,
                color: AppDesignTokens.colorContentDefault,
              ),
            ),
            SizedBox(height: AppDesignTokens.spacingLg),
            if (step.kind == TaskStepKind.contentReading)
              ..._buildReadingContent(args.activityId, step)
            else
              ..._buildQuizContent(args.activityId, step),
            SizedBox(height: AppDesignTokens.spacingXl),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Voltar para o passo-a-passo',
                style: TextStyle(
                  color: AppDesignTokens.colorPrimary,
                  fontSize: AppDesignTokens.fontSizeBody,
                  fontWeight: AppDesignTokens.fontWeightSemibold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildReadingContent(String activityId, TaskStep step) {
    return [
      Text(
        step.body ?? '',
        style: TextStyle(
          fontSize: AppDesignTokens.fontSizeBody,
          height: AppDesignTokens.lineHeightBody,
          color: AppDesignTokens.colorContentSecondary,
        ),
      ),
      SizedBox(height: AppDesignTokens.spacingLg),
      AppButton(
        label: 'Marcar como concluído',
        loading: _isSubmitting,
        onPressed: step.completed
            ? null
            : () => _complete(activityId, step.id),
        variant: ButtonVariant.primary,
      ),
    ];
  }

  List<Widget> _buildQuizContent(String activityId, TaskStep step) {
    return [
      if (step.question != null) ...[
        Text(
          step.question!,
          style: TextStyle(
            fontSize: AppDesignTokens.fontSizeBody,
            height: AppDesignTokens.lineHeightBody,
            color: AppDesignTokens.colorContentSecondary,
          ),
        ),
        SizedBox(height: AppDesignTokens.spacingLg),
      ],
      for (final option in step.options ?? <TaskStepOption>[])
        Padding(
          padding: EdgeInsets.only(bottom: AppDesignTokens.spacingMd),
          child: AppCard.simple(
            title: option.label,
            selected: false,
            onTap: _isSubmitting || step.completed
                ? null
                : () => _complete(activityId, step.id),
          ),
        ),
    ];
  }
}
