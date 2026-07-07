import 'package:flutter/material.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';
import 'package:senior_ease/shared/widgets/app_card.dart';
import 'package:senior_ease/shared/widgets/app_bar.dart';
import 'package:senior_ease/shared/widgets/app_button.dart';

class ActivityStepsScreen extends StatefulWidget {
  const ActivityStepsScreen({super.key});

  @override
  State<ActivityStepsScreen> createState() => _ActivityStepsScreenState();
}

class _ActivityStepsScreenState extends State<ActivityStepsScreen> {
  final List<_ActivityStep> _steps = [
    _ActivityStep(title: 'Boas-vindas e apresentação', completed: true),
    _ActivityStep(title: 'Conhecendo o aparelho', completed: true),
    _ActivityStep(title: 'Aprendendo toques e comandos', completed: false),
    _ActivityStep(title: 'Conectando à internet', completed: false),
  ];

  void _toggleStepCompletion(int index) {
    setState(() {
      _steps[index] = _steps[index].copyWith(
        completed: !_steps[index].completed,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppDesignTokens.colorGray100,
      appBar: SeniorEaseAppBar(
        onProfileTap: () {},
        onLogoutTap: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDesignTokens.spacingMd,
            vertical: AppDesignTokens.spacingLg,
          ),
          children: [
            Text(
              'Oficina “Primeiros Passos no Digital”',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeH4,
                fontWeight: AppDesignTokens.fontWeightBold,
                color: AppDesignTokens.colorContentDefault,
              ),
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            Text(
              'Etapas concluídas',
              style: TextStyle(
                fontSize: AppDesignTokens.fontSizeBody,
                fontWeight: AppDesignTokens.fontWeightSemibold,
                color: AppDesignTokens.colorContentSecondary,
              ),
            ),
            const SizedBox(height: AppDesignTokens.spacingLg),
            ..._steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              return AppCard.simple(
                title: step.title,
                subtitle: step.completed ? 'Etapa concluída' : 'Pendente',
                selected: step.completed,
                onTap: () {
                  _toggleStepCompletion(index);
                  Navigator.of(context).pushNamed('/stage');
                },
              );
            }),
            const SizedBox(height: AppDesignTokens.spacingLg),
            AppButton(
              label: 'Concluir atividade',
              onPressed: () => Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/home', (route) => false),
              variant: ButtonVariant.primary,
            ),
            const SizedBox(height: AppDesignTokens.spacingMd),
            AppButton(
              label: 'Voltar para minhas atividades',
              onPressed: () {
                Navigator.of(context).pop();
              },
              variant: ButtonVariant.outlined,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityStep {
  final String title;
  final bool completed;

  _ActivityStep({required this.title, required this.completed});

  _ActivityStep copyWith({String? title, bool? completed}) {
    return _ActivityStep(
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
