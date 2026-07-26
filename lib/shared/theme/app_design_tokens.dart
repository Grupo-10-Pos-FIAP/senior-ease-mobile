import 'package:flutter/material.dart';
import 'package:senior_ease/core/app_mode/contrast_level.dart';

/// Paleta de contraste alinhada ao web (`accessibilityTokens.ts` / CONTRAST_PALETTES).
class _ContrastPalette {
  const _ContrastPalette({
    required this.bg,
    required this.fg,
    required this.accent,
    required this.muted,
    required this.border,
    required this.textMuted,
    required this.feedbackSuccessBg,
    required this.feedbackSuccessFg,
    required this.feedbackSuccessBorder,
    required this.feedbackErrorBg,
    required this.feedbackErrorFg,
    required this.feedbackErrorBorder,
  });

  final Color bg;
  final Color fg;
  final Color accent;
  final Color muted;
  final Color border;
  final Color textMuted;
  final Color feedbackSuccessBg;
  final Color feedbackSuccessFg;
  final Color feedbackSuccessBorder;
  final Color feedbackErrorBg;
  final Color feedbackErrorFg;
  final Color feedbackErrorBorder;
}

class AppDesignTokens {
  AppDesignTokens._();

  static double _fontScale = 1.0;
  static double _spacingScale = 1.0;
  static ContrastLevel _contrast = ContrastLevel.padrao;

  static void configure({
    required double fontScale,
    required double spacingScale,
    required ContrastLevel contrast,
  }) {
    _fontScale = fontScale;
    _spacingScale = spacingScale;
    _contrast = contrast;
  }

  /// Espelha `CONTRAST_PALETTES` do senior-ease-web.
  static const Map<ContrastLevel, _ContrastPalette> _palettes = {
    ContrastLevel.padrao: _ContrastPalette(
      bg: Color(0xFFFFFFFF),
      fg: Color(0xFF1A1A1A),
      accent: Color(0xFF1D2D50),
      muted: Color(0xFFF4F6F9),
      border: Color(0xFF949494),
      textMuted: Color(0xFF5A6478),
      feedbackSuccessBg: Color(0xFFF4F6F9),
      feedbackSuccessFg: Color(0xFF1D2D50),
      feedbackSuccessBorder: Color(0xFF949494),
      feedbackErrorBg: Color(0xFFFEF2F2),
      feedbackErrorFg: Color(0xFF7F1D1D),
      feedbackErrorBorder: Color(0xFFFECACA),
    ),
    ContrastLevel.suave: _ContrastPalette(
      bg: Color(0xFFF5F0E6),
      fg: Color(0xFF2B2B2B),
      accent: Color(0xFF2C5282),
      muted: Color(0xFFEBE4D6),
      border: Color(0xFF7A7268),
      textMuted: Color(0xFF4A4A4A),
      feedbackSuccessBg: Color(0xFFEBE4D6),
      feedbackSuccessFg: Color(0xFF2C5282),
      feedbackSuccessBorder: Color(0xFF7A7268),
      feedbackErrorBg: Color(0xFFFDE8E8),
      feedbackErrorFg: Color(0xFF7F1D1D),
      feedbackErrorBorder: Color(0xFFF5B8B8),
    ),
    ContrastLevel.conforto: _ContrastPalette(
      bg: Color(0xFFFAFAFA),
      fg: Color(0xFF0D0D0D),
      accent: Color(0xFF1A365D),
      muted: Color(0xFFF0F0F0),
      border: Color(0xFF767676),
      textMuted: Color(0xFF3D3D3D),
      feedbackSuccessBg: Color(0xFFF0F0F0),
      feedbackSuccessFg: Color(0xFF1A365D),
      feedbackSuccessBorder: Color(0xFF767676),
      feedbackErrorBg: Color(0xFFFEF2F2),
      feedbackErrorFg: Color(0xFF7F1D1D),
      feedbackErrorBorder: Color(0xFFFECACA),
    ),
    ContrastLevel.alto: _ContrastPalette(
      bg: Color(0xFFFFFFFF),
      fg: Color(0xFF000000),
      accent: Color(0xFF004080),
      muted: Color(0xFFF4F6F9),
      border: Color(0xFF333333),
      textMuted: Color(0xFF1A1A1A),
      feedbackSuccessBg: Color(0xFFF4F6F9),
      feedbackSuccessFg: Color(0xFF004080),
      feedbackSuccessBorder: Color(0xFF333333),
      feedbackErrorBg: Color(0xFFFEF2F2),
      feedbackErrorFg: Color(0xFF7F1D1D),
      feedbackErrorBorder: Color(0xFF333333),
    ),
    ContrastLevel.maximo: _ContrastPalette(
      bg: Color(0xFF000000),
      fg: Color(0xFFFFFFFF),
      accent: Color(0xFFFFFFFF),
      muted: Color(0xFF1A1A1A),
      border: Color(0xFFFFFFFF),
      textMuted: Color(0xFFFFFFFF),
      feedbackSuccessBg: Color(0xFF1A1A1A),
      feedbackSuccessFg: Color(0xFFFFFFFF),
      feedbackSuccessBorder: Color(0xFFFFFFFF),
      feedbackErrorBg: Color(0xFF000000),
      feedbackErrorFg: Color(0xFFFFFFFF),
      feedbackErrorBorder: Color(0xFFFFFFFF),
    ),
    ContrastLevel.escuro: _ContrastPalette(
      bg: Color(0xFF121212),
      fg: Color(0xFFF5F5F5),
      accent: Color(0xFF58A6FF),
      muted: Color(0xFF1E1E1E),
      border: Color(0xFF888888),
      textMuted: Color(0xFFD0D0D0),
      feedbackSuccessBg: Color(0xFF1E1E1E),
      feedbackSuccessFg: Color(0xFF58A6FF),
      feedbackSuccessBorder: Color(0xFF888888),
      feedbackErrorBg: Color(0xFF3B1212),
      feedbackErrorFg: Color(0xFFFECACA),
      feedbackErrorBorder: Color(0xFFF87171),
    ),
  };

