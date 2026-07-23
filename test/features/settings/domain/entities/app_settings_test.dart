import 'package:flutter_test/flutter_test.dart';
import 'package:senior_ease/core/app_mode/contrast_level.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';

void main() {
  test('defaults() matches the documented default shape', () {
    final defaults = AppSettings.defaults();

    expect(defaults.fontSize, 'Normal');
    expect(defaults.contrastLevel, 'Padrão');
    expect(defaults.navigationMode, 'Avançado');
    expect(defaults.spacing, 'Normal');
    expect(defaults.enhancedVisualFeedback, isFalse);
    expect(defaults.criticalActionConfirmation, isTrue);
  });

  test(
    'fontScale/spacingScale are 1.0 at "Normal" and scale symmetrically',
    () {
      final defaults = AppSettings.defaults();
      expect(defaults.fontScale, 1.0);
      expect(defaults.spacingScale, 1.0);

      final smallest = defaults.copyWith(
        fontSize: 'Pequena',
        spacing: 'Compacto',
      );
      final largest = defaults.copyWith(
        fontSize: 'Muito grande',
        spacing: 'Muito amplo',
      );

      expect(smallest.fontScale, lessThan(1.0));
      expect(smallest.spacingScale, lessThan(1.0));
      expect(largest.fontScale, greaterThan(1.0));
      expect(largest.spacingScale, greaterThan(1.0));
    },
  );

  test('an unrecognized label falls back to a scale of 1.0', () {
    final settings = AppSettings.defaults().copyWith(fontSize: 'Desconhecido');

    expect(settings.fontScale, 1.0);
  });

  test('contrastLevelEnum maps each label to its ContrastLevel', () {
    final defaults = AppSettings.defaults();

    expect(
      defaults.copyWith(contrastLevel: 'Padrão').contrastLevelEnum,
      ContrastLevel.padrao,
    );
    expect(
      defaults.copyWith(contrastLevel: 'Suave').contrastLevelEnum,
      ContrastLevel.suave,
    );
    expect(
      defaults.copyWith(contrastLevel: 'Conforto').contrastLevelEnum,
      ContrastLevel.conforto,
    );
    expect(
      defaults.copyWith(contrastLevel: 'Alto').contrastLevelEnum,
      ContrastLevel.alto,
    );
    expect(
      defaults.copyWith(contrastLevel: 'Máximo').contrastLevelEnum,
      ContrastLevel.maximo,
    );
    expect(
      defaults.copyWith(contrastLevel: 'Escuro').contrastLevelEnum,
      ContrastLevel.escuro,
    );
  });

  test('an unrecognized contrast label falls back to padrao', () {
    final settings = AppSettings.defaults().copyWith(
      contrastLevel: 'Desconhecido',
    );

    expect(settings.contrastLevelEnum, ContrastLevel.padrao);
  });

  test('copyWith overrides only the given fields', () {
    final defaults = AppSettings.defaults();

    final updated = defaults.copyWith(
      navigationMode: 'Simples',
      enhancedVisualFeedback: true,
    );

    expect(updated.navigationMode, 'Simples');
    expect(updated.enhancedVisualFeedback, isTrue);
    expect(updated.fontSize, defaults.fontSize);
    expect(updated.contrastLevel, defaults.contrastLevel);
    expect(updated.spacing, defaults.spacing);
    expect(
      updated.criticalActionConfirmation,
      defaults.criticalActionConfirmation,
    );
  });

  test('== and hashCode compare by value', () {
    final a = AppSettings.defaults();
    final b = AppSettings.defaults();
    final c = AppSettings.defaults().copyWith(navigationMode: 'Simples');

    expect(a, b);
    expect(a.hashCode, b.hashCode);
    expect(a, isNot(c));
  });
}
