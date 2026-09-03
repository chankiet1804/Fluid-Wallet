import 'dart:math';

/// Display formatting that must look identical on every screen.
///
/// Lives next to the type scale on purpose: a shortened address is a
/// presentation decision, and the design uses the same `0x1388…47cf` shape on
/// Wallet, Send and Settings.
abstract final class AppFormat {
  /// `0x1388…47cf` — pair with `context.typo.address`.
  ///
  /// Returns [address] unchanged when it is too short to shorten, so a
  /// malformed value stays visible instead of being disguised as valid.
  static String shortAddress(String address, {int head = 6, int tail = 4}) {
    if (address.length <= head + tail + 1) return address;
    return '${address.substring(0, head)}…'
        '${address.substring(address.length - tail)}';
  }

  /// Splits [address] into [lines] near-even chunks — pair with
  /// `context.typo.address`.
  ///
  /// An address has no whitespace, so `Text` cannot wrap it: left alone it
  /// overflows or gets ellipsized, and a half-shown address is worse than a
  /// shortened one. Splitting here keeps the widget dumb and every character
  /// on screen.
  static List<String> addressLines(String address, {int lines = 2}) {
    if (lines <= 1 || address.length <= lines) return [address];

    final size = (address.length / lines).ceil();
    return [
      for (var start = 0; start < address.length; start += size)
        address.substring(start, min(start + size, address.length)),
    ];
  }
}
