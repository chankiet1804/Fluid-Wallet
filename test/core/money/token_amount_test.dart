import 'package:decimal/decimal.dart';
import 'package:fluid_wallet/core/money/money.dart';
import 'package:flutter_test/flutter_test.dart';

/// The money-loss surface. Every case here is one the plan overview names in
/// §4.1 or its Phase 0 deferral table.
void main() {
  group('TokenAmount.decimal', () {
    test('zero', () {
      expect(TokenAmount.zero(18).decimal, Decimal.zero);
      expect(TokenAmount.zero(6).isZero, isTrue);
    });

    test('1 wei survives 18 decimals', () {
      final wei = TokenAmount(raw: BigInt.one, decimals: 18);
      expect(wei.decimal.toString(), '0.000000000000000001');
    });

    test('max uint256 round-trips without loss', () {
      final max = (BigInt.one << 256) - BigInt.one;
      final amount = TokenAmount(raw: max, decimals: 18);
      expect(amount.raw, max);
      // Reconstructing the integer from the decimal must give back every digit.
      expect((amount.decimal * Decimal.ten.pow(18).toDecimal()).toBigInt(), max);
    });

    test('a 6-decimal token is not scaled like an 18-decimal one', () {
      // 1.5 USDC is 1_500_000 units, not 1.5e18. Getting this wrong is the
      // classic 10^12 error.
      final usdc = TokenAmount.parse('1.5', decimals: 6);
      expect(usdc.raw, BigInt.from(1500000));
      expect(usdc.decimal.toString(), '1.5');

      expect(
        TokenAmount(raw: BigInt.from(1000000), decimals: 6).decimal.toString(),
        '1',
      );
    });
  });

  group('TokenAmount.tryParse', () {
    test('accepts plain and comma decimal separators', () {
      expect(TokenAmount.tryParse('1.5', decimals: 6)!.raw, BigInt.from(1500000));
      expect(TokenAmount.tryParse('1,5', decimals: 6)!.raw, BigInt.from(1500000));
      expect(TokenAmount.tryParse('.5', decimals: 6)!.raw, BigInt.from(500000));
      expect(TokenAmount.tryParse('7', decimals: 0)!.raw, BigInt.from(7));
    });

    test('empty-ish input is zero, not an error', () {
      expect(TokenAmount.tryParse('', decimals: 18)!.isZero, isTrue);
      expect(TokenAmount.tryParse('  ', decimals: 18)!.isZero, isTrue);
      expect(TokenAmount.tryParse('.', decimals: 18)!.isZero, isTrue);
    });

    test('rejects anything that is not a plain positive decimal', () {
      for (final bad in ['-1', '1.2.3', '0x10', '1e18', '1 000', '1,234.5']) {
        expect(
          TokenAmount.tryParse(bad, decimals: 18),
          isNull,
          reason: '"$bad" must not parse',
        );
      }
    });

    test('excess precision throws rather than truncating silently', () {
      // Dropping the tail of an amount the user typed is a loss they never see.
      expect(TokenAmount.tryParse('1.0000001', decimals: 6), isNull);
      expect(
        () => TokenAmount.parse('1.0000001', decimals: 6),
        throwsFormatException,
      );
      expect(
        TokenAmount.parse(
          '1.0000001',
          decimals: 6,
          allowPrecisionLoss: true,
        ).raw,
        BigInt.from(1000000),
      );
    });
  });

  group('formatting', () {
    test('formatOrDust never renders real funds as 0', () {
      final wei = TokenAmount(raw: BigInt.one, decimals: 18);
      expect(wei.format(), '0');
      expect(wei.formatOrDust(), '< 0.000001');
    });

    test('a true zero stays 0', () {
      expect(TokenAmount.zero(18).formatOrDust(), '0');
    });

    test('trailing zeros are dropped', () {
      expect(TokenAmount.parse('1.500000', decimals: 6).format(), '1.5');
    });
  });

  group('fromHex', () {
    test('parses beyond 2^63 exactly', () {
      // int.parse would overflow here; BigInt must not.
      const hex = '0xFFFFFFFFFFFFFFFFFF';
      expect(
        TokenAmount.fromHex(hex, decimals: 18).raw,
        BigInt.parse('FFFFFFFFFFFFFFFFFF', radix: 16),
      );
    });

    test('empty and 0x0 are zero', () {
      expect(TokenAmount.fromHex('0x', decimals: 18).isZero, isTrue);
      expect(TokenAmount.fromHex('0x0', decimals: 18).isZero, isTrue);
    });
  });

  group('arithmetic', () {
    test('adds within one scale', () {
      final a = TokenAmount.parse('1.5', decimals: 6);
      final b = TokenAmount.parse('0.25', decimals: 6);
      expect((a + b).decimal.toString(), '1.75');
    });

    test('mixing scales trips the assert', () {
      final six = TokenAmount.parse('1', decimals: 6);
      final eighteen = TokenAmount.parse('1', decimals: 18);
      expect(() => six + eighteen, throwsA(isA<AssertionError>()));
    });
  });

  group('fiat', () {
    test('value is exact, not floating point', () {
      final usdc = TokenAmount.parse('1234.56', decimals: 6);
      final price = Decimal.parse('0.9998');
      expect(usdc.fiatValue(price).toString(), '1234.313088');
    });

    test('FiatFormat groups and never shows a dust holding as nothing', () {
      expect(FiatFormat.format(Decimal.parse('1234.5')), r'$1,234.50');
      expect(FiatFormat.format(Decimal.parse('0')), r'$0.00');
      expect(FiatFormat.formatOrDust(Decimal.parse('0.001')), r'< $0.01');
      expect(FiatFormat.formatOrDust(Decimal.parse('0')), r'$0.00');
    });
  });
}
