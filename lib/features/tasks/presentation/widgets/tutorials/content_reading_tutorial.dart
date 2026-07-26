import 'package:flutter/material.dart';
import 'package:senior_ease/features/tasks/presentation/widgets/tutorials/guided_tutorial_header.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class ContentReadingTutorial extends StatelessWidget {
  const ContentReadingTutorial({super.key, required this.stepLabel});

  final String stepLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const GuidedTutorialHeader(
          hint:
              'Leia o texto com calma, do começo ao fim. Role a página se precisar.',
        ),
        Padding(
          padding: EdgeInsets.all(AppDesignTokens.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stepLabel,
                style: TextStyle(
                  fontSize: AppDesignTokens.fontSizeH4,
                  fontWeight: AppDesignTokens.fontWeightBold,
                  color: AppDesignTokens.colorContentPrimary,
                ),
              ),
              SizedBox(height: AppDesignTokens.spacingLg),
              Text(
                'O mundo digital reúne ferramentas para aprender, conversar '
                'com familiares, resolver tarefas do dia a dia e buscar '
                'oportunidades de trabalho. Não é preciso saber tudo de uma '
                'vez — cada pessoa aprende no seu ritmo.',
                style: _bodyStyle,
              ),
              SizedBox(height: AppDesignTokens.spacingMd),
              Text(
                'Na internet, você encontra textos para estudar, vídeos '
                'explicativos, perguntas para refletir e quizzes para fixar o '
                'que aprendeu. O importante é ler com atenção, assistir com '
                'calma e pedir ajuda quando algo não estiver claro.',
                style: _bodyStyle,
              ),
              SizedBox(height: AppDesignTokens.spacingMd),
              Text(
                'Errar faz parte do aprendizado. Com prática e paciência, o '
                'digital pode se tornar um aliado na sua rotina acadêmica e '
                'profissional.',
                style: _bodyStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }

  TextStyle get _bodyStyle => TextStyle(
    fontSize: AppDesignTokens.fontSizeBody,
    height: AppDesignTokens.lineHeightBody,
    color: AppDesignTokens.colorContentDefault,
  );
}
