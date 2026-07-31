import 'package:flutter/material.dart';

/// Deterministic identicon for a wallet address, in the Blockies style used by
/// MetaMask and Rainbow.
///
/// Ported by hand instead of pulled from pub.dev on purpose: every Blockies
/// package on pub.dev is either unmaintained or from an unverified publisher,
/// and the avatar is a *safety* signal — it must stay byte-identical for a
/// given address forever, so a dependency silently changing its algorithm is
/// not an acceptable risk. The palette is generated from the address hash, not
/// from the theme tokens; that is inherent to identicons and was agreed as an
/// explicit exception to the token rule.
///
/// Purely visual — takes an address string, touches no wallet state.
class WalletAvatar extends StatelessWidget {
  const WalletAvatar({
    super.key,
    required this.address,
    this.size = 40,
    this.shape = BoxShape.circle,
  });

  final String address;
  final double size;
  final BoxShape shape;

  @override
  Widget build(BuildContext context) {
    final blockies = Blockies.of(address);
    final avatar = CustomPaint(
      size: Size.square(size),
      painter: _BlockiesPainter(blockies),
      isComplex: false,
    );

    return SizedBox.square(
      dimension: size,
      child: shape == BoxShape.circle
          ? ClipOval(child: avatar)
          : ClipRRect(
              borderRadius: BorderRadius.circular(size / 4),
              child: avatar,
            ),
    );
  }
}

/// The pixels and colours of one identicon: an [gridSize] × [gridSize] grid,
/// mirrored across the vertical axis.
///
/// A direct port of the JavaScript `blockies` PRNG (a 4×32-bit xorshift seeded
/// with Java's `String.hashCode` spread over four words). The 32-bit truncation
/// points below mirror where JavaScript's bitwise operators coerce to int32 —
/// moving one produces a different, wrong image.
@immutable
class Blockies {
  const Blockies._({
    required this.cells,
    required this.background,
    required this.foreground,
    required this.spot,
  });

  /// Matches the JS default. Not configurable: changing it would change every
  /// existing avatar.
  static const gridSize = 8;

  /// Row-major, `gridSize * gridSize` entries. 0 = background, 1 = foreground,
  /// anything else = spot colour.
  final List<int> cells;
  final Color background;
  final Color foreground;
  final Color spot;

  /// Identicons are rebuilt on every scroll frame and every screen that shows
  /// an address, so the handful of addresses in play are kept resolved. Bounded
  /// because a contacts list or a history screen can walk through many.
  static const _cacheLimit = 64;
  static final _cache = <String, Blockies>{};

  /// Resolves the identicon for [address], reusing the cached one when
  /// possible. The seed is the lowercased address, exactly what MetaMask
  /// feeds the JS library — a checksummed address would produce a different
  /// image for the same account.
  factory Blockies.of(String address) {
    final seed = address.trim().toLowerCase();
    final cached = _cache[seed];
    if (cached != null) return cached;

    final blockies = Blockies._fromSeed(seed);
    if (_cache.length >= _cacheLimit) _cache.remove(_cache.keys.first);
    _cache[seed] = blockies;
    return blockies;
  }

  factory Blockies._fromSeed(String seed) {
    final random = _XorShift(seed);

    // Order matters: the three colours are drawn before the grid, so swapping
    // these lines shifts the whole random stream.
    final foreground = _color(random);
    final background = _color(random);
    final spot = _color(random);

    // Only the left half is generated; the right half is its mirror, which is
    // what gives Blockies their symmetry.
    const halfWidth = (gridSize + 1) ~/ 2;
    final cells = <int>[];
    for (var y = 0; y < gridSize; y++) {
      final row = [
        for (var x = 0; x < halfWidth; x++) (random.next() * 2.3).floor(),
      ];
      cells
        ..addAll(row)
        ..addAll(row.take(gridSize - halfWidth).toList().reversed);
    }

    return Blockies._(
      cells: List.unmodifiable(cells),
      background: background,
      foreground: foreground,
      spot: spot,
    );
  }

  Color colorAt(int index) => switch (cells[index]) {
    0 => background,
    1 => foreground,
    _ => spot,
  };

  /// [_XorShift.next] returns values in `[0, 2)`, not `[0, 1)` — a quirk of the
  /// original implementation that widens the ranges below. Kept as-is: the
  /// clamps reproduce how CSS handles the out-of-range `hsl()` values it emits.
  static Color _color(_XorShift random) {
    final hue = (random.next() * 360).floorToDouble() % 360;
    final saturation = (random.next() * 60 + 40) / 100;
    final lightness =
        (random.next() + random.next() + random.next() + random.next()) *
        25 /
        100;
    return HSLColor.fromAHSL(
      1,
      hue,
      saturation.clamp(0.0, 1.0),
      lightness.clamp(0.0, 1.0),
    ).toColor();
  }
}

/// The JS blockies PRNG. Not a general-purpose random source — it exists only
/// to reproduce the reference image byte for byte.
class _XorShift {
  _XorShift(String seed) {
    for (var i = 0; i < seed.length; i++) {
      final slot = i % 4;
      // `x << 5` in JavaScript truncates to int32; the subtraction and addition
      // that follow do not, so only the shift is truncated here.
      _state[slot] =
          _int32(_state[slot] << 5) - _state[slot] + seed.codeUnitAt(i);
    }
  }

  final _state = <int>[0, 0, 0, 0];

  double next() {
    final s0 = _int32(_state[0]);
    final t = s0 ^ _int32(s0 << 11);
    _state[0] = _state[1];
    _state[1] = _state[2];
    _state[2] = _state[3];
    final s3 = _int32(_state[3]);
    // Arithmetic (sign-propagating) shifts, matching JS `>>`.
    _state[3] = _int32(s3 ^ (s3 >> 19) ^ t ^ (t >> 8));
    // Unsigned numerator over 2^31 — hence the `[0, 2)` range noted above.
    return (_state[3] & 0xFFFFFFFF) / 2147483648.0;
  }

  static int _int32(int value) => value.toSigned(32);
}

class _BlockiesPainter extends CustomPainter {
  const _BlockiesPainter(this.blockies);

  final Blockies blockies;

  @override
  void paint(Canvas canvas, Size size) {
    final block = size.width / Blockies.gridSize;
    final paint = Paint()..style = PaintingStyle.fill;

    canvas.drawRect(Offset.zero & size, paint..color = blockies.background);

    for (var i = 0; i < blockies.cells.length; i++) {
      if (blockies.cells[i] == 0) continue;
      final x = i % Blockies.gridSize;
      final y = i ~/ Blockies.gridSize;
      canvas.drawRect(
        // Half a logical pixel of bleed so antialiasing never leaves seams
        // between neighbouring blocks of the same colour.
        Rect.fromLTWH(x * block, y * block, block + 0.5, block + 0.5),
        paint..color = blockies.colorAt(i),
      );
    }
  }

  @override
  bool shouldRepaint(_BlockiesPainter oldDelegate) =>
      !identical(oldDelegate.blockies, blockies);
}
