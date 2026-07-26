import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/auth/logout_action.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/mark_activity_started.dart';
import 'package:senior_ease/features/tasks/presentation/controllers/task_steps_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_dialog.dart';

class ActivityStepsScreen extends StatelessWidget {
  const ActivityStepsScreen({super.key});

  Future<void> _startActivity(
    BuildContext context,
    TaskStepsController controller,
    String activityId,
  ) async {
    final confirmed = await AppDialog.confirm(
      context,
      title: controller.started
          ? 'Continuar esta atividade?'
          : 'Iniciar esta atividade?',
      description: controller.started
          ? 'Você vai continuar "${controller.activityTitle}" a partir do '
              'primeiro passo pendente. Deseja continuar agora?'
          : 'Você vai iniciar "${controller.activityTitle}" a partir do '
              'primeiro passo. Deseja começar agora?',
      confirmLabel: controller.started ? 'Sim, continuar' : 'Sim, iniciar',
      cancelLabel: 'Não, ainda não',
      onlyInBasicMode: true,
      stackedActions: true,
    );
    if (!confirmed || !context.mounted) return;

    final completedCount = controller.steps
        .where((step) => step.completed)
        .length;
    await sl<MarkActivityStarted>()(activityId);
    if (!context.mounted) return;
    await Navigator.of(context).pushNamed(
      RouteNames.stage,
      arguments: (activityId: activityId, initialStepIndex: completedCount),
    );
    if (context.mounted) controller.load(activityId);
  }

  @override
  Widget build(BuildContext context) {
    final activityId = ModalRoute.of(context)!.settings.arguments as String;
    final isSimpleMode = sl<AppModeController>().isSimpleMode;
    final howToLabel = isSimpleMode ? 'Como fazer esta tarefa?' : 'Como fazer?';
    final backLabel = isSimpleMode
        ? 'Voltar para Minhas atividades'
        : 'Voltar';

    return ChangeNotifierProvider<TaskStepsController>(
      create: (_) => sl<TaskStepsController>()..load(activityId),
      child: Scaffold(
        backgroundColor: AppDesignTokens.colorGray100,
        appBar: SeniorEaseAppBar(
          onProfileTap: () =>
              Navigator.of(context).pushNamed(RouteNames.profile),
          onLogoutTap: () => confirmAndSignOut(context),
        ),
        body: SafeArea(
          bottom: false,
          child: Consumer<TaskStepsController>(
            builder: (context, controller, _) {
              if (controller.isLoading) {
                return Center(
                  child: Text(
                    'Carregando guia da atividade…',
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeBody,
                      color: AppDesignTokens.colorContentSecondary,
                    ),
                  ),
                );
              }

              final primaryLabel = controller.started
                  ? (isSimpleMode ? 'Continuar a atividade' : 'Continuar')
                  : (isSimpleMode ? 'Iniciar a atividade' : 'Iniciar');

              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDesignTokens.spacingMd,
                  vertical: AppDesignTokens.spacingLg,
                ),
                children: [
                  Text(
                    'Como fazer: ${controller.activityTitle}',
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeH4,
                      fontWeight: AppDesignTokens.fontWeightBold,
                      color: AppDesignTokens.colorContentPrimary,
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: AppDesignTokens.fontSizeBody,
                        fontWeight: AppDesignTokens.fontWeightRegular,
                        color: AppDesignTokens.colorContentSecondary,
                      ),
                      children: [
                        const TextSpan(text: 'Esta atividade tem '),
                        TextSpan(
                          text:
                              '${controller.steps.length} '
                              '${controller.steps.length == 1 ? 'tarefa' : 'tarefas'}',
                          style: TextStyle(
                            fontWeight: AppDesignTokens.fontWeightBold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' para você estudar. Em cada uma abaixo, toque '
                              'no botão à direita para aprender como fazer '
                              'antes de começar.',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  Text(
                    'Tarefas desta atividade',
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeBody,
                      fontWeight: AppDesignTokens.fontWeightSemibold,
                      color: AppDesignTokens.colorContentPrimary,
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingLg),
                  ...controller.steps.asMap().entries.map((entry) {
                    final index = entry.key;
                    final step = entry.value;
                    return _GuideStepCard(
                      taskNumber: index + 1,
                      totalTasks: controller.steps.length,
                      step: step,
                      actionLabel: howToLabel,
                      onHowTo: () async {
                        await Navigator.of(context).pushNamed(
                          RouteNames.tutorial,
                          arguments: (
                            activityId: activityId,
                            stepId: step.id,
                          ),
                        );
                        if (context.mounted) controller.load(activityId);
                      },
                    );
                  }),
                  SizedBox(height: AppDesignTokens.spacingLg),
                  AppButton(
                    label: backLabel,
                    leadingIcon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                    variant: ButtonVariant.outlined,
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  AppButton(
                    label: primaryLabel,
                    leadingIcon: const Icon(Icons.play_arrow),
                    onPressed: () =>
                        _startActivity(context, controller, activityId),
                    variant: ButtonVariant.primary,
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

class _GuideStepCard extends StatelessWidget {
  const _GuideStepCard({
    required this.taskNumber,
    required this.totalTasks,
    required this.step,
    required this.actionLabel,
    required this.onHowTo,
  });

  final int taskNumber;
  final int totalTasks;
  final TaskStep step;
  final String actionLabel;
  final VoidCallback onHowTo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppDesignTokens.spacingMd),
      padding: EdgeInsets.all(AppDesignTokens.spacingLg),
      decoration: BoxDecoration(
        color: AppDesignTokens.colorBgLight,
        borderRadius: BorderRadius.circular(
          AppDesignTokens.borderRadiusDefault,
        ),
        border: Border.all(color: AppDesignTokens.colorBorderDefault, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tarefa $taskNumber de $totalTasks',
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeSmall,
              fontWeight: AppDesignTokens.fontWeightSemibold,
              color: AppDesignTokens.colorContentSecondary,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingSm),
          Text(
            step.label,
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeSubtitle,
              fontWeight: AppDesignTokens.fontWeightBold,
              color: AppDesignTokens.colorContentDefault,
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingSm),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDesignTokens.spacingMd,
                vertical: AppDesignTokens.spacingXs,
              ),
              decoration: BoxDecoration(
                color: AppDesignTokens.colorPrimarySurface,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                step.typeLabel,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeSmall,
                  fontWeight: AppDesignTokens.fontWeightSemibold,
                  color: AppDesignTokens.colorPrimary,
                ),
              ),
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingMd),
          AppButton(
            label: actionLabel,
            onPressed: onHowTo,
            variant: ButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
