import 'package:flutter_test/flutter_test.dart';
import 'package:senior_ease/core/registration/registration_id.dart';

void main() {
  group('registrationId', () {
    test('formata sequência numérica como SE + 5 dígitos', () {
      expect(formatRegistrationId(1), 'SE00001');
      expect(formatRegistrationId(42), 'SE00042');
      expect(formatRegistrationId(99999), 'SE99999');
    });

    test('rejeita sequência fora do intervalo', () {
      expect(() => formatRegistrationId(0), throwsArgumentError);
      expect(() => formatRegistrationId(100000), throwsArgumentError);
    });

    test('reconhece matrícula amigável', () {
      expect(isFriendlyRegistrationId('SE12345'), isTrue);
      expect(isFriendlyRegistrationId('se00001'), isTrue);
      expect(isFriendlyRegistrationId('SE999'), isFalse);
      expect(isFriendlyRegistrationId('-'), isFalse);
    });

    test('normaliza matrícula SE + 5 dígitos e descarta valores inválidos', () {
      expect(normalizeRegistrationId('SE12345'), 'SE12345');
      expect(normalizeRegistrationId('se00001'), 'SE00001');
      expect(normalizeRegistrationId(null), '');
      expect(normalizeRegistrationId('-'), '');
      expect(normalizeRegistrationId('SE999'), '');
      expect(
        normalizeRegistrationId('q8uxtuQAjNUOzXGYM2uJ9iXYW6P2'),
        '',
      );
    });
  });
}
