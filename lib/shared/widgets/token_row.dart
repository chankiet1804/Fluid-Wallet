import 'package:flutter/material.dart';

import '../../app/theme/theme.dart';
import '../../features/wallet/portfolio/portfolio_tokens.dart';
import 'token_icon.dart';

/// One token in a list: mark, amount, fiat value.
///
/// Takes a formatted [PortfolioRowVm] rather than a `TokenBalance`, so the
/// widget stays free of the data layer and cheap to test. Send's token picker
/// and Swap's select-token sheet reuse it.
class TokenRow extends StatelessWidget {
  const TokenRow({super.key, required this.row, this.onTap});

  final PortfolioRowVm row;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final content = Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space16,
        vertical: AppDimens.space12,
      ),
      child: Row(
        children: [
          TokenIcon(
            symbol: row.symbol,
            iconUrl: row.iconUrl,
            chainIconAsset: row.chainIconAsset,
            chainIconUrl: row.chainIconUrl,
          ),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${row.amountText} ${row.symbol}',
                        style: context.typo.amountMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!row.isVerified) ...[
                      const SizedBox(width: AppDimens.space4),
                      Icon(
                        Icons.warning_amber_rounded,
                        size: 14,
                        color: colors.warning,
                        semanticLabel: 'Unverified token',
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppDimens.space4),
                Text(
                  row.chainName == null
                      ? row.fiatText
                      : '${row.fiatText} · ${row.chainName}',
                  style: context.typo.caption.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return InkWell(onTap: onTap, child: content);
  }
}

/// A balance we could not type: the contract answered, but not with a usable
/// `decimals`.
///
/// Renders the address and nothing else. Printing an amount without a
/// trustworthy scale would be inventing a number.
class UnresolvedRow extends StatelessWidget {
  const UnresolvedRow({super.key, required this.address, this.symbol});

  final String address;
  final String? symbol;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.space16,
        vertical: AppDimens.space12,
      ),
      child: Row(
        children: [
          TokenIcon(symbol: symbol ?? '?'),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  symbol ?? 'Unknown token',
                  style: context.typo.amountMedium.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimens.space4),
                Text(
                  AppFormat.shortAddress(address),
                  style: context.typo.address.copyWith(
                    color: colors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Amount unknown',
            style: context.typo.caption.copyWith(color: colors.warning),
          ),
        ],
      ),
    );
  }
}
