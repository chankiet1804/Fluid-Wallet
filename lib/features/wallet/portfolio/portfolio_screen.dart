import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/theme.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';
import 'portfolio_tokens.dart';

/// Wallet home. The layout is final; the numbers are not — every amount here is
/// a placeholder string until balances are wired to the current address.
///
/// Note how the address is read: `currentAccountProvider`, never a constructor
/// argument. That is what makes switching accounts a one-line state change
/// later instead of a rewrite.
class PortfolioScreen extends ConsumerWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final account = ref.watch(currentAccountProvider);
    final wallet = ref.watch(currentWalletProvider);

    if (account == null) {
      return SafeArea(
        child: Center(
          child: Text(
            'No wallet yet.',
            style: context.typo.bodyLarge.copyWith(color: colors.textSecondary),
          ),
        ),
      );
    }

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.screenPadding,
          vertical: AppDimens.space12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(address: account.address),
            const SizedBox(height: AppDimens.space32),
            // Constant string, not a formatted number: the real total comes
            // from Decimal later and must not inherit a double-based path.
            Text(
              r'$0.00',
              textAlign: TextAlign.center,
              style: context.typo.balanceLarge,
            ),
            const SizedBox(height: AppDimens.space8),
            _AddressRow(address: account.address),
            if (wallet != null && !wallet.isBackedUp) ...[
              const SizedBox(height: AppDimens.space16),
              const _BackupWarning(),
            ],
            const SizedBox(height: AppDimens.space24),
            const _ActionRow(),
            const SizedBox(height: AppDimens.space24),
            const _TokenList(),
            const SizedBox(height: AppDimens.space24),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        // Search, settings and the account switcher land in later phases.
        IconButton(
          onPressed: null,
          icon: Icon(Icons.search, color: colors.textPrimary),
        ),
        Expanded(child: Center(child: _AccountPill(address: address))),
        IconButton(
          onPressed: null,
          icon: Icon(Icons.settings_outlined, color: colors.textPrimary),
        ),
      ],
    );
  }
}

/// Account chip. The design mocks a wallet name here; until naming exists the
/// shortened address is the honest label — it is what identifies the account.
class _AccountPill extends StatelessWidget {
  const _AccountPill({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      child: InkWell(
        onTap: null,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.space4,
            AppDimens.space4,
            AppDimens.space8,
            AppDimens.space4,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              WalletAvatar(address: address, size: 24),
              const SizedBox(width: AppDimens.space8),
              Text(
                AppFormat.shortAddress(address),
                style: context.typo.address,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressRow extends StatelessWidget {
  const _AddressRow({required this.address});

  final String address;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          AppFormat.shortAddress(address),
          style: context.typo.address.copyWith(color: colors.textSecondary),
        ),
        const SizedBox(width: AppDimens.space4),
        // An address is public — unlike the recovery phrase, copying it is
        // exactly what it is for.
        InkWell(
          onTap: () => Clipboard.setData(ClipboardData(text: address)),
          borderRadius: BorderRadius.circular(AppDimens.radiusSm),
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.space4),
            child: Icon(
              Icons.copy_outlined,
              size: 16,
              color: colors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    // Every action is inert for now — the screens they open land in later
    // phases, and a button that moves funds is not something to stub.
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleIconButton(icon: Icons.arrow_upward, label: 'Send'),
        CircleIconButton(icon: Icons.arrow_downward, label: 'Receive'),
        CircleIconButton(icon: Icons.grid_view_rounded, label: 'Dashboard'),
        CircleIconButton(icon: Icons.more_horiz, label: 'More'),
      ],
    );
  }
}

class _TokenList extends StatelessWidget {
  const _TokenList();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.space4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: Column(
        children: [
          for (final token in kPlaceholderTokens) _TokenRow(token: token),
        ],
      ),
    );
  }
}

class _TokenRow extends StatelessWidget {
  const _TokenRow({required this.token});

  final PortfolioToken token;

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
          TokenIcon(symbol: token.symbol),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${token.amount} ${token.symbol}',
                  style: context.typo.amountMedium,
                ),
                const SizedBox(height: AppDimens.space4),
                Text(
                  token.fiat,
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
  }
}

class _BackupWarning extends StatelessWidget {
  const _BackupWarning();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: colors.warningSurface,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, size: 20, color: colors.warning),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            child: Text(
              'This wallet has no confirmed backup.',
              style: context.typo.bodyMedium.copyWith(color: colors.warning),
            ),
          ),
        ],
      ),
    );
  }
}
