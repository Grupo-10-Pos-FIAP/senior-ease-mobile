import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_card.dart';

class _DemoOption {
  const _DemoOption({required this.id, required this.label});

  final String id;
  final String label;
}

class _DemoContent {
  const _DemoContent({required this.question, required this.options});

  final String question;
  final List<_DemoOption> options;
}

bool _isEmailQuizStep(String stepLabel) {
  return RegExp(r'e-mail|email|mensagem', caseSensitive: false).hasMatch(
    stepLabel,
  );
}

_DemoContent _demoContentFor(String stepLabel) {
  if (_isEmailQuizStep(stepLabel)) {
    return const _DemoContent(
      question: 'Qual campo indica para quem você está enviando o e-mail?',
      options: [
        _DemoOption(id: 'opt-para', label: 'Campo "Para"'),
        _DemoOption(id: 'opt-assunto', label: 'Campo "Assunto"'),
        _DemoOption(id: 'opt-corpo', label: 'Corpo da mensagem'),
        _DemoOption(id: 'opt-anexos', label: 'Anexos'),
      ],
    );
  }

  return const _DemoContent(
    question: 'Qual atitude ajuda a estudar com segurança na internet?',
    options: [
      _DemoOption(id: 'opt-a', label: 'Pedir ajuda quando tiver dúvida'),
      _DemoOption(id: 'opt-b', label: 'Clicar em links desconhecidos sem ler'),
      _DemoOption(id: 'opt-c', label: 'Usar senhas fáceis de adivinhar'),
      _DemoOption(id: 'opt-d', label: 'Ignorar avisos de segurança'),
    ],
  );
}

class MultipleChoiceTutorial extends StatefulWidget {
  const MultipleChoiceTutorial({
    super.key,
    required this.stepLabel,
    this.onCanCompleteChange,
  });

  final String stepLabel;
  final ValueChanged<bool>? onCanCompleteChange;

  @override
  State<MultipleChoiceTutorial> createState() => _MultipleChoiceTutorialState();
}

class _MultipleChoiceTutorialState extends State<MultipleChoiceTutorial> {
  String? _selected;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCanCompleteChange?.call(false);
    });
  }

  void _select(String id) {
    setState(() => _selected = id);
    widget.onCanCompleteChange?.call(true);
  }

  @override
  Widget build(BuildContext context) {
    final demo = _demoContentFor(widget.stepLabel);
    final hasSelection = _selected != null;

    return Padding(
      padding: EdgeInsets.all(AppDesignTokens.spacingLg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.stepLabel,
            style: TextStyle(
              fontSize: AppDesignTokens.fontSizeH4,
              fontWeight: AppDesignTokens.fontWeightBold,
              color: AppDesignTokens.colorContentPrimary,
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingLg),
          Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeBody,
                height: AppDesignTokens.lineHeightBody,
                color: AppDesignTokens.colorContentDefault,
              ),
              children: const [
                TextSpan(text: 'Nesta tarefa você responde um '),
                TextSpan(
                  text: 'quiz de múltipla escolha',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '. Siga os passos abaixo e pratique com o exemplo.',
                ),
              ],
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingMd),
          _NumberedSteps(
            steps: const [
              'Leia a pergunta com calma — ela explica o que você deve responder.',
              'Toque na opção que você acha correta. O círculo ao lado fica marcado quando a opção está selecionada.',
              'Em cada pergunta você escolhe apenas uma resposta. Se tocar em outra opção, a anterior desmarca sozinha.',
              'Confira sua escolha antes de tocar no botão abaixo.',
            ],
          ),
          SizedBox(height: AppDesignTokens.spacingLg),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDesignTokens.spacingMd),
            decoration: BoxDecoration(
              color: AppDesignTokens.colorBgLight,
              borderRadius: BorderRadius.circular(
                AppDesignTokens.borderRadiusDefault,
              ),
              border: Border.all(color: AppDesignTokens.colorBorderDefault),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exemplo de pergunta',
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeSmall,
                    fontWeight: AppDesignTokens.fontWeightSemibold,
                    color: AppDesignTokens.colorContentSecondary,
                  ),
                ),
                SizedBox(height: AppDesignTokens.spacingSm),
                Text(
                  demo.question,
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeBody,
                    fontWeight: AppDesignTokens.fontWeightSemibold,
                    color: AppDesignTokens.colorContentDefault,
                  ),
                ),
                SizedBox(height: AppDesignTokens.spacingMd),
                for (final option in demo.options)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppDesignTokens.spacingMd),
                    child: AppCard.simple(
                      title: option.label,
                      selected: _selected == option.id,
                      onTap: () => _select(option.id),
                    ),
                  ),
              ],
            ),
          ),
          if (!hasSelection) ...[
            SizedBox(height: AppDesignTokens.spacingSm),
            Text(
              'Escolha uma opção para continuar.',
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

class _NumberedSteps extends StatelessWidget {
  const _NumberedSteps({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < steps.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: AppDesignTokens.spacingSm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${i + 1}. ',
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeBody,
                    fontWeight: AppDesignTokens.fontWeightSemibold,
                    color: AppDesignTokens.colorContentDefault,
                  ),
                ),
                Expanded(
                  child: Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: AppDesignTokens.fontSizeBody,
                      height: AppDesignTokens.lineHeightBody,
                      color: AppDesignTokens.colorContentDefault,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
