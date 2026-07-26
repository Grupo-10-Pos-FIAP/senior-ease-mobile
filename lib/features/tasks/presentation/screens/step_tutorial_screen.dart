import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/auth/logout_action.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/tasks/domain/entities/task_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/complete_guide_step.dart';
import 'package:senior_ease/features/tasks/domain/usecases/mark_activity_started.dart';
import 'package:senior_ease/features/tasks/presentation/controllers/task_steps_controller.dart';
import 'package:senior_ease/features/tasks/presentation/widgets/tutorials/step_tutorial_renderer.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';
import 'package:senior_ease/shared/widgets/app_dialog.dart';

typedef StepTutorialArgs = ({String activityId, String stepId});

class StepTutorialScreen extends StatefulWidget {
  const StepTutorialScreen({super.key});

  @override
  State<StepTutorialScreen> createState() => _StepTutorialScreenState();
}

class _StepTutorialScreenState extends State<StepTutorialScreen> {
  late final TaskStepsController _controller;
  bool _initialized = false;
  bool _tutorialReady = false;
  bool _isSubmitting = false;
  String? _saveError;
  String? _currentStepId;

  @override
  void initState() {
    super.initState();
    _controller = sl<TaskStepsController>();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _initFromArgs(StepTutorialArgs args) {
    if (!_initialized) {
      _initialized = true;
      _currentStepId = args.stepId;
      _controller.load(args.activityId);
      return;
    }

    if (_currentStepId != args.stepId) {
      _currentStepId = args.stepId;
      _tutorialReady = false;
      _saveError = null;
    }
  }

  bool _isActionAlwaysEnabled(TaskStepKind kind) {
    return kind == TaskStepKind.contentReading ||
        kind == TaskStepKind.watchContent;
  }

  ({String label, String ariaLabel})? _actionConfig(TaskStepKind kind) {
    switch (kind) {
      case TaskStepKind.contentReading:
        return (
          label: 'Terminei de ler',
          ariaLabel: 'Confirmar que terminou de ler o texto',
        );
      case TaskStepKind.watchContent:
        return (
          label: 'Terminei de assistir',
          ariaLabel: 'Confirmar que terminou de assistir ao vídeo',
        );
      case TaskStepKind.multipleChoice:
        return (
          label: 'Já aprendi',
          ariaLabel: 'Confirmar que já aprendeu a escolher uma resposta',
        );
      case TaskStepKind.openQuestion:
        return (
          label: 'Enviar resposta',
          ariaLabel: 'Enviar resposta de exemplo',
        );
    }
  }

  Future<void> _completeTutorial({
    required String activityId,
    required TaskStep step,
    required TaskStep? nextStep,
  }) async {
    setState(() {
      _isSubmitting = true;
      _saveError = null;
    });
    try {
      await sl<CompleteGuideStep>()(
        CompleteGuideStepParams(activityId: activityId, stepId: step.id),
      );
      _controller.markGuideCompleted(step.id);
      if (!mounted) return;

      if (nextStep == null) {
        await _showGuideCompleteDialog(activityId);
      } else {
        await _showContinueDialog(activityId, nextStep);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _saveError = 'Não foi possível salvar seu progresso. Tente novamente.';
      });
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _showContinueDialog(
    String activityId,
    TaskStep nextStep,
  ) async {
    final goNext = await showDialog<bool>(
      context: context,
      builder: (context) => AppDialog(
        title: 'O que você deseja fazer agora?',
        description:
            'Você pode voltar para a lista de tarefas ou seguir para '
            '"${nextStep.label}".',
        confirmLabel: 'Ir para a próxima tarefa',
        cancelLabel: 'Voltar para a lista de tarefas',
        stackedActions: true,
      ),
    );
    if (!mounted) return;
    if (goNext == true) {
      Navigator.of(context).pushReplacementNamed(
        RouteNames.tutorial,
        arguments: (activityId: activityId, stepId: nextStep.id),
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _showGuideCompleteDialog(String activityId) async {
    final started = _controller.started;
    final isSimpleMode = sl<AppModeController>().isSimpleMode;
    final primaryLabel = started
        ? (isSimpleMode ? 'Continuar a atividade' : 'Continuar')
        : (isSimpleMode ? 'Iniciar a atividade' : 'Iniciar');
    final actionVerb = started ? 'continuar' : 'iniciar';

    final startActivity = await showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: AppDesignTokens.colorSuccessSurface,
        insetPadding: EdgeInsets.symmetric(
          horizontal: AppDesignTokens.spacingLg,
          vertical: AppDesignTokens.spacingXl,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDesignTokens.borderRadiusDefault * 2,
          ),
          side: BorderSide(
            color: AppDesignTokens.colorSuccessBorder,
            width: 3,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDesignTokens.spacingLg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Parabéns! Você terminou o tutorial.',
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeH4,
                  fontWeight: AppDesignTokens.fontWeightBold,
                  color: AppDesignTokens.colorSuccessOnSurface,
                ),
              ),
              SizedBox(height: AppDesignTokens.spacingMd),
              Text(
                'Você viu todas as tarefas de "${_controller.activityTitle}" e '
                'já sabe como fazer cada uma. Deseja $actionVerb agora ou '
                'voltar para Minhas atividades?',
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  height: AppDesignTokens.lineHeightBody,
                  color: AppDesignTokens.colorSuccessOnSurface,
                ),
              ),
              SizedBox(height: AppDesignTokens.spacingLg),
              AppButton(
                label: 'Voltar para Minhas atividades',
                variant: ButtonVariant.outlined,
                backgroundColor: AppDesignTokens.colorPrimarySurface,
                onPressed: () => Navigator.of(context).pop(false),
              ),
              SizedBox(height: AppDesignTokens.spacingMd),
              AppButton(
                label: primaryLabel,
                variant: ButtonVariant.primary,
                leadingIcon: const Icon(Icons.play_arrow),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ),
      ),
    );

    if (!mounted) return;
    if (startActivity == true) {
      await _startActivity(activityId);
    } else {
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(RouteNames.home, (route) => false);
    }
  }

  Future<void> _startActivity(String activityId) async {
    final started = _controller.started;
    final confirmed = await AppDialog.confirm(
      context,
      title: started ? 'Continuar esta atividade?' : 'Iniciar esta atividade?',
      description: started
          ? 'Você vai continuar "${_controller.activityTitle}" a partir do '
              'primeiro passo pendente. Deseja continuar agora?'
          : 'Você vai iniciar "${_controller.activityTitle}" a partir do '
              'primeiro passo. Deseja começar agora?',
      confirmLabel: started ? 'Sim, continuar' : 'Sim, iniciar',
      cancelLabel: 'Não, ainda não',
      onlyInBasicMode: true,
      stackedActions: true,
    );
    if (!confirmed || !mounted) return;

    final completedCount = _controller.steps
        .where((step) => step.completed)
        .length;
    await sl<MarkActivityStarted>()(activityId);
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.stage,
      (route) => route.isFirst,
      arguments: (activityId: activityId, initialStepIndex: completedCount),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as StepTutorialArgs;
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
              if (controller.isLoading) {
                return Center(
                  child: Text(
                    'Carregando tutorial…',
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeBody,
                      color: AppDesignTokens.colorContentSecondary,
                    ),
                  ),
                );
              }

              final stepIndex = controller.steps.indexWhere(
                (step) => step.id == args.stepId,
              );
              if (stepIndex < 0) {
                return _NotFoundBody(
                  onBack: () => Navigator.of(context).pop(),
                );
              }

              final step = controller.steps[stepIndex];
              final nextStep = stepIndex + 1 < controller.steps.length
                  ? controller.steps[stepIndex + 1]
                  : null;
              final action = _actionConfig(step.kind);
              final canComplete =
                  _isActionAlwaysEnabled(step.kind) || _tutorialReady;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        StepTutorialRenderer(
                          kind: step.kind,
                          stepLabel: step.label,
                          onCanCompleteChange: (ready) {
                            if (!_isActionAlwaysEnabled(step.kind)) {
                              setState(() => _tutorialReady = ready);
                            }
                          },
                        ),
                        if (_saveError != null)
                          Padding(
                            padding: EdgeInsets.all(AppDesignTokens.spacingLg),
                            child: Text(
                              _saveError!,
                              style: TextStyle(
                                fontSize: AppDesignTokens.fontSizeBody,
                                color: AppDesignTokens.colorErrorOnSurface,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                      AppDesignTokens.spacingLg,
                      AppDesignTokens.spacingMd,
                      AppDesignTokens.spacingLg,
                      AppDesignTokens.spacingLg,
                    ),
                    decoration: BoxDecoration(
                      color: AppDesignTokens.colorBgLight,
                      border: Border(
                        top: BorderSide(
                          color: AppDesignTokens.colorBorderDefault,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        AppButton(
                          label: '',
                          variant: ButtonVariant.lightIcon,
                          leadingIcon: const Icon(Icons.arrow_back),
                          onPressed: _isSubmitting
                              ? null
                              : () => Navigator.of(context).pop(),
                        ),
                        SizedBox(width: AppDesignTokens.spacingMd),
                        if (action != null)
                          Expanded(
                            child: AppButton(
                              label: action.label,
                              variant: ButtonVariant.primary,
                              leadingIcon: const Icon(Icons.check),
                              loading: _isSubmitting,
                              onPressed: canComplete && !_isSubmitting
                                  ? () => _completeTutorial(
                                      activityId: args.activityId,
                                      step: step,
                                      nextStep: nextStep,
                                    )
                                  : null,
                            ),
                          ),
                      ],
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

class _NotFoundBody extends StatelessWidget {
  const _NotFoundBody({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDesignTokens.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tarefa não encontrada',
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeH4,
              fontWeight: AppDesignTokens.fontWeightBold,
              color: AppDesignTokens.colorContentPrimary,
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingMd),
          Text(
            'Esta tarefa não faz parte da atividade. Volte para a lista do guia.',
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeBody,
              color: AppDesignTokens.colorContentSecondary,
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingLg),
          AppButton(
            label: 'Voltar para o guia',
            variant: ButtonVariant.outlined,
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}
