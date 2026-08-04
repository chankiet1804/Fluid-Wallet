import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'fiat.freezed.dart';

/// A unit price for one token, in one currency.
///
/// [asOf] travels with the value so the UI can grey out a stale quote rather
/// than present a ten-minute-old number as live.
@freezed
abstract class FiatPrice with _$FiatPrice {
  const factory FiatPrice({
    /// ISO 4217, upper case. Only `USD` is produced today.
    required String currency,
    required Decimal value,
    required DateTime asOf,

    /// Fraction, not percent: `0.0512` is +5.12%.
    Decimal? change24h,
  }) = _FiatPrice;
}

/// An amount of money. Deliberately a different type from [FiatPrice] so a
/// price can never be summed into a portfolio total by accident.
@freezed
abstract class FiatValue with _$FiatValue {
  const factory FiatValue({
    required String currency,
    required Decimal value,
  }) = _FiatValue;

  const FiatValue._();

  factory FiatValue.zero(String currency) =>
      FiatValue(currency: currency, value: Decimal.zero);

  bool get isZero => value == Decimal.zero;

  FiatValue operator +(FiatValue other) {
    assert(other.currency == currency, 'currency mismatch');
    return copyWith(value: value + other.value);
  }
}
