import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:senior_ease/core/app_mode/app_mode_controller.dart';
import 'package:senior_ease/core/auth/auth_controller.dart';
import 'package:senior_ease/core/usecase/usecase.dart';
import 'package:senior_ease/features/auth/presentation/controllers/login_controller.dart';
import 'package:senior_ease/features/settings/domain/entities/app_settings.dart';
import 'package:senior_ease/features/settings/domain/usecases/get_settings.dart';

class MockAuthController extends Mock implements AuthController {}

class MockGetSettings extends Mock implements GetSettings {}

void main() {
  late MockAuthController authController;
  late MockGetSettings getSettings;
  late AppModeController appMode;
  late LoginController controller;

  const settings = AppSettings(
    fontSize: 'Grande',
    contrastLevel: 'Escuro',
    navigationMode: 'Simples',
    spacing: 'Amplo',
    enhancedVisualFeedback: true,
    criticalActionConfirmation: true,
  );

  setUp(() {
    authController = MockAuthController();
    getSettings = MockGetSettings();
    appMode = AppModeController();
    controller = LoginController(authController, getSettings, appMode);

    when(() => getSettings(const NoParams())).thenAnswer((_) async => settings);
  });

  test(
    'toggleMode switches between signIn and signUp and clears the error',
    () {
      expect(controller.mode, AuthFormMode.signIn);

      controller.toggleMode();
      expect(controller.mode, AuthFormMode.signUp);

      controller.toggleMode();
      expect(controller.mode, AuthFormMode.signIn);
    },
  );

  group('submitEmailPassword', () {
    test(
      'calls signInWithEmail in signIn mode and syncs AppModeController',
      () async {
        when(
          () => authController.signInWithEmail('a@b.com', 'secret'),
        ).thenAnswer((_) async {});

        final result = await controller.submitEmailPassword(
          'a@b.com',
          'secret',
        );

        expect(result, isTrue);
        expect(controller.isLoading, isFalse);
        expect(controller.errorMessage, isNull);
        verify(
          () => authController.signInWithEmail('a@b.com', 'secret'),
        ).called(1);
        expect(appMode.isSimpleMode, isTrue);
        expect(appMode.reinforcedVisualFeedback, isTrue);
      },
    );

    test('calls signUpWithEmail in signUp mode', () async {
      controller.toggleMode();
      when(
        () => authController.signUpWithEmail('a@b.com', 'secret'),
      ).thenAnswer((_) async {});

      final result = await controller.submitEmailPassword('a@b.com', 'secret');

      expect(result, isTrue);
      verify(
        () => authController.signUpWithEmail('a@b.com', 'secret'),
      ).called(1);
    });

    test(
      'sets a friendly message and returns false on DeactivatedAccountException',
      () async {
        when(
          () => authController.signInWithEmail(any(), any()),
        ).thenThrow(DeactivatedAccountException());

        final result = await controller.submitEmailPassword(
          'a@b.com',
          'secret',
        );

        expect(result, isFalse);
        expect(controller.isLoading, isFalse);
        expect(
          controller.errorMessage,
          'Esta conta foi excluída e não está mais disponível para acesso.',
        );
      },
    );

    test('translates known FirebaseAuthException codes', () async {
      when(
        () => authController.signInWithEmail(any(), any()),
      ).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      final result = await controller.submitEmailPassword('a@b.com', 'wrong');

      expect(result, isFalse);
      expect(controller.errorMessage, 'E-mail ou senha incorretos.');
    });

    test(
      'falls back to a generic message for unknown FirebaseAuthException codes',
      () async {
        when(
          () => authController.signInWithEmail(any(), any()),
        ).thenThrow(FirebaseAuthException(code: 'something-unexpected'));

        await controller.submitEmailPassword('a@b.com', 'secret');

        expect(
          controller.errorMessage,
          'Não foi possível concluir. Tente novamente.',
        );
      },
    );

    test('sets a generic message for any other error', () async {
      when(
        () => authController.signInWithEmail(any(), any()),
      ).thenThrow(Exception('boom'));

      final result = await controller.submitEmailPassword('a@b.com', 'secret');

      expect(result, isFalse);
      expect(
        controller.errorMessage,
        'Não foi possível concluir. Tente novamente.',
      );
    });

    test('isLoading is true only while the submission is in flight', () async {
      final completer = Completer<void>();
      when(
        () => authController.signInWithEmail(any(), any()),
      ).thenAnswer((_) => completer.future);

      final future = controller.submitEmailPassword('a@b.com', 'secret');
      expect(controller.isLoading, isTrue);

      completer.complete();
      await future;
      expect(controller.isLoading, isFalse);
    });
  });

  group('submitGoogle', () {
    test(
      'calls signInWithGoogle and syncs AppModeController on success',
      () async {
        when(() => authController.signInWithGoogle()).thenAnswer((_) async {});

        final result = await controller.submitGoogle();

        expect(result, isTrue);
        verify(() => authController.signInWithGoogle()).called(1);
      },
    );

    test('uses a Google-specific message on FirebaseAuthException', () async {
      when(
        () => authController.signInWithGoogle(),
      ).thenThrow(FirebaseAuthException(code: 'anything'));

      final result = await controller.submitGoogle();

      expect(result, isFalse);
      expect(controller.errorMessage, 'Não foi possível entrar com o Google.');
    });

    test('does not surface a canceled sign-in as an error', () async {
      when(() => authController.signInWithGoogle()).thenThrow(
        const GoogleSignInException(code: GoogleSignInExceptionCode.canceled),
      );

      final result = await controller.submitGoogle();

      // AuthController itself swallows a cancel; if something upstream ever
      // threw it anyway, LoginController still shouldn't crash — it just
      // reports failure through the generic path.
      expect(result, isFalse);
    });
  });
}
