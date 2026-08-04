/// How `assets/config/chains-default.json` spells a chain's native coin.
///
/// Deliberately the zero address, matching that file. It is NOT the
/// `0xEeee…EEeE` sentinel MetaMask, 0x, 1inch and LI.FI use in the same
/// position — see [kAggregatorNativeSentinel].
const String kNativeAddress = '0x0000000000000000000000000000000000000000';

/// What swap aggregators mean by "the native coin" in a token-address field.
///
/// The translation lives in [toAggregatorAddress] and must stay the only place
/// it happens: a sentinel converted in one call path and forgotten in another
/// is a quote for the wrong asset.
const String kAggregatorNativeSentinel =
    '0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee';

/// Address to send to a swap aggregator for [address].
///
/// Phase 5 (0x) is the only caller. Kept here rather than in the swap layer so
/// the two sentinels sit next to each other and the difference is impossible to
/// miss while reading either one.
String toAggregatorAddress(String address) =>
    address == kNativeAddress ? kAggregatorNativeSentinel : address;
