import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_amount.freezed.dart';

/// Digits, at most one separator, nothing else. Rejects a leading sign, grouping
/// separators, hex literals and exponent notation — an amount field is not a
/// calculator.
final _amountPattern = RegExp(r'^\d*\.?\d*$');

/// An exact quantity of one token: [raw] smallest units scaled by [decimals].
///
/// Overview §4.1: `double` is IEEE-754 and 1 ETH = 10^18 wei exceeds its 53-bit
/// mantissa. There is no `toDouble()` on this type and no code path in this file
/// constructs one — every conversion goes `BigInt -> Decimal -> String`.
///
/// [decimals] travels with the value and is never assumed. USDC is 6 decimals on
/// Base but USDT is 18 on BNB Chain, so the same symbol cannot share a scale.
@freezed
abstract class TokenAmount with _$TokenAmount {
  const factory TokenAmount({
    required BigInt raw,
    required int decimals,
  }) = _TokenAmount;

  const TokenAmount._();

  factory TokenAmount.zero(int decimals) =>
      TokenAmount(raw: BigInt.zero, decimals: decimals);

  /// Parses an RPC balance. Hex goes straight to [BigInt] — `int.parse` would
  /// overflow above 2^63, which a large-supply token reaches easily.
  factory TokenAmount.fromHex(String hex, {required int decimals}) {
    final digits = hex.startsWith('0x') || hex.startsWith('0X')
        ? hex.substring(2)
        : hex;
    if (digits.isEmpty) return TokenAmount.zero(decimals);
    return TokenAmount(raw: BigInt.parse(digits, radix: 16), decimals: decimals);
  }

  /// Parses a user-typed decimal string, throwing on anything invalid.
  factory TokenAmount.parse(
    String input, {
    required int decimals,
    bool allowPrecisionLoss = false,
  }) {
    final amount = TokenAmount.tryParse(
      input,
      decimals: decimals,
      allowPrecisionLoss: allowPrecisionLoss,
    );
    if (amount == null) throw FormatException('Not a valid amount', input);
    return amount;
  }

  /// Null instead of throwing — the shape a `TextField` validator wants.
  ///
  /// Never touches `double`: the string is split on the separator, the fraction
  /// is right-padded to [decimals], and the halves are concatenated into one
  /// integer literal.
  ///
  /// Strict by default. More fraction digits than the token has throws rather
  /// than truncating: silently dropping the tail of an amount the user typed is
  /// a loss they never see. A "max" button re-rendering its own value is the
  /// case [allowPrecisionLoss] exists for.
  static TokenAmount? tryParse(
    String input, {
    required int decimals,
    bool allowPrecisionLoss = false,
  }) {
    if (decimals < 0) return null;

    final trimmed = input.trim();
    if (trimmed.isEmpty) return TokenAmount.zero(decimals);

    // A comma is a decimal separator in most of the world. Accepting it here
    // costs nothing; the pattern below still rejects grouping.
    final normalised = trimmed.replaceAll(',', '.');
    if (!_amountPattern.hasMatch(normalised)) return null;

    final dot = normalised.indexOf('.');
    var whole = dot < 0 ? normalised : normalised.substring(0, dot);
    var fraction = dot < 0 ? '' : normalised.substring(dot + 1);

    if (whole.isEmpty && fraction.isEmpty) return TokenAmount.zero(decimals);
    if (whole.isEmpty) whole = '0';

    if (fraction.length > decimals) {
      if (!allowPrecisionLoss) return null;
      fraction = fraction.substring(0, decimals);
    }
    fraction = fraction.padRight(decimals, '0');

    return TokenAmount(raw: BigInt.parse('$whole$fraction'), decimals: decimals);
  }

  /// Exact: shifting the decimal point is not a division, so nothing rounds.
  Decimal get decimal => Decimal.fromBigInt(raw).shift(-decimals);

  bool get isZero => raw == BigInt.zero;
  bool get isNegative => raw.isNegative;

  /// Fiat value of this holding. Returns [Decimal] so the caller keeps exact
  /// arithmetic through the portfolio sum and only rounds at render time.
  Decimal fiatValue(Decimal unitPrice) => decimal * unitPrice;

  /// Display string. [maxFractionDigits] caps visible precision only — [raw] is
  /// untouched. Trailing zeros are dropped, so `1.500000` renders as `1.5`.
  String format({int maxFractionDigits = 6}) =>
      decimal.round(scale: maxFractionDigits).toString();

  /// [format], except a non-zero balance that rounds to all zeroes renders as
  /// `< 0.000001`. Showing `0` for real funds is the worst display bug this
  /// layer can have.
  String formatOrDust({int maxFractionDigits = 6}) {
    if (isZero) return '0';

    final text = format(maxFractionDigits: maxFractionDigits);
    if (Decimal.parse(text) != Decimal.zero) return text;

    final epsilon = Decimal.one.shift(-maxFractionDigits);
    return isNegative ? '> -$epsilon' : '< $epsilon';
  }

  /// Both operands must share [decimals]; mixing scales is a programming error,
  /// not a runtime condition to recover from.
  TokenAmount operator +(TokenAmount other) {
    assert(other.decimals == decimals, 'decimals mismatch');
    return copyWith(raw: raw + other.raw);
  }

  TokenAmount operator -(TokenAmount other) {
    assert(other.decimals == decimals, 'decimals mismatch');
    return copyWith(raw: raw - other.raw);
  }
}