  static _ContrastPalette get _palette => _palettes[_contrast]!;

  static double get fontSizeCaption => 12 * _fontScale;
  static double get fontSizeSmall => 14 * _fontScale;
  static double get fontSizeBody => 16 * _fontScale;
  static double get fontSizeSubtitle => 18 * _fontScale;
  static double get fontSizeTitle => 20 * _fontScale;
  static double get fontSizeH4 => 22 * _fontScale;
  static double get fontSizeH3 => 24 * _fontScale;
  static double get fontSizeH2 => 26 * _fontScale;
  static double get fontSizeH1 => 28 * _fontScale;
  static double get fontSizeH5 => 30 * _fontScale;

  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  static const double lineHeightCaption = 1.4;
  static const double lineHeightBody = 1.5;
  static const double lineHeightSubtitle = 1.4;
  static const double lineHeightTitle = 1.3;
  static const double lineHeightHeading = 1.2;
  static const double lineHeightTight = 1.25;
  static const double lineHeightSnug = 1.375;
  static const double lineHeightRelaxed = 1.625;
  static const double lineHeightLoose = 2;

  static double letterSpacingTightest(double fontSize) => fontSize * -0.015;
  static double letterSpacingTight(double fontSize) => fontSize * -0.005;
  static const double letterSpacingNormal = 0;
  static double letterSpacingRelaxed(double fontSize) => fontSize * 0.015;
  static double letterSpacingWide(double fontSize) => fontSize * 0.03;
  static double letterSpacingWider(double fontSize) => fontSize * 0.05;

  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorBlack = Color(0xFF000000);

  // Escala de cinza derivada da paleta ativa (web não expõe gray-* por nível).
  static Color get colorGray100 => _palette.muted;
  static Color get colorGray200 => _palette.border;
  static Color get colorGray300 =>
      Color.lerp(_palette.border, _palette.textMuted, 0.35)!;
  static Color get colorGray400 => _palette.textMuted;
  static Color get colorGray500 => _palette.textMuted;
  static Color get colorGray600 =>
      Color.lerp(_palette.textMuted, _palette.fg, 0.45)!;
  static Color get colorGray700 => _palette.fg;
  static Color get colorGray800 => _palette.fg;
  static Color get colorGray900 => _palette.fg;

  static Color get colorBase => _palette.fg;

  static Color get colorPrimary => _palette.accent;
  static Color get colorPrimarySurface => _palette.muted;
  static Color get colorErrorSurface => _palette.feedbackErrorBg;
  static Color get colorErrorOnSurface => _palette.feedbackErrorFg;
  // Derived from --se-warning-bg/-text/-border: color-mix(in srgb,
  // colorFeedbackWarning 22%/45%, transparent) and #6b4e0a.
  static const Color colorWarningSurface = Color(0x38C49A1A);
  static const Color colorWarningOnSurface = Color(0xFF6B4E0A);
  static const Color colorWarningBorder = Color(0x73C49A1A);
  static Color get colorSuccessSurface => _palette.feedbackSuccessBg;
  static Color get colorSuccessOnSurface => _palette.feedbackSuccessFg;
  static Color get colorSuccessBorder => _palette.feedbackSuccessBorder;
  static const Color colorSecondary = Color(0xFF42484E);
  static Color get colorSoft => _palette.muted;

  static Color get colorBgDefault => _palette.muted;
  static Color get colorBgDefaultDark => _palette.muted;
  static Color get colorBgLight => _palette.bg;
  static Color get colorBgPrimary => colorPrimary;
  static const Color colorBgSecondary = colorSecondary;
  static Color get colorBgDisabled => colorGray200;
  static const Color colorBgOverlay = Color(0xCCFFFFFF);
  static const Color colorBgFullscreen = Color(0xE6FFFFFF);
  static const Color colorBgAvatar = Color(0xFFEDF2FE);
  static const Color colorCardSelectedBackground = Color(0xFFE6E4FF);

