/// Prefixo amigável das matrículas SeniorEase (ex.: SE00001).
const registrationIdPrefix = 'SE';
const registrationIdDigits = 5;
const registrationIdMax = 99999;

/// Documento Firestore do contador sequencial de matrículas.
const registrationCounterCollection = 'counters';
const registrationCounterDoc = 'matriculas';

final _friendlyPattern = RegExp(
  '^$registrationIdPrefix\\d{$registrationIdDigits}\$',
  caseSensitive: false,
);

bool isFriendlyRegistrationId(String value) {
  return _friendlyPattern.hasMatch(value.trim());
}

/// Formata o número sequencial do contador Firestore em matrícula amigável.
/// Ex.: 1 → "SE00001"
String formatRegistrationId(int sequence) {
  if (sequence < 1 || sequence > registrationIdMax) {
    throw ArgumentError(
      'Número de matrícula fora do intervalo permitido '
      '(1–$registrationIdMax): $sequence',
    );
  }

  return '$registrationIdPrefix'
      '${sequence.toString().padLeft(registrationIdDigits, '0')}';
}

/// Normaliza matrícula persistida na leitura.
/// Mantém apenas o formato SE + 5 dígitos; valores inválidos/legados viram "".
String normalizeRegistrationId(Object? value) {
  if (value is String && isFriendlyRegistrationId(value)) {
    return value.trim().toUpperCase();
  }
  return '';
}
