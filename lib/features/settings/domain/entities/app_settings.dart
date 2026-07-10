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
    navigationMode: 'Básico',
    spacing: 'Normal',
    enhancedVisualFeedback: false,
    criticalActionConfirmation: true,
  );

  final String fontSize;
  final String contrastLevel;
  final String navigationMode;
  final String spacing;
  final bool enhancedVisualFeedback;
  final bool criticalActionConfirmation;

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
