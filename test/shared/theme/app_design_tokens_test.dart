import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:senior_ease/core/app_mode/contrast_level.dart';
import 'package:senior_ease/shared/theme/app_design_tokens.dart';

void main() {
  void configure({
    double fontScale = 1.0,
    double spacingScale = 1.0,
    ContrastLevel contrast = ContrastLevel.padrao,
  }) {
    AppDesignTokens.configure(
      fontScale: fontScale,
      spacingScale: spacingScale,
      contrast: contrast,
    );
  }

  tearDown(() {
    // Static state persists across tests in this same file — always leave
    // it at the hardcoded defaults so no test depends on another's leftovers.
    configure();
  });

  group('Padrão (nível 1)', () {
    test('usa a paleta do web', () {
      configure();

      expect(AppDesignTokens.colorBgLight, const Color(0xFFFFFFFF));
      expect(AppDesignTokens.colorBase, const Color(0xFF1A1A1A));
      expect(AppDesignTokens.colorPrimary, const Color(0xFF1D2D50));
      expect(AppDesignTokens.colorBgDefault, const Color(0xFFF4F6F9));
      expect(AppDesignTokens.colorBorderDefault, const Color(0xFF949494));
      expect(AppDesignTokens.colorContentMuted, const Color(0xFF5A6478));
      expect(
        AppDesignTokens.buttonOutlinedBorderDefault,
        AppDesignTokens.colorPrimary,
      );
    });
  });

  group('Suave (nível 2)', () {
    test('usa fundo creme anti-reflexo do web', () {
      configure(contrast: ContrastLevel.suave);

      expect(AppDesignTokens.colorBgLight, const Color(0xFFF5F0E6));
      expect(AppDesignTokens.colorBase, const Color(0xFF2B2B2B));
      expect(AppDesignTokens.colorPrimary, const Color(0xFF2C5282));
      expect(AppDesignTokens.colorBgDefault, const Color(0xFFEBE4D6));
      expect(AppDesignTokens.colorBorderDefault, const Color(0xFF7A7268));
      expect(AppDesignTokens.colorContentMuted, const Color(0xFF4A4A4A));
    });
  });

  group('Conforto (nível 3)', () {
    test('usa a paleta do web', () {
      configure(contrast: ContrastLevel.conforto);

      expect(AppDesignTokens.colorBgLight, const Color(0xFFFAFAFA));
      expect(AppDesignTokens.colorBase, const Color(0xFF0D0D0D));
      expect(AppDesignTokens.colorPrimary, const Color(0xFF1A365D));
      expect(AppDesignTokens.colorBgDefault, const Color(0xFFF0F0F0));
      expect(AppDesignTokens.colorBorderDefault, const Color(0xFF767676));
      expect(AppDesignTokens.colorContentMuted, const Color(0xFF3D3D3D));
    });
  });

  group('Alto (nível 4)', () {
    test('usa a paleta do web', () {
      configure(contrast: ContrastLevel.alto);

      expect(AppDesignTokens.colorBgLight, const Color(0xFFFFFFFF));
      expect(AppDesignTokens.colorBase, const Color(0xFF000000));
      expect(AppDesignTokens.colorPrimary, const Color(0xFF004080));
      expect(AppDesignTokens.colorBorderDefault, const Color(0xFF333333));
      expect(AppDesignTokens.colorContentMuted, const Color(0xFF1A1A1A));
    });
  });

  group('Máximo (nível 5)', () {
    test('usa preto/branco absoluto do web', () {
      configure(contrast: ContrastLevel.maximo);

      expect(AppDesignTokens.colorBgLight, const Color(0xFF000000));
      expect(AppDesignTokens.colorBase, const Color(0xFFFFFFFF));
      expect(AppDesignTokens.colorPrimary, const Color(0xFFFFFFFF));
      expect(AppDesignTokens.colorBgDefault, const Color(0xFF1A1A1A));
      expect(AppDesignTokens.colorBorderDefault, const Color(0xFFFFFFFF));
      expect(AppDesignTokens.colorContentMuted, const Color(0xFFFFFFFF));
    });

    test('botão primary: fundo branco e texto preto (override web)', () {
      configure(contrast: ContrastLevel.maximo);

      expect(AppDesignTokens.buttonBrandBgDefault, const Color(0xFFFFFFFF));
      expect(AppDesignTokens.buttonBrandContentDefault, const Color(0xFF000000));
      expect(AppDesignTokens.buttonBrandBgPressed, const Color(0xFFE8E8E8));
    });
  });

  group('Escuro (nível 6)', () {
    test('usa tema escuro + azul do web', () {
      configure(contrast: ContrastLevel.escuro);

      expect(AppDesignTokens.colorBgLight, const Color(0xFF121212));
      expect(AppDesignTokens.colorBase, const Color(0xFFF5F5F5));
      expect(AppDesignTokens.colorPrimary, const Color(0xFF58A6FF));
      expect(AppDesignTokens.colorBgDefault, const Color(0xFF1E1E1E));
      expect(AppDesignTokens.colorBorderDefault, const Color(0xFF888888));
      expect(AppDesignTokens.colorContentMuted, const Color(0xFFD0D0D0));
    });

    test('botão primary usa accent azul com texto branco', () {
      configure(contrast: ContrastLevel.escuro);

      expect(AppDesignTokens.buttonBrandBgDefault, const Color(0xFF58A6FF));
      expect(AppDesignTokens.buttonBrandContentDefault, const Color(0xFFFFFFFF));
      expect(
        AppDesignTokens.buttonOutlinedBorderDefault,
        AppDesignTokens.colorPrimary,
      );
    });
  });

  group('feedback por nível', () {
    test('erro e sucesso seguem a paleta do web no Suave', () {
      configure(contrast: ContrastLevel.suave);

      expect(AppDesignTokens.colorErrorSurface, const Color(0xFFFDE8E8));
      expect(AppDesignTokens.colorErrorOnSurface, const Color(0xFF7F1D1D));
      expect(AppDesignTokens.colorFeedbackError, const Color(0xFF7F1D1D));
      expect(AppDesignTokens.colorSuccessSurface, const Color(0xFFEBE4D6));
      expect(AppDesignTokens.colorSuccessOnSurface, const Color(0xFF2C5282));
    });

    test('erro no Escuro usa a paleta vermelha do web', () {
      configure(contrast: ContrastLevel.escuro);

      expect(AppDesignTokens.colorErrorSurface, const Color(0xFF3B1212));
      expect(AppDesignTokens.colorErrorOnSurface, const Color(0xFFFECACA));
      expect(AppDesignTokens.colorFeedbackError, const Color(0xFFFECACA));
    });
  });

  group('font/spacing scaling', () {
    test('configure() scales font sizes proportionally', () {
      configure(fontScale: 1.0);
      expect(AppDesignTokens.fontSizeBody, 16.0);

      configure(fontScale: 1.3);
      expect(AppDesignTokens.fontSizeBody, closeTo(20.8, 0.001));
    });

    test('configure() scales spacing proportionally', () {
      configure(spacingScale: 1.0);
      expect(AppDesignTokens.spacingMd, 16.0);

      configure(spacingScale: 1.5);
      expect(AppDesignTokens.spacingMd, 24.0);
    });
  });
}