  static Color get colorContentDefault => colorBase;
  static Color get colorContentPrimary => colorPrimary;

  static Color get colorContentSecondary => _palette.textMuted;
  static Color get colorContentInverse =>
      _contrast == ContrastLevel.maximo ? colorBlack : colorWhite;
  static Color get colorContentDisabled => colorGray500;
  static Color get colorContentMuted => _palette.textMuted;

  static Color get colorBorderDefault => _palette.border;
  static const Color colorBorderDisabled = Color(0x00FFFFFF);
  static Color get colorBorderFocused => colorPrimary;

  static Color get colorLink => colorPrimary;
  static Color get colorLinkVisited => buttonBrandBgPressed;

  static Color get colorFeedbackSuccess => _palette.feedbackSuccessFg;
  static const Color colorFeedbackWarning = Color(0xFFC49A1A);
  static Color get colorFeedbackError => _palette.feedbackErrorFg;
  static Color get colorFeedbackInfo => _palette.border;
  static const Color colorFeedbackAlert = Color(0xFFD32F2F);
  static const Color colorFeedbackFavorite = Colors.red;
  static Color get colorFeedbackMuted => colorGray100;

  static const Color colorBadgeScheduledBackground = Color(0xFFE8F5E9);
  static const Color colorBadgeScheduledForeground = Color(0xFF2E7D32);

  static double get spacingXs => 4 * _spacingScale;
  static double get spacingSm => 8 * _spacingScale;
  static double get spacingMd => 16 * _spacingScale;
  static double get spacingLg => 24 * _spacingScale;
  static double get spacingXl => 32 * _spacingScale;
  static double get spacing2xl => 48 * _spacingScale;
  static double get spacing3xl => 64 * _spacingScale;

  static double get borderRadiusDefault => spacingSm;
  static const double borderWidthDefault = 1;
  static const double borderWidthSmall = 2;
  static const double borderWidthMedium = 3;
  static double get borderWidthLarge => spacingXs;

  static const double breakpointMobile = 480;
  static const double breakpointDetailModalActions = 425;
  static const double breakpointTablet = 768;
  static const double breakpointDesktop = 1024;
  static const double breakpointWidescreen = 1200;

  static const int zIndexDropdown = 1000;
  static const int zIndexSticky = 1020;
  static const int zIndexFixed = 1030;
  static const int zIndexModalBackdrop = 1040;
  static const int zIndexModal = 1050;
  static const int zIndexPopover = 1060;
  static const int zIndexTooltip = 1070;
  static const int zIndexLoading = 9999;

  static Color get buttonBrandBgDefault => _palette.accent;
  // Web: --se-navy-dark (#152340); nível 5 (Máximo) usa hover #e8e8e8.
  static Color get buttonBrandBgPressed => _contrast == ContrastLevel.maximo
      ? const Color(0xFFE8E8E8)
      : const Color(0xFF152340);
  static Color get buttonBrandBgDisabled => colorPrimarySurface;
  static Color get buttonBrandContentDefault => colorContentInverse;
  static Color get buttonBrandContentDisabled => colorContentDisabled;

  static const Color buttonSecondaryBgDefault = Color(0xFF658864);
  static const Color buttonSecondaryBgPressed = Color(0xFF2C4D2B);
  static const Color buttonSecondaryBgDisabled = Color(0xFFD6EED6);
  static const Color buttonSecondaryContentDefault = colorWhite;
  static const Color buttonSecondaryContentDisabled = colorWhite;

  static const Color buttonOutlinedBgDefault = Colors.transparent;
  static const Color buttonOutlinedBgPressed = Color(0xFF3A3C3C);
  static const Color buttonOutlinedBgDisabled = Colors.transparent;
  static Color get buttonOutlinedBorderDefault => colorPrimary;
  static const Color buttonOutlinedBorderDisabled = Color(0x1A1A1A1A);
  static Color get buttonOutlinedContentDefault => colorPrimary;
  static const Color buttonOutlinedContentPressed = colorWhite;
  static const Color buttonOutlinedContentDisabled = Color(0xFFC2C2C2);

  static const Color buttonNegativeBgDefault = Colors.transparent;
  static const Color buttonNegativeBgPressed = colorBlack;
  static const Color buttonNegativeBgDisabled = Colors.transparent;
  static const Color buttonNegativeBorderDefault = colorWhite;
  static Color get buttonNegativeBorderPressed => colorBase;
  static const Color buttonNegativeBorderDisabled = colorWhite;
  static const Color buttonNegativeContentDefault = colorWhite;
  static const Color buttonNegativeContentDisabled = colorWhite;

  static const Color listItemContentActived = Color(0xFF2563EB);
}
