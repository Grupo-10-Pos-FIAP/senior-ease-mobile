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

  group('Padrão', () {
    test('leaves every adjustable color untouched', () {
      configure();

      expect(AppDesignTokens.colorGray100, const Color(0xFFF8F9FA));
      expect(AppDesignTokens.colorBase, const Color(0xFF1A1A1A));
      expect(AppDesignTokens.colorPrimary, const Color(0xFF1F2D5C));
      expect(
        AppDesignTokens.buttonOutlinedBorderDefault,
        const Color(0x331A1A1A),
      );
    });
  });

  group('Escuro', () {
    test(
      'inverts lightness, turning light backgrounds dark and vice versa',
      () {
        configure(contrast: ContrastLevel.escuro);

        final bg = HSLColor.fromColor(AppDesignTokens.colorGray100);
        final fg = HSLColor.fromColor(AppDesignTokens.colorBase);

        expect(bg.lightness, lessThan(0.5));
        expect(fg.lightness, greaterThan(0.5));
      },
    );

    test('swaps colorPrimary and buttonOutlinedBorderDefault to white', () {
      configure(contrast: ContrastLevel.escuro);

      expect(AppDesignTokens.colorPrimary, AppDesignTokens.colorWhite);
      expect(
        AppDesignTokens.buttonOutlinedBorderDefault,
        AppDesignTokens.colorWhite,
      );
    });

    test('still runs colorPrimarySurface through the same inversion', () {
      configure();
      final beforeLightness = HSLColor.fromColor(
        AppDesignTokens.colorPrimarySurface,
      ).lightness;

      configure(contrast: ContrastLevel.escuro);
      final afterLightness = HSLColor.fromColor(
        AppDesignTokens.colorPrimarySurface,
      ).lightness;

      expect(afterLightness, lessThan(beforeLightness));
    });
  });

  group('Suave / Conforto / Alto', () {
    test('colorPrimary and its border stay the fixed navy (never swap)', () {
      for (final level in [
        ContrastLevel.suave,
        ContrastLevel.conforto,
        ContrastLevel.alto,
      ]) {
        configure(contrast: level);

        expect(AppDesignTokens.colorPrimary, const Color(0xFF1F2D5C));
        expect(
          AppDesignTokens.buttonOutlinedBorderDefault,
          const Color(0x331A1A1A),
        );
      }
    });

    test('a true background gets progressively (but gently) darker', () {
      configure(contrast: ContrastLevel.suave);
      final suave = HSLColor.fromColor(AppDesignTokens.colorGray100).lightness;
      configure(contrast: ContrastLevel.conforto);
      final conforto = HSLColor.fromColor(
        AppDesignTokens.colorGray100,
      ).lightness;
      configure(contrast: ContrastLevel.alto);
      final alto = HSLColor.fromColor(AppDesignTokens.colorGray100).lightness;

      expect(suave, lessThan(0.976)); // original _gray100 lightness
      expect(conforto, lessThan(suave));
      expect(alto, lessThan(conforto));
      // Still meant to read as a light page, not a dark one.
      expect(alto, greaterThan(0.5));
    });

    test('a structural/foreground color darkens more aggressively', () {
      configure(contrast: ContrastLevel.suave);
      final suave = HSLColor.fromColor(AppDesignTokens.colorGray500).lightness;
      configure(contrast: ContrastLevel.conforto);
      final conforto = HSLColor.fromColor(
        AppDesignTokens.colorGray500,
      ).lightness;
      configure(contrast: ContrastLevel.alto);
      final alto = HSLColor.fromColor(AppDesignTokens.colorGray500).lightness;

      expect(suave, lessThan(0.5)); // original _gray500 lightness
      expect(conforto, lessThan(suave));
      expect(alto, lessThan(conforto));
    });
  });

  group('Máximo', () {
    test('snaps a dark structural color to pure black', () {
      configure(contrast: ContrastLevel.maximo);

      expect(AppDesignTokens.colorGray900, Colors.black);
      expect(AppDesignTokens.colorGray700, Colors.black);
    });

    test('snaps a light-but-not-background structural color to pure white', () {
      configure(contrast: ContrastLevel.maximo);

      // _gray300 (0xFFC0C0C0) has lightness ~0.75 — light, but well below the
      // ≥90% threshold that marks an actual page background.
      expect(AppDesignTokens.colorGray300, Colors.white);
    });

    test(
      'a true background visibly shifts tone instead of snapping to white',
      () {
        configure(contrast: ContrastLevel.maximo);
        final maximo = HSLColor.fromColor(
          AppDesignTokens.colorGray100,
        ).lightness;
        configure(contrast: ContrastLevel.alto);
        final alto = HSLColor.fromColor(AppDesignTokens.colorGray100).lightness;

        // This is the exact regression this covers: Máximo used to map any
        // already-light background straight to white (i.e. no visible change
        // at all). It must now be strictly darker than Alto's own shift, and
        // clearly not pure white.
        expect(AppDesignTokens.colorGray100, isNot(Colors.white));
        expect(maximo, lessThan(alto));
      },
    );

    test('colorPrimary is not affected — only Escuro swaps it', () {
      configure(contrast: ContrastLevel.maximo);

      expect(AppDesignTokens.colorPrimary, const Color(0xFF1F2D5C));
    });
  });

  test(
    'buttonBrandBgDefault never changes with contrast — it is a constant',
    () {
      for (final level in ContrastLevel.values) {
        configure(contrast: level);
        expect(AppDesignTokens.buttonBrandBgDefault, const Color(0xFF1F2D5C));
      }
    },
  );

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
