import 'package:flutter_test/flutter_test.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/app_mode/contrast_level.dart';

void main() {
  late AppModeController controller;

  setUp(() {
    controller = AppModeController();
  });

  test('has sensible hardcoded defaults before any update', () {
    expect(controller.isSimpleMode, isFalse);
    expect(controller.fontScale, 1.0);
    expect(controller.spacingScale, 1.0);
    expect(controller.contrastLevel, ContrastLevel.padrao);
    expect(controller.reinforcedVisualFeedback, isFalse);
  });

  test('update() applies every field and notifies listeners', () {
    var notified = 0;
    controller.addListener(() => notified++);

    controller.update(
      isSimpleMode: true,
      fontScale: 1.3,
      spacingScale: 1.5,
      contrastLevel: ContrastLevel.escuro,
      reinforcedVisualFeedback: true,
    );

    expect(controller.isSimpleMode, isTrue);
    expect(controller.fontScale, 1.3);
    expect(controller.spacingScale, 1.5);
    expect(controller.contrastLevel, ContrastLevel.escuro);
    expect(controller.reinforcedVisualFeedback, isTrue);
    expect(notified, 1);
  });

  test(
    'update() with identical values is a no-op and skips notifyListeners',
    () {
      controller.update(
        isSimpleMode: true,
        fontScale: 1.3,
        spacingScale: 1.5,
        contrastLevel: ContrastLevel.escuro,
        reinforcedVisualFeedback: true,
      );

      var notified = 0;
      controller.addListener(() => notified++);

      controller.update(
        isSimpleMode: true,
        fontScale: 1.3,
        spacingScale: 1.5,
        contrastLevel: ContrastLevel.escuro,
        reinforcedVisualFeedback: true,
      );

      expect(notified, 0);
    },
  );

  test('update() notifies again when only one field changes', () {
    controller.update(
      isSimpleMode: false,
      fontScale: 1.0,
      spacingScale: 1.0,
      contrastLevel: ContrastLevel.padrao,
      reinforcedVisualFeedback: false,
    );
    var notified = 0;
    controller.addListener(() => notified++);

    controller.update(
      isSimpleMode: false,
      fontScale: 1.0,
      spacingScale: 1.0,
      contrastLevel: ContrastLevel.alto,
      reinforcedVisualFeedback: false,
    );

    expect(controller.contrastLevel, ContrastLevel.alto);
    expect(notified, 1);
  });
}
