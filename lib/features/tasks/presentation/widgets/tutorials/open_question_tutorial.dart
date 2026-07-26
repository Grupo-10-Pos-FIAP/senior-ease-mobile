import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

class OpenQuestionTutorial extends StatefulWidget {
  const OpenQuestionTutorial({
    super.key,
    required this.stepLabel,
    this.onCanCompleteChange,
  });

  final String stepLabel;
  final ValueChanged<bool>? onCanCompleteChange;

  @override
  State<OpenQuestionTutorial> createState() => _OpenQuestionTutorialState();
}

class _OpenQuestionTutorialState extends State<OpenQuestionTutorial> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onCanCompleteChange?.call(false);
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChanged)
      ..dispose();
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
    widget.onCanCompleteChange?.call(_controller.text.trim().length >= 3);
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit = _controller.text.trim().length >= 3;

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
                TextSpan(text: 'Nesta tarefa você responde uma '),
                TextSpan(
                  text: 'questão aberta',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text:
                      '. Escreva com suas próprias palavras — não precisa ser '
                      'perfeito.',
                ),
              ],
            ),
          ),
          SizedBox(height: AppDesignTokens.spacingMd),
          _NumberedSteps(
            steps: const [
              'Leia a pergunta com atenção.',
              'Escreva sua resposta no campo abaixo, do jeito que você falaria.',
              'Revise o texto e toque em Enviar resposta quando estiver pronto.',
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
                  'O que você gostaria de aprender primeiro no mundo digital?',
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeBody,
                    fontWeight: AppDesignTokens.fontWeightSemibold,
                    color: AppDesignTokens.colorContentDefault,
                  ),
                ),
                SizedBox(height: AppDesignTokens.spacingMd),
                Text(
                  'Sua resposta',
                  style: TextStyle(
                    fontSize: AppDesignTokens.fontSizeBody,
                    fontWeight: AppDesignTokens.fontWeightMedium,
                    color: AppDesignTokens.colorContentDefault,
                  ),
                ),
                SizedBox(height: AppDesignTokens.spacingSm),
                TextField(
                  controller: _controller,
                  maxLines: 6,
                  decoration: InputDecoration(
                    hintText: 'Digite sua resposta aqui…',
                    filled: true,
                    fillColor: AppDesignTokens.colorGray100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDesignTokens.borderRadiusDefault,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (!canSubmit) ...[
            SizedBox(height: AppDesignTokens.spacingSm),
            Text(
              'Escreva pelo menos algumas palavras para continuar.',
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
