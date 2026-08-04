import 'package:decimal/decimal.dart';

/// Fiat display.
///
/// Takes [Decimal] and nothing else — there is deliberately no `num` overload,
/// so a `double` cannot reach this function by accident.
abstract final class FiatFormat {
  /// Symbols for the currencies the app can actually display. An unknown code
  /// falls back to `CODE 1,234.56`, which is unambiguous rather than pretty.
  static const _symbols = <String, String>{
    'USD': r'$',
    'EUR': '€',
    'GBP': '£',
    'JPY': '¥',
    'VND': '₫',
  };

  /// `$1,234.56`. Always two fraction digits: money that renders as `$1,234.5`
  /// reads as a typo.
  static String format(Decimal value, {String currency = 'USD'}) {
    final rounded = value.round(scale: 2);
    final negative = rounded < Decimal.zero;
    final digits = rounded.abs().toStringAsFixed(2);

    final dot = digits.indexOf('.');
    final grouped =
        '${_group(digits.substring(0, dot))}${digits.substring(dot)}';

    final symbol = _symbols[currency];
    final body = symbol == null ? '$currency $grouped' : '$symbol$grouped';
    return negative ? '-$body' : body;
  }

  /// [format], except a non-zero value that rounds away renders as `< $0.01`.
  /// Same reasoning as `TokenAmount.formatOrDust`: a holding worth something
  /// must not read as worth nothing.
  static String formatOrDust(Decimal value, {String currency = 'USD'}) {
    if (value == Decimal.zero) return format(value, currency: currency);

    final rounded = value.round(scale: 2);
    if (rounded != Decimal.zero) return format(value, currency: currency);

    final epsilon = format(Decimal.parse('0.01'), currency: currency);
    return value < Decimal.zero ? '> -$epsilon' : '< $epsilon';
  }

  /// Thousands separators, inserted right to left.
  static String _group(String whole) {
    final buffer = StringBuffer();
    for (var i = 0; i < whole.length; i++) {
      if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
      buffer.write(whole[i]);
    }
    return buffer.toString();
  }
}
