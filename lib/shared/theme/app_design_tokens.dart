import 'package:flutter/material.dart';
import 'package:senior_ease/core/app_mode/contrast_level.dart';

class AppDesignTokens {
  AppDesignTokens._();

  static double _fontScale = 1.0;
  static double _spacingScale = 1.0;
  static ContrastLevel _contrast = ContrastLevel.padrao;

  /// Called from the app root whenever AppModeController's derived
  /// personalization state changes, so every widget rebuilt after this
  /// point reads the updated scale/contrast through the getters below.
  static void configure({
    required double fontScale,
    required double spacingScale,
    required ContrastLevel contrast,
  }) {
    _fontScale = fontScale;
    _spacingScale = spacingScale;
    _contrast = contrast;
  }

  // ---- Font sizes (scaled by the "Tamanho da letra" setting) ----
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

  // ---- Colors ----
  // Brand/status colors stay fixed — "Nível de contraste" is about
  // background/text/border legibility, not brand identity. The semantic
  // tokens below (grays, backgrounds, content, borders) run through
  // `_adjust`, which pushes each color toward its nearest extreme
  // (white for light/background-leaning colors, black for dark/text-leaning
  // ones) by an increasing factor per level, and inverts lightness entirely
  // for "Escuro".
  static const Color colorWhite = Color(0xFFFFFFFF);
  static const Color colorBlack = Color(0xFF000000);

  static const Color _gray100 = Color(0xFFF8F9FA);
  static const Color _gray200 = Color(0xFFE0E0E0);
  static const Color _gray300 = Color(0xFFC0C0C0);
  static const Color _gray400 = Color(0xFFA0A0A0);
  static const Color _gray500 = Color(0xFF808080);
  static const Color _gray600 = Color(0xFF606060);
  static const Color _gray700 = Color(0xFF404040);
  static const Color _gray800 = Color(0xFF202020);
  static const Color _gray900 = Color(0xFF101010);

  static Color get colorGray100 => _adjust(_gray100);
  static Color get colorGray200 => _adjust(_gray200);
  static Color get colorGray300 => _adjust(_gray300);
  static Color get colorGray400 => _adjust(_gray400);
  static Color get colorGray500 => _adjust(_gray500);
  static Color get colorGray600 => _adjust(_gray600);
  static Color get colorGray700 => _adjust(_gray700);
  static Color get colorGray800 => _adjust(_gray800);
  static Color get colorGray900 => _adjust(_gray900);

  static const Color _base = Color(0xFF1A1A1A);
  static Color get colorBase => _adjust(_base);

  static const Color colorPrimary = Color(0xFF1F2D5C);
  static const Color colorPrimarySurface = Color(0xFFE6E4FF);
  static const Color colorErrorSurface = Color(0xFFFBE6E4);
  static const Color colorErrorOnSurface = Color(0xFF5C271F);
  static const Color colorSecondary = Color(0xFF42484E);
  static Color get colorNeutral => colorGray300;
  static const Color colorSoft = Color(0xFFE1F0FB);

  static const Color _bgDefault = Color(0xFFF5F5F5);
  static const Color _bgDefaultDark = Color(0xFF374151);
  static Color get colorBgDefault => _adjust(_bgDefault);
  static Color get colorBgDefaultDark => _adjust(_bgDefaultDark);
  static Color get colorBgLight => _adjust(colorWhite);
  static const Color colorBgPrimary = colorPrimary;
  static const Color colorBgSecondary = colorSecondary;
  static Color get colorBgDisabled => colorGray200;
  static const Color colorBgOverlay = Color(0xCCFFFFFF);
  static const Color colorBgFullscreen = Color(0xE6FFFFFF);
  static const Color colorBgAvatar = Color(0xFFEDF2FE);

  static Color get colorContentDefault => colorBase;
  static const Color colorContentPrimary = colorPrimary;
  static const Color _contentSecondary = Color(0xFF42484E);
  static Color get colorContentSecondary => _adjust(_contentSecondary);
  static const Color colorContentInverse = colorWhite;
  static Color get colorContentDisabled => colorGray500;
  static const Color _contentMuted = Color(0xFF555555);
  static Color get colorContentMuted => _adjust(_contentMuted);

  static Color get colorBorderDefault => colorNeutral;
  static const Color colorBorderDisabled = Color(0x00FFFFFF);
  static const Color colorBorderFocused = colorPrimary;

  static const Color colorLink = colorPrimary;
  static const Color colorLinkVisited = buttonBrandBgPressed;

  static const Color colorFeedbackSuccess = Color(0xFF81BE7F);
  static const Color colorFeedbackWarning = Color(0xFFDEBB51);
  static const Color colorFeedbackError = Color(0xFFE53935);
  static const Color colorFeedbackInfo = Color(0xFF1C6EA4);
  static const Color colorFeedbackAlert = Color(0xFFD32F2F);
  static const Color colorFeedbackFavorite = Colors.red;
  static Color get colorFeedbackMuted => colorGray100;

  /// Badge “Agendada” no extrato (lavanda — distinto de Pendente/azul e Completa/verde).
  static const Color colorBadgeScheduledBackground = Color(0xFFEDE7F6);
  static const Color colorBadgeScheduledForeground = Color(0xFF5E35B1);

  static Color _adjust(Color base) {
    if (_contrast == ContrastLevel.padrao) return base;
    final hsl = HSLColor.fromColor(base);
    if (_contrast == ContrastLevel.escuro) {
      return hsl.withLightness((1 - hsl.lightness).clamp(0.0, 1.0)).toColor();
    }
    final isLight = hsl.lightness >= 0.5;
    if (_contrast == ContrastLevel.maximo) {
      return isLight ? Colors.white : Colors.black;
    }
    final factor = switch (_contrast) {
      ContrastLevel.suave => 0.10,
      ContrastLevel.conforto => 0.20,
      ContrastLevel.alto => 0.40,
      ContrastLevel.padrao || ContrastLevel.maximo || ContrastLevel.escuro =>
        0.0,
    };
    final target = isLight ? 1.0 : 0.0;
    final nextLightness = hsl.lightness + (target - hsl.lightness) * factor;
    return hsl.withLightness(nextLightness.clamp(0.0, 1.0)).toColor();
  }

  // ---- Spacing (scaled by the "Espaçamento entre elementos" setting) ----
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

  static const Color buttonBrandBgDefault = colorPrimary;
  static const Color buttonBrandBgPressed = Color(0xFF141D3D);
  static const Color buttonBrandBgDisabled = colorPrimarySurface;
  static const Color buttonBrandContentDefault = colorWhite;
  static Color get buttonBrandContentDisabled => colorContentDisabled;

  static const Color buttonSecondaryBgDefault = Color(0xFF658864);
  static const Color buttonSecondaryBgPressed = Color(0xFF2C4D2B);
  static const Color buttonSecondaryBgDisabled = Color(0xFFD6EED6);
  static const Color buttonSecondaryContentDefault = colorWhite;
  static const Color buttonSecondaryContentDisabled = colorWhite;

  static const Color buttonOutlinedBgDefault = Colors.transparent;
  static const Color buttonOutlinedBgPressed = Color(0xFF3A3C3C);
  static const Color buttonOutlinedBgDisabled = Colors.transparent;
  static const Color buttonOutlinedBorderDefault = Color(0x331A1A1A);
  static const Color buttonOutlinedBorderDisabled = Color(0x1A1A1A1A);
  static const Color buttonOutlinedContentDefault = colorPrimary;
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
