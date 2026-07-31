import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_wallet/shared/widgets/wallet_avatar.dart';

void main() {
  const address = '0xd8DA6BF26964aF9D7eEd9e03E53415D37aA96045';
  const other = '0xd8DA6BF26964aF9D7eEd9e03E53415D37aA96044';

  group('Blockies', () {
    test('is deterministic for the same address', () {
      final a = Blockies.of(address);
      final b = Blockies.of(address);

      expect(a.cells, b.cells);
      expect(a.background, b.background);
      expect(a.foreground, b.foreground);
      expect(a.spot, b.spot);
    });

    test('ignores checksum casing and surrounding whitespace', () {
      final lower = Blockies.of(address.toLowerCase());
      final checksummed = Blockies.of(address);
      final padded = Blockies.of('  $address  ');

      expect(checksummed.cells, lower.cells);
      expect(checksummed.foreground, lower.foreground);
      expect(padded.cells, lower.cells);
    });

    test('a one-character change produces a different image', () {
      final a = Blockies.of(address);
      final b = Blockies.of(other);

      expect(a.cells, isNot(b.cells));
    });

    test('fills the full grid', () {
      expect(
        Blockies.of(address).cells,
        hasLength(Blockies.gridSize * Blockies.gridSize),
      );
    });

    test('every row mirrors across the vertical axis', () {
      final cells = Blockies.of(address).cells;

      for (var y = 0; y < Blockies.gridSize; y++) {
        for (var x = 0; x < Blockies.gridSize ~/ 2; x++) {
          final left = cells[y * Blockies.gridSize + x];
          final right = cells[y * Blockies.gridSize + (Blockies.gridSize - 1 - x)];
          expect(right, left, reason: 'row $y column $x is not mirrored');
        }
      }
    });

    // Captured from the original JavaScript `blockies` library. This is the
    // test that matters: it pins the port to the reference implementation, so
    // an avatar can never silently change for an address a user already knows.
    test('matches the JavaScript blockies reference', () {
      const vectors = <String, (List<int>, List<int>, List<int>, List<int>)>{
        '0xd8da6bf26964af9d7eed9e03e53415d37aa96045': (
          [1, 1, 251],
          [86, 30, 63],
          [55, 250, 169],
          [
            0, 1, 1, 1, 1, 1, 1, 0, //
            1, 2, 0, 2, 2, 0, 2, 1,
            1, 1, 1, 2, 2, 1, 1, 1,
            0, 1, 0, 0, 0, 0, 1, 0,
            0, 1, 0, 0, 0, 0, 1, 0,
            0, 1, 1, 0, 0, 1, 1, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 2, 1, 1, 1, 1, 2, 0,
          ],
        ),
        'abc': (
          [34, 15, 15],
          [38, 12, 12],
          [124, 98, 51],
          [
            1, 0, 1, 2, 2, 1, 0, 1, //
            0, 1, 0, 0, 0, 0, 1, 0,
            1, 1, 0, 0, 0, 0, 1, 1,
            2, 1, 1, 0, 0, 1, 1, 2,
            0, 1, 0, 0, 0, 0, 1, 0,
            0, 0, 0, 0, 0, 0, 0, 0,
            0, 2, 0, 1, 1, 0, 2, 0,
            1, 0, 1, 0, 0, 1, 0, 1,
          ],
        ),
      };

      List<int> rgb(Color c) => [
        (c.r * 255).round(),
        (c.g * 255).round(),
        (c.b * 255).round(),
      ];

      vectors.forEach((seed, expected) {
        final (foreground, background, spot, cells) = expected;
        final blockies = Blockies.of(seed);

        expect(blockies.cells, cells, reason: seed);
        expect(rgb(blockies.foreground), foreground, reason: seed);
        expect(rgb(blockies.background), background, reason: seed);
        expect(rgb(blockies.spot), spot, reason: seed);
      });
    });

    test('caching hands back the identical instance', () {
      expect(identical(Blockies.of(address), Blockies.of(address)), isTrue);
    });
  });

  group('WalletAvatar', () {
    testWidgets('lays out at the requested size', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Center(child: WalletAvatar(address: address, size: 56)),
        ),
      );

      expect(
        tester.getSize(find.byType(WalletAvatar)),
        const Size.square(56),
      );
    });
  });
}
