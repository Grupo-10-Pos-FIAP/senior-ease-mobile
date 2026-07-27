import 'package:flutter/material.dart';
import 'package:senior_ease/app/di/injection_container.dart';
import 'package:senior_ease/core/auth/logout_action.dart';
import 'package:senior_ease/core/routes/route_names.dart';
import 'package:senior_ease/features/tasks/domain/entities/activity_answer_results.dart';
import 'package:senior_ease/features/tasks/domain/usecases/get_steps.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';

typedef ActivityCompletedArgs = ({String activityId});

class ActivityCompletedScreen extends StatefulWidget {
  const ActivityCompletedScreen({super.key});

  @override
  State<ActivityCompletedScreen> createState() => _ActivityCompletedScreenState();
}

class _ActivityCompletedScreenState extends State<ActivityCompletedScreen> {
  var _startedLoad = false;
  var _loading = true;
  String _title = '';
  List<ActivityAnswerResult> _results = const [];
  ActivityAnswerSummary _summary = const ActivityAnswerSummary(
    total: 0,
    correct: 0,
    incorrect: 0,
  );
  var _completedSteps = 0;
  var _totalSteps = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_startedLoad) return;
    _startedLoad = true;
    final args = ModalRoute.of(context)!.settings.arguments as ActivityCompletedArgs;
    _load(args.activityId);
  }

  Future<void> _load(String activityId) async {
    setState(() => _loading = true);
    final data = await sl<GetSteps>()(GetStepsParams(activityId: activityId));
    final results = getActivityAnswerResults(data.steps);
    if (!mounted) return;
    setState(() {
      _title = data.title;
      _results = results;
      _summary = summarizeActivityAnswers(results);
      _totalSteps = data.steps.length;
      _completedSteps = data.steps.where((step) => step.completed).length;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignTokens.colorGray100,
      appBar: SeniorEaseAppBar(
        onProfileTap: () => Navigator.of(context).pushNamed(RouteNames.profile),
        onLogoutTap: () => confirmAndSignOut(context),
      ),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDesignTokens.spacingMd,
                  vertical: AppDesignTokens.spacingLg,
                ),
                children: [
                  Center(
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: AppDesignTokens.colorBadgeScheduledForeground,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.check, color: Colors.white, size: 40),
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingLg),
                  Text(
                    'Parabéns! Você concluiu a atividade',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeH4,
                      fontWeight: AppDesignTokens.fontWeightBold,
                      color: AppDesignTokens.colorContentDefault,
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingSm),
                  Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeBody,
                      fontWeight: AppDesignTokens.fontWeightBold,
                      color: AppDesignTokens.colorContentSecondary,
                    ),
                  ),
                  SizedBox(height: AppDesignTokens.spacingLg),
                  if (_summary.total > 0) ...[
                    Text(
                      _summary.incorrect > 0
                          ? 'Você acertou ${_summary.correct} de ${_summary.total} '
                                '${_summary.total == 1 ? 'pergunta' : 'perguntas'}. '
                                'Errou ${_summary.incorrect}.'
                          : 'Você acertou ${_summary.correct} de ${_summary.total} '
                                '${_summary.total == 1 ? 'pergunta' : 'perguntas'}. '
                                'Muito bem!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDesignTokens.fontSizeBody,
                        height: AppDesignTokens.lineHeightBody,
                        color: AppDesignTokens.colorContentDefault,
                      ),
                    ),
                    SizedBox(height: AppDesignTokens.spacingLg),
                    Text(
                      'Suas respostas',
                      style: TextStyle(
                        fontSize: AppDesignTokens.fontSizeH4,
                        fontWeight: AppDesignTokens.fontWeightBold,
                        color: AppDesignTokens.colorContentDefault,
                      ),
                    ),
                    SizedBox(height: AppDesignTokens.spacingMd),
                    for (final result in _results) ...[
                      _AnswerResultCard(result: result),
                      SizedBox(height: AppDesignTokens.spacingMd),
                    ],
                  ] else ...[
                    Text(
                      'Você concluiu $_completedSteps de $_totalSteps '
                      '${_totalSteps == 1 ? 'passo' : 'passos'}. Muito bem!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDesignTokens.fontSizeBody,
                        height: AppDesignTokens.lineHeightBody,
                        color: AppDesignTokens.colorContentDefault,
                      ),
                    ),
                    SizedBox(height: AppDesignTokens.spacingLg),
                  ],
                  AppButton(
                    label: 'Voltar para Minhas atividades',
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        RouteNames.home,
                        (route) => false,
                      );
                    },
                    variant: ButtonVariant.primary,
                  ),
                ],
              ),
      ),
    );
  }
}

class _AnswerResultCard extends StatelessWidget {
  const _AnswerResultCard({required this.result});

  final ActivityAnswerResult result;

  @override
  Widget build(BuildContext context) {
    final statusColor = result.isCorrect
        ? AppDesignTokens.colorBadgeScheduledForeground
        : AppDesignTokens.colorErrorOnSurface;
    final borderColor = result.isCorrect
        ? AppDesignTokens.colorBadgeScheduledForeground
        : AppDesignTokens.colorErrorOnSurface;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppDesignTokens.spacingMd),
      decoration: BoxDecoration(
        color: AppDesignTokens.colorBgLight,
        borderRadius: BorderRadius.circular(AppDesignTokens.borderRadiusDefault),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                result.isCorrect ? Icons.check_circle : Icons.cancel,
                color: statusColor,
              ),
              SizedBox(width: AppDesignTokens.spacingSm),
              Text(
                result.isCorrect ? 'Acertou' : 'Errou',
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeBody,
                  fontWeight: AppDesignTokens.fontWeightBold,
                  color: statusColor,
                ),
              ),
            ],
          ),
          SizedBox(height: AppDesignTokens.spacingSm),
          Text(
            result.question,
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeBody,
              fontWeight: AppDesignTokens.fontWeightBold,
              color: AppDesignTokens.colorContentDefault,
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingSm),
          Text(
            'Sua resposta: ${result.userAnswerLabel}',
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeBody,
              color: AppDesignTokens.colorContentSecondary,
            ),
          ),
          if (!result.isCorrect) ...[
            SizedBox(height: AppDesignTokens.spacingXs),
            Text(
              'Resposta correta: ${result.correctOptionLabel}',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeBody,
                color: AppDesignTokens.colorContentSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
