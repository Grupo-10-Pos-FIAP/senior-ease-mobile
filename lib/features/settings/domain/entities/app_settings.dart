class AppSettings {
  const AppSettings({required this.fontSize, required this.highContrast});

  factory AppSettings.defaults() =>
      const AppSettings(fontSize: 'Normal', highContrast: false);

  final String fontSize;
  final bool highContrast;

  AppSettings copyWith({String? fontSize, bool? highContrast}) {
    return AppSettings(
      fontSize: fontSize ?? this.fontSize,
      highContrast: highContrast ?? this.highContrast,
    );
  }
}
