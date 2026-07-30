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
}
