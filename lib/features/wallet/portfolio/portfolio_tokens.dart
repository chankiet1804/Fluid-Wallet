/// One row of the portfolio token list.
typedef PortfolioToken = ({String symbol, String amount, String fiat});

/// Static placeholder until balances are wired to the current address.
///
/// The amounts are strings, not numbers, on purpose: a real balance is a
/// `BigInt` of smallest units plus that token's own `decimals`, and must never
/// pass through `double`. Keeping the placeholder textual means nothing here
/// can quietly become the formatting path for real money.
///
/// Replace this with a `FutureProvider.family` of `List<PortfolioToken>` keyed
/// by address — never a singleton, so switching account cannot show the
/// previous account's balances.
const kPlaceholderTokens = <PortfolioToken>[
  (symbol: 'USDC', amount: '0', fiat: r'$0.00'),
  (symbol: 'ETH', amount: '0', fiat: r'$0.00'),
  (symbol: 'USDT', amount: '0', fiat: r'$0.00'),
  (symbol: 'wstETH', amount: '0', fiat: r'$0.00'),
];
