import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/theme.dart';
import '../../../data/chain/chain.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';
import 'chain_filter_sheet.dart';
import 'portfolio_format.dart';
import 'portfolio_tokens.dart';
import 'wallet_switcher_sheet.dart';

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
    final state = ref.watch(walletControllerProvider).value;
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
      child: RefreshIndicator(
        onRefresh: () => refreshPortfolio(ref),
        child: SingleChildScrollView(
          // Always scrollable so the pull gesture works even when the content
          // is short — an empty wallet still needs a way to retry.
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding,
            vertical: AppDimens.space12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(
                address: account.address,
                walletName: wallet == null
                    ? null
                    : walletDisplayName(
                        wallet,
                        state!.wallets.indexWhere((w) => w.id == wallet.id),
                      ),
              ),
              const SizedBox(height: AppDimens.space32),
              const _Total(),
              const SizedBox(height: AppDimens.space8),
              _AddressRow(address: account.address),
              if (wallet != null && !wallet.isBackedUp) ...[
                const SizedBox(height: AppDimens.space16),
                const _BackupWarning(),
              ],
              const SizedBox(height: AppDimens.space24),
              const _ActionRow(),
              const SizedBox(height: AppDimens.space24),
              const _ChainFilterPill(),
              const SizedBox(height: AppDimens.space12),
              const _TokenList(),
              const SizedBox(height: AppDimens.space24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.address, this.walletName});

  final String address;
  final String? walletName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        // Search lands in a later phase.
        IconButton(
          onPressed: null,
          icon: Icon(Icons.search, color: colors.textPrimary),
        ),
        Expanded(
          child: Center(
            child: _AccountPill(address: address, walletName: walletName),
          ),
        ),
        IconButton(
          // `push`, not `go`: Settings sits on top of the shell and the back
          // button has to land back on this tab.
          onPressed: () => context.push(AppRoute.settings),
          icon: Icon(Icons.settings_outlined, color: colors.textPrimary),
        ),
      ],
    );
  }
}

/// Account chip and the entry point to the wallet switcher. Falls back to the
/// shortened address for wallets stored before naming existed.
class _AccountPill extends StatelessWidget {
  const _AccountPill({required this.address, this.walletName});

  final String address;
  final String? walletName;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surfaceElevated,
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      child: InkWell(
        onTap: () => showWalletSwitcherSheet(context),
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
              if (walletName == null)
                Text(
                  AppFormat.shortAddress(address),
                  style: context.typo.address,
                )
              else
                Text(walletName!, style: context.typo.label),
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

/// The headline balance.
///
/// Note what the error branch renders: an em dash, never `$0.00`. A funded
/// wallet whose fetch failed showing zero is the failure this whole layer exists
/// to prevent — the user reads it as having been drained.
class _Total extends ConsumerWidget {
  const _Total();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(visiblePortfolioProvider);
    final typo = context.typo;
    final colors = context.colors;

    return switch (snapshot) {
      AsyncData(:final value) => Column(
        children: [
          Text(
            formatPortfolioTotal(value).text,
            textAlign: TextAlign.center,
            style: typo.balanceLarge,
          ),
          if (!value.isComplete) ...[
            const SizedBox(height: AppDimens.space8),
            _PartialTotalChip(snapshot: value),
          ],
        ],
      ),
      AsyncError() => Text(
        '—',
        textAlign: TextAlign.center,
        style: typo.balanceLarge.copyWith(color: colors.textSecondary),
      ),
      _ => Text(
        '—',
        textAlign: TextAlign.center,
        style: typo.balanceLarge.copyWith(color: colors.textTertiary),
      ),
    };
  }
}

class _PartialTotalChip extends ConsumerWidget {
  const _PartialTotalChip({required this.snapshot});

  final PortfolioSnapshot snapshot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final reason = portfolioIncompleteReason(
      snapshot,
      ref.watch(chainRegistryProvider),
    );
    if (reason == null) return const SizedBox.shrink();

