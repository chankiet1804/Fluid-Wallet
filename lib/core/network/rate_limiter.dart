import 'dart:async';

/// Caps how many requests are in flight to one host, and how closely spaced
/// they are.
///
/// CoinGecko's free tier is roughly 10-30 requests a minute and answers a burst
/// with a 429; serialising with a small gap costs a slightly slower first paint
/// and avoids a throttle that lasts far longer.
class RateLimiter {
  RateLimiter({required this.maxConcurrent, this.minInterval = Duration.zero})
    : assert(maxConcurrent > 0, 'maxConcurrent must be positive');

  final int maxConcurrent;

  /// Minimum gap between two request starts. Zero disables spacing.
  final Duration minInterval;

  int _inFlight = 0;
  DateTime? _lastStart;
  final _waiting = <Completer<void>>[];

  /// Runs [action] once a slot is free. Queued callers are served FIFO, so a
  /// request cannot be starved by later ones.
  Future<T> run<T>(Future<T> Function() action) async {
    await _acquire();
    try {
      return await action();
    } finally {
      _release();
    }
  }

  Future<void> _acquire() async {
    if (_inFlight >= maxConcurrent) {
      final waiter = Completer<void>();
      _waiting.add(waiter);
      await waiter.future;
    }
    _inFlight++;

    if (minInterval > Duration.zero) {
      final last = _lastStart;
      if (last != null) {
        final elapsed = DateTime.now().difference(last);
        if (elapsed < minInterval) {
          await Future<void>.delayed(minInterval - elapsed);
        }
      }
      _lastStart = DateTime.now();
    }
  }

  void _release() {
    _inFlight--;
    if (_waiting.isNotEmpty) _waiting.removeAt(0).complete();
  }
}
