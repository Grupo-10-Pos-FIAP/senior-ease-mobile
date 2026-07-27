import 'package:flutter_test/flutter_test.dart';
import 'package:senior_ease/core/registration_code.dart';

void main() {
  test('matches the "SE" + 5-digit format', () {
    final code = generateRegistrationCode();

    expect(code, matches(RegExp(r'^SE\d{5}$')));
  });

  test('varies across calls', () {
    final codes = List.generate(20, (_) => generateRegistrationCode());

    expect(codes.toSet().length, greaterThan(1));
  });
}
