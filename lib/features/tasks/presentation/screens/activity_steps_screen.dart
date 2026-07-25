import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/logout_action.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/presentation/controllers/task_steps_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_card.dart';
import 'package:senior_ease/shared/widgets/app_dialog.dart';

class ActivityStepsScreen extends StatelessWidget {
  const ActivityStepsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final activityId = ModalRoute.of(context)!.settings.arguments as String;
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
                return const SizedBox.shrink();
              }
              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDesignTokens.spacingMd,
                  vertical: AppDesignTokens.spacingLg,
                ),
                children: [
                  Text(
                    "Como fazer: ${controller.activityTitle}",
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
                              '${controller.steps.length == 1 ? "tarefa" : "tarefas"}',
                          style: TextStyle(
                            fontWeight: AppDesignTokens.fontWeightBold,
                          ),
                        ),
                        const TextSpan(
                          text:
                              ' para você estudar. Em cada uma abaixo, toque '
                              'no cartão para aprender como fazer antes de '
                              'começar.',
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
                    final step = entry.value;
                    return AppCard.simple(

                      title: step.label,
                      subtitle: step.completed ? 'Etapa concluída' : 'Pendente',
                      selected: step.completed,
                      onTap: () async {
                        await Navigator.of(context).pushNamed(
                          RouteNames.stage,
                          arguments: (
                            activityId: activityId,
                            initialStepIndex: entry.key,
                          ),
                        );
                        // The stage screen owns its own TaskStepsController
                        // instance — reload this one to pick up whatever
                        // got completed while the user was in there.
                        if (context.mounted) controller.load(activityId);
                      },
                    );
                  }),
                  SizedBox(height: AppDesignTokens.spacingLg),
                  AppButton(
                    label: 'Concluir atividade',
                    onPressed: () async {
                      final confirmed = await AppDialog.confirm(
                        context,
                        title: 'Deseja concluir ${controller.activityTitle}?',
                        description:
                            'A atividade será movida para a aba de '
                            '"atividades concluídas".',
                        confirmLabel: 'Concluir',
                        cancelLabel: 'Não, ainda não',
                      );
                      if (!confirmed) return;
                      await controller.completeActivity();
                      if (context.mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          RouteNames.home,
                          (route) => false,
                        );
                      }
                    },
                    variant: ButtonVariant.primary,
                  ),
                  SizedBox(height: AppDesignTokens.spacingMd),
                  AppButton(
                    leadingIcon: const Icon(Icons.arrow_back),
                    label: 'Voltar para minhas atividades',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    variant: ButtonVariant.outlined,
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

class _StepTag extends StatelessWidget {
  const _StepTag({required this.kind});

  final TaskStepKind kind;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDesignTokens.spacingSm,
        vertical: AppDesignTokens.spacingXs,
      ),
      decoration: BoxDecoration(
        color: AppDesignTokens.colorPrimarySurface,
        borderRadius: BorderRadius.circular(
          AppDesignTokens.borderRadiusDefault,
        ),
      ),
      child: Text(
        kind == TaskStepKind.contentReading
            ? 'Leitura de conteúdo'
            : 'Múltipla escolha',
        style: TextStyle(
          fontSize: AppDesignTokens.fontSizeSmall,
          fontWeight: AppDesignTokens.fontWeightSemibold,
          color: AppDesignTokens.colorPrimary,
        ),
      ),
    );
  }
}
