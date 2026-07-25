import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/logout_action.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/complete_step.dart';
import 'package:senior_ease/features/tasks/presentation/controllers/task_steps_controller.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_card.dart';

/// [initialStepIndex] lets an entry point that already knows which step to
/// open skip ahead — the Dashboard passes the number of already-completed
/// steps (0 for a never-started activity), while the overview list passes
/// the exact index the user tapped.
typedef ActivityStageArgs = ({String activityId, int initialStepIndex});

class ActivityStageScreen extends StatefulWidget {
  const ActivityStageScreen({super.key});

  @override
  State<ActivityStageScreen> createState() => _ActivityStageScreenState();
}

class _ActivityStageScreenState extends State<ActivityStageScreen> {
  final _controller = sl<TaskStepsController>();
  bool _initialized = false;
  int _currentIndex = 0;
  bool _isSubmitting = false;
  String? _selectedOptionId;

  void _initFromArgs(ActivityStageArgs args) {
    if (_initialized) return;
    _initialized = true;
    _currentIndex = args.initialStepIndex;
    _controller.load(args.activityId);
  }

  bool _canAdvance(TaskStep step) {
    if (step.kind == TaskStepKind.contentReading) return true;
    return step.completed || _selectedOptionId != null;
  }

  Future<void> _goNext(String activityId, TaskStep step) async {
    setState(() => _isSubmitting = true);
    try {
      if (!step.completed) {
        await sl<CompleteStep>()(
          CompleteStepParams(activityId: activityId, stepId: step.id),
        );
        _controller.markCompleted(step.id);
      }
      if (!mounted) return;
      setState(() {
        _currentIndex++;
        _selectedOptionId = null;
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _goPrevious() {
    setState(() {
      _currentIndex--;
      _selectedOptionId = null;
    });
  }

  Future<void> _finishActivity(String activityId, TaskStep step) async {
    setState(() => _isSubmitting = true);
    try {
      if (!step.completed) {
        await sl<CompleteStep>()(
          CompleteStepParams(activityId: activityId, stepId: step.id),
        );
      }
      await _controller.completeActivity();
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(RouteNames.home, (route) => false);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ActivityStageArgs;
    _initFromArgs(args);

    return ChangeNotifierProvider<TaskStepsController>.value(
      value: _controller,
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
              if (controller.isLoading || controller.steps.isEmpty) {
                return const SizedBox.shrink();
              }
              final steps = controller.steps;
              final index = _currentIndex.clamp(0, steps.length - 1);
              final step = steps[index];
              final isFirst = index == 0;
              final isLast = index == steps.length - 1;

              return ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDesignTokens.spacingMd,
                  vertical: AppDesignTokens.spacingLg,
                ),
                children: [
                  Text(
                    'Passo ${index + 1} de ${steps.length}',
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeBody,
                      color: AppDesignTokens.colorContentSecondary,
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingSm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(
                      AppDesignTokens.borderRadiusDefault,
                    ),
                    child: LinearProgressIndicator(
                      value: (index + 1) / steps.length,
                      minHeight: 8,
                      backgroundColor: AppDesignTokens.colorGray200,
                      color: AppDesignTokens.colorPrimary,
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingLg),
                  _StepTag(kind: step.kind),
                  SizedBox(height: AppDesignTokens.spacingSm),
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
                    ..._buildReadingContent(step)
                  else
                    ..._buildQuizContent(step),
                  SizedBox(height: AppDesignTokens.spacingLg),
                  AppButton(
                    label: 'Sair e voltar depois',
                    icon: const Icon(Icons.schedule),
                    variant: ButtonVariant.outlined,
                    onPressed: _isSubmitting
                        ? null
                        : () => Navigator.of(context).pop(),
                  ),
                  if (!isFirst) ...[
                    SizedBox(height: AppDesignTokens.spacingMd),
                    AppButton(
                      label: 'Passo anterior',
                      icon: const Icon(Icons.chevron_left),
                      variant: ButtonVariant.outlined,
                      onPressed: _isSubmitting ? null : _goPrevious,
                    ),
                  ],
                  SizedBox(height: AppDesignTokens.spacingMd),
                  if (!isLast)
                    AppButton(
                      label: 'Próximo passo',
                      trailingIcon: const Icon(Icons.chevron_right),
                      loading: _isSubmitting,
                      onPressed: _canAdvance(step)
                          ? () => _goNext(args.activityId, step)
                          : null,
                      variant: ButtonVariant.primary,
                    )
                  else
                    AppButton(
                      label: 'Concluir atividade',
                      loading: _isSubmitting,
                      onPressed: _canAdvance(step)
                          ? () => _finishActivity(args.activityId, step)
                          : null,
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

  List<Widget> _buildReadingContent(TaskStep step) {
    return [
      Text(
        step.body ?? '',
        style: TextStyle(
          fontSize: AppDesignTokens.fontSizeBody,
          height: AppDesignTokens.lineHeightBody,
          color: AppDesignTokens.colorContentSecondary,
        ),
      ),
    ];
  }

  List<Widget> _buildQuizContent(TaskStep step) {
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
            selected: _selectedOptionId == option.id,
            onTap: _isSubmitting || step.completed
                ? null
                : () => setState(() => _selectedOptionId = option.id),
          ),
        ),
    ];
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
