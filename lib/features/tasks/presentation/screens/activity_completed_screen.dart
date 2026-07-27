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

  bool get _hasGradedQuestions => _summary.total > 0;
  bool get _hasIncorrectAnswers =>
      _hasGradedQuestions && _summary.incorrect > 0;

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
                  Center(child: _CompletedIcon(hasIncorrect: _hasIncorrectAnswers)),
                  SizedBox(height: AppDesignTokens.spacingLg),
                  Text(
                    _hasIncorrectAnswers
                        ? 'Você concluiu a atividade. Veja seu resultado.'
                        : 'Parabéns! Você concluiu a atividade',
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
                  if (_hasGradedQuestions) ...[
                    Text(
                      formatAnswerSummaryMessage(_summary),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: AppDesignTokens.fontSizeBody,
                        height: AppDesignTokens.lineHeightBody,
                        color: AppDesignTokens.colorContentPrimary,
                      ),
                    ),
                    SizedBox(height: AppDesignTokens.spacingLg),
                    Text(
                      _summary.total == 1 ? 'Sua resposta' : 'Suas respostas',
                      style: TextStyle(
                        fontSize: AppDesignTokens.fontSizeH4,
                        fontWeight: AppDesignTokens.fontWeightBold,
                        color: AppDesignTokens.colorContentPrimary,
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
                        color: AppDesignTokens.colorContentPrimary,
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
                    variant: ButtonVariant.secondary,
                    leadingIcon: const Icon(Icons.arrow_back),
                  ),
                ],
              ),
      ),
    );
  }
}

class _CompletedIcon extends StatelessWidget {
  const _CompletedIcon({required this.hasIncorrect});

  final bool hasIncorrect;

  @override
  Widget build(BuildContext context) {
    if (hasIncorrect) {
      return Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: AppDesignTokens.colorWarningSurface,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppDesignTokens.colorWarningBorder,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.assignment_outlined,
          color: AppDesignTokens.colorContentPrimary,
          size: 32,
        ),
      );
    }

    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        color: AppDesignTokens.colorBadgeScheduledForeground,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.check, color: Colors.white, size: 36),
    );
  }
}

class _AnswerResultCard extends StatelessWidget {
  const _AnswerResultCard({required this.result});

  final ActivityAnswerResult result;

  @override
  Widget build(BuildContext context) {
    final borderColor = result.isCorrect
        ? AppDesignTokens.colorBadgeScheduledForeground
        : AppDesignTokens.colorWarningBorder;
    final statusColor = result.isCorrect
        ? AppDesignTokens.colorBadgeScheduledForeground
        : AppDesignTokens.colorContentPrimary;

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
          Text(
            result.isCorrect
                ? '🎉 Parabéns! Você respondeu corretamente. Continue assim!'
                : '💙 A resposta não foi a correta. Não tem problema! '
                    'Veja abaixo qual era a resposta certa.',
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeBody,
              fontWeight: AppDesignTokens.fontWeightBold,
              height: AppDesignTokens.lineHeightBody,
              color: statusColor,
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingSm),
          Text(
            'Pergunta: ${result.question}',
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeBody,
              fontWeight: AppDesignTokens.fontWeightSemibold,
              color: AppDesignTokens.colorContentPrimary,
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
              'Resposta certa: ${result.correctOptionLabel}',
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
