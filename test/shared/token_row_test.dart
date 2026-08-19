import 'package:cached_network_image/cached_network_image.dart';
import 'package:decimal/decimal.dart';
import 'package:fluid_wallet/app/theme/app_theme.dart';
import 'package:fluid_wallet/core/money/money.dart';
import 'package:fluid_wallet/data/chain/chain.dart';
import 'package:fluid_wallet/features/wallet/portfolio/portfolio_tokens.dart';
import 'package:fluid_wallet/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/test_chain_registry.dart';

void main() {
  late ChainRegistry registry;

  setUpAll(() => registry = loadTestChainRegistry());

  Future<void> pump(WidgetTester tester, PortfolioRowVm row) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: Scaffold(body: TokenRow(row: row)),
      ),
    );
  }

  TokenBalance balanceOf(
    int chainId,
    String symbol,
    String amount,
    String? usd,
  ) {
    final token = registry
        .tokensOf(chainId)
        .firstWhere((t) => t.symbol == symbol);
    return TokenBalance(
      token: token,
      amount: TokenAmount.parse(amount, decimals: token.decimals),
      fiat: usd == null
          ? null
          : FiatValue(currency: 'USD', value: Decimal.parse(usd)),
    );
  }

  testWidgets('renders amount, symbol, fiat and chain', (tester) async {
    final row = PortfolioRowVm.from(
      balanceOf(8453, 'USDC', '1234.5', '1234.38'),
      chain: registry.chain(8453),
    );

    await pump(tester, row);

    expect(find.text('1234.5 USDC'), findsOneWidget);
    expect(find.textContaining(r'$1,234.38'), findsOneWidget);
    expect(find.textContaining('Base'), findsOneWidget);
  });

  testWidgets('an unpriced holding shows a dash, never a zero', (tester) async {
    final row = PortfolioRowVm.from(
      balanceOf(8453, 'USDC', '10', null),
      chain: registry.chain(8453),
    );

    await pump(tester, row);

    expect(find.textContaining('—'), findsOneWidget);
    expect(find.textContaining(r'$0.00'), findsNothing);
  });

  testWidgets('a discovered token carries a visible warning', (tester) async {
    final fake = TokenInfo(
      ref: AssetRef(8453, '0x1111111111111111111111111111111111111111'),
      symbol: 'USDC',
      name: 'Definitely Real USDC',
      decimals: 6,
      source: TokenSource.discovered,
    );

    await pump(
      tester,
      PortfolioRowVm.from(
        TokenBalance(
          token: fake,
          amount: TokenAmount.parse('999', decimals: 6),
        ),
        chain: registry.chain(8453),
      ),
    );

    expect(find.byIcon(Icons.warning_amber_rounded), findsOneWidget);
  });

  testWidgets('a registry token carries no warning', (tester) async {
    await pump(
      tester,
      PortfolioRowVm.from(
        balanceOf(8453, 'USDC', '1', '1'),
        chain: registry.chain(8453),
      ),
    );

    expect(find.byIcon(Icons.warning_amber_rounded), findsNothing);
  });

  testWidgets('an unresolved asset shows no amount at all', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark,
        home: const Scaffold(
          body: UnresolvedRow(
            address: '0x1111111111111111111111111111111111111111',
          ),
        ),
      ),
    );

    expect(find.text('Amount unknown'), findsOneWidget);
    expect(find.text('Unknown token'), findsOneWidget);
  });

  testWidgets('the registry icon wins over the bundled asset', (tester) async {
    final token = registry.tokensOf(8453).firstWhere((t) => t.symbol == 'USDC');
    // Guards the premise: USDC is one of the symbols that ships an SVG, so if
    // the URL renders it can only be because the file outranks the asset.
    expect(token.iconUrl, isNotNull);

    await pump(
      tester,
      PortfolioRowVm.from(
        balanceOf(8453, 'USDC', '1', '1'),
        chain: registry.chain(8453),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is CachedNetworkImage && w.imageUrl == token.iconUrl,
      ),
      findsOneWidget,
    );
  });

  testWidgets('a token with no registry icon falls back to the bundled asset', (
    tester,
  ) async {
    final noIcon = TokenInfo(
      ref: AssetRef(8453, '0x2222222222222222222222222222222222222222'),
      symbol: 'ETH',
      name: 'No icon in the file',
      decimals: 18,
      source: TokenSource.discovered,
    );

    await pump(
      tester,
      PortfolioRowVm.from(
        TokenBalance(
          token: noIcon,
          amount: TokenAmount.parse('1', decimals: 18),
        ),
        // No chain, so the badge stays off and the only mark is the token's.
      ),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(CachedNetworkImage), findsNothing);
  });

  testWidgets('a dust balance never renders as 0', (tester) async {
    final token = registry.tokensOf(8453).firstWhere((t) => t.isNative);

    await pump(
      tester,
      PortfolioRowVm.from(
        TokenBalance(
          token: token,
          amount: TokenAmount(raw: BigInt.one, decimals: token.decimals),
        ),
        chain: registry.chain(8453),
      ),
    );

    expect(find.textContaining('< 0.000001'), findsOneWidget);
  });
}
