String formatPhoneMask(String value) {
  final digits = value.replaceAll(RegExp(r'\D'), '');
  final limited = digits.length > 11 ? digits.substring(0, 11) : digits;

  if (limited.isEmpty) return '';
  if (limited.length <= 2) return '($limited';
  if (limited.length <= 6) {
    return '(${limited.substring(0, 2)}) ${limited.substring(2)}';
  }
  if (limited.length <= 10) {
    return '(${limited.substring(0, 2)}) ${limited.substring(2, 6)}-'
        '${limited.substring(6)}';
  }
  return '(${limited.substring(0, 2)}) ${limited.substring(2, 7)}-'
      '${limited.substring(7)}';
}
