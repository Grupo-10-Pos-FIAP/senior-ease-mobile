import 'package:senior_ease/core/app_mode/contrast_level.dart';

class AppSettings {
  const AppSettings({
    required this.fontSize,
    required this.contrastLevel,
    required this.navigationMode,
    required this.spacing,
    required this.enhancedVisualFeedback,
    required this.criticalActionConfirmation,
  });

  factory AppSettings.defaults() => const AppSettings(
    fontSize: 'Normal',
    contrastLevel: 'Padrão',
    navigationMode: 'Avançado',
    spacing: 'Normal',
    enhancedVisualFeedback: false,
    criticalActionConfirmation: true,
  );

  // Single source of truth for the selectable labels — shared between the
  // Settings screen's option cards and the Firestore data source's
  // label <-> 1-based-index mapping (preferences are stored as ints there).
  static const List<String> fontSizeOptions = [
    'Pequena',
    'Reduzida',
    'Normal',
    'Grande',
    'Muito grande',
  ];

  static const List<String> contrastLevelOptions = [
    'Padrão',
    'Suave',
    'Conforto',
    'Alto',
    'Máximo',
    'Escuro',
  ];

  static const List<String> navigationModeOptions = ['Simples', 'Avançado'];

  static const List<String> spacingOptions = [
    'Compacto',
    'Reduzido',
    'Normal',
    'Amplo',
    'Muito amplo',
  ];

  final String fontSize;
  final String contrastLevel;
  final String navigationMode;
  final String spacing;
  final bool enhancedVisualFeedback;
  final bool criticalActionConfirmation;

  // Scales are centered on "Normal" == 1.0, symmetric around it, so the
  // reactive AppDesignTokens getters can just multiply the base values.
  static const List<double> _fontScales = [0.85, 0.925, 1.0, 1.15, 1.3];
  static const List<double> _spacingScales = [0.75, 0.875, 1.0, 1.25, 1.5];
  static const List<ContrastLevel> _contrastLevels = [
    ContrastLevel.padrao,
    ContrastLevel.suave,
    ContrastLevel.conforto,
    ContrastLevel.alto,
    ContrastLevel.maximo,
    ContrastLevel.escuro,
  ];

  double get fontScale => _scaleFor(fontSizeOptions, _fontScales, fontSize);

  double get spacingScale => _scaleFor(spacingOptions, _spacingScales, spacing);

  ContrastLevel get contrastLevelEnum {
    final index = contrastLevelOptions.indexOf(contrastLevel);
    return index == -1 ? ContrastLevel.padrao : _contrastLevels[index];
  }

  double _scaleFor(List<String> options, List<double> scales, String value) {
    final index = options.indexOf(value);
    return index == -1 ? 1.0 : scales[index];
  }

  AppSettings copyWith({
    String? fontSize,
    String? contrastLevel,
    String? navigationMode,
    String? spacing,
    bool? enhancedVisualFeedback,
    bool? criticalActionConfirmation,
  }) {
    return AppSettings(
      fontSize: fontSize ?? this.fontSize,
      contrastLevel: contrastLevel ?? this.contrastLevel,
      navigationMode: navigationMode ?? this.navigationMode,
      spacing: spacing ?? this.spacing,
      enhancedVisualFeedback:
          enhancedVisualFeedback ?? this.enhancedVisualFeedback,
      criticalActionConfirmation:
          criticalActionConfirmation ?? this.criticalActionConfirmation,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is AppSettings &&
        other.fontSize == fontSize &&
        other.contrastLevel == contrastLevel &&
        other.navigationMode == navigationMode &&
        other.spacing == spacing &&
        other.enhancedVisualFeedback == enhancedVisualFeedback &&
        other.criticalActionConfirmation == criticalActionConfirmation;
  }

  @override
  int get hashCode => Object.hash(
    fontSize,
    contrastLevel,
    navigationMode,
    spacing,
    enhancedVisualFeedback,
    criticalActionConfirmation,
  );
}
