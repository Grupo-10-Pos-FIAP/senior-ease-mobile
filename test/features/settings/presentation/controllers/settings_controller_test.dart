import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/app_mode/contrast_level.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';
import 'package:senior_ease/features/settings/domain/usecases/save_settings.dart';
import 'package:senior_ease/features/settings/presentation/controllers/settings_controller.dart';

class MockGetSettings extends Mock implements GetSettings {}

class MockSaveSettings extends Mock implements SaveSettings {}

void main() {
  late MockGetSettings getSettings;
  late MockSaveSettings saveSettings;
  late AppModeController appMode;
  late SettingsController controller;

  const persisted = AppSettings(
    fontSize: 'Normal',
    contrastLevel: 'Padrão',
    navigationMode: 'Avançado',
    spacing: 'Normal',
    enhancedVisualFeedback: false,
    criticalActionConfirmation: true,
  );

  setUpAll(() {
    registerFallbackValue(AppSettings.defaults());
  });

  setUp(() {
    getSettings = MockGetSettings();
    saveSettings = MockSaveSettings();
    appMode = AppModeController();
    controller = SettingsController(getSettings, saveSettings, appMode);

    when(
      () => getSettings(const NoParams()),
    ).thenAnswer((_) async => persisted);
    when(() => saveSettings(any())).thenAnswer((_) async {});
  });

  test(
    'load() fetches persisted settings and syncs AppModeController',
    () async {
      expect(controller.isLoading, isTrue);

      await controller.load();

      expect(controller.isLoading, isFalse);
      expect(controller.draft, persisted);
      expect(controller.hasUnsavedChanges, isFalse);
      expect(appMode.isSimpleMode, isFalse);
      expect(appMode.contrastLevel, ContrastLevel.padrao);
    },
  );

  test(
    'selecting an option previews it immediately, before any save',
    () async {
      await controller.load();

      controller.selectContrastLevel('Escuro');

      // The whole point of the fix: AppModeController (and therefore every
      // screen reading AppDesignTokens) reflects the new choice right away —
      // it must not wait for save().
      expect(appMode.contrastLevel, ContrastLevel.escuro);
      expect(controller.hasUnsavedChanges, isTrue);
      verifyNever(() => saveSettings(any()));
    },
  );

  test('selectNavigationMode previews Simples mode immediately', () async {
    await controller.load();

    controller.selectNavigationMode('Simples');

    expect(appMode.isSimpleMode, isTrue);
    expect(controller.hasUnsavedChanges, isTrue);
  });

  test('selectSpacing previews the new spacing scale immediately', () async {
    await controller.load();

    controller.selectSpacing('Muito amplo');

    expect(
      appMode.spacingScale,
      persisted.copyWith(spacing: 'Muito amplo').spacingScale,
    );
    expect(appMode.spacingScale, isNot(persisted.spacingScale));
  });

  test('setEnhancedVisualFeedback previews immediately', () async {
    await controller.load();

    controller.setEnhancedVisualFeedback(true);

    expect(appMode.reinforcedVisualFeedback, isTrue);
  });

  test(
    'save() persists draft, clears hasUnsavedChanges, keeps the preview',
    () async {
      await controller.load();
      controller.selectContrastLevel('Máximo');

      await controller.save();

      verify(() => saveSettings(controller.draft)).called(1);
      expect(controller.hasUnsavedChanges, isFalse);
      expect(appMode.contrastLevel, ContrastLevel.maximo);
    },
  );

  test(
    'resetToDefaults previews AppSettings.defaults() immediately, unsaved',
    () async {
      await controller.load();
      controller.selectNavigationMode('Simples');
      await controller.save();

      controller.resetToDefaults();

      expect(controller.draft, AppSettings.defaults());
      expect(
        appMode.isSimpleMode,
        AppSettings.defaults().navigationMode == 'Simples',
      );
      expect(controller.hasUnsavedChanges, isTrue);
      verifyNever(() => saveSettings(AppSettings.defaults()));
    },
  );

  test(
    'an unsaved preview reverts once load() runs again (e.g. next app launch)',
    () async {
      await controller.load();
      controller.selectContrastLevel('Escuro');
      expect(appMode.contrastLevel, ContrastLevel.escuro);

      await controller.load();

      expect(appMode.contrastLevel, ContrastLevel.padrao);
      expect(controller.hasUnsavedChanges, isFalse);
    },
  );
}