    return Align(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space12,
          vertical: AppDimens.space4,
        ),
        decoration: BoxDecoration(
          color: colors.warningSurface,
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.info_outline, size: 14, color: colors.warning),
            const SizedBox(width: AppDimens.space4),
            Flexible(
              child: Text(
                reason,
                style: context.typo.caption.copyWith(color: colors.warning),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Entry point to the network sheet. A pill above the list rather than a new
/// header affordance, so the header layout stays as designed.
class _ChainFilterPill extends ConsumerWidget {
  const _ChainFilterPill();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final filter = ref.watch(chainFilterProvider);
    final chain = filter == null
        ? null
        : ref.watch(chainRegistryProvider).chain(filter);

    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        child: InkWell(
          onTap: () => showChainFilterSheet(context),
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space12,
              vertical: AppDimens.space8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (chain != null) ...[
                  ChainAvatar(chain: chain, size: 16),
                  const SizedBox(width: AppDimens.space8),
                ],
                Text(chain?.name ?? 'All networks', style: context.typo.caption),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TokenList extends ConsumerWidget {
  const _TokenList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(visiblePortfolioProvider);
    final registry = ref.watch(chainRegistryProvider);
    final singleChain = ref.watch(chainFilterProvider) != null;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.space4),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      child: switch (snapshot) {
        // Nothing came back AND at least one chain failed. "No tokens yet" must
        // never stand in for "we could not look" — an empty list reads as an
        // empty wallet.
        AsyncData(:final value)
            when value.balances.isEmpty &&
                value.unresolved.isEmpty &&
                value.hasFailures =>
          const _ListError(),
        AsyncData(:final value) when value.balances.isEmpty &&
            value.unresolved.isEmpty =>
          const _ListMessage(text: 'No tokens yet.'),
        AsyncData(:final value) => Column(
          children: [
            for (final balance in value.balances)
              TokenRow(
                row: PortfolioRowVm.from(
                  balance,
                  chain: registry.chain(balance.chainId),
                  showChainBadge: !singleChain,
                ),
              ),
            if (value.unresolved.isNotEmpty) ...[
              const _SectionLabel('Unrecognised'),
              for (final asset in value.unresolved)
                UnresolvedRow(address: asset.ref.address, symbol: asset.symbol),
            ],
          ],
        ),
        AsyncError() => const _ListError(),
        _ => const _ListSkeleton(),
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimens.space16,
        AppDimens.space12,
        AppDimens.space16,
        AppDimens.space4,
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: context.typo.caption.copyWith(
            color: context.colors.textTertiary,
          ),
        ),
      ),
    );
  }
}

class _ListMessage extends StatelessWidget {
  const _ListMessage({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.space24),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: context.typo.bodyMedium.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}

class _ListError extends ConsumerWidget {
  const _ListError();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.all(AppDimens.space24),
      child: Column(
        children: [
          Icon(Icons.cloud_off_outlined, color: colors.textSecondary),
          const SizedBox(height: AppDimens.space8),
          Text(
            "Couldn't load balances.",
            textAlign: TextAlign.center,
            style: context.typo.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.space12),
          TextButton(
            onPressed: () => refreshPortfolio(ref),
            child: Text('Retry', style: TextStyle(color: colors.accent)),
          ),
        ],
      ),
    );
  }
}

class _ListSkeleton extends StatelessWidget {
  const _ListSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      children: [
        for (var i = 0; i < 3; i++)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space16,
              vertical: AppDimens.space12,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colors.surfaceElevated,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppDimens.space12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SkeletonBar(width: 120, color: colors.surfaceElevated),
                      const SizedBox(height: AppDimens.space8),
                      _SkeletonBar(width: 72, color: colors.surfaceElevated),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SkeletonBar extends StatelessWidget {
  const _SkeletonBar({required this.width, required this.color});

  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
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
