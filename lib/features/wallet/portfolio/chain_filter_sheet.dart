import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../app/theme/theme.dart';
import '../../../data/chain/chain.dart';
import '../../../shared/widgets/widgets.dart';

/// Network picker. A sheet, not a dialog — see the plan overview §4.6.
Future<void> showChainFilterSheet(BuildContext context) {
  return showAppSheet<void>(context, (_) => const ChainFilterSheet());
}

/// Chooses which chain the portfolio shows.
///
/// This is a display filter only: every enabled chain is still fetched, so
/// switching is instant and costs no request. Turning a chain *off* entirely is
/// a different action and lives on the toggle to the right of each row.
class ChainFilterSheet extends ConsumerWidget {
  const ChainFilterSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chains = ref.watch(supportedChainsProvider);
    final selected = ref.watch(chainFilterProvider);
    final enabled = ref.watch(enabledChainsProvider);

    return AppSheet(
      title: 'Networks',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AllNetworksRow(isSelected: selected == null),
          for (final chain in chains)
            _ChainRow(
              chain: chain,
              isSelected: selected == chain.chainId,
              isEnabled: enabled.contains(chain.chainId),
            ),
          const SizedBox(height: AppDimens.space16),
        ],
      ),
    );
  }
}

class _AllNetworksRow extends ConsumerWidget {
  const _AllNetworksRow({required this.isSelected});

  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _RowShell(
      leading: Icon(
        Icons.blur_on,
        color: context.colors.textSecondary,
        size: 28,
      ),
      title: 'All networks',
      isSelected: isSelected,
      onTap: () {
        ref.read(chainFilterProvider.notifier).select(null);
        Navigator.of(context).pop();
      },
    );
  }
}

class _ChainRow extends ConsumerWidget {
  const _ChainRow({
    required this.chain,
    required this.isSelected,
    required this.isEnabled,
  });

  final ChainInfo chain;
  final bool isSelected;
  final bool isEnabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return _RowShell(
      leading: ChainAvatar(chain: chain, size: 28),
      title: chain.name,
      // Say why a chain shows nothing rather than leaving a silent gap.
      subtitle: !chain.supportsBalanceFetch
          ? 'Balances not supported yet'
          : !isEnabled
          ? 'Not being fetched'
          : null,
      isSelected: isSelected,
      trailing: Switch(
        value: isEnabled,
        onChanged: chain.supportsBalanceFetch
            ? (_) =>
                  ref.read(enabledChainsProvider.notifier).toggle(chain.chainId)
            : null,
        activeThumbColor: colors.onAccent,
        activeTrackColor: colors.accent,
      ),
      onTap: () {
        ref.read(chainFilterProvider.notifier).select(chain.chainId);
        Navigator.of(context).pop();
      },
    );
  }
}

class _RowShell extends StatelessWidget {
  const _RowShell({
    required this.leading,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.subtitle,
    this.trailing,
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final bool isSelected;
  final Widget? trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final subtitle = this.subtitle;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimens.space12),
        child: Row(
          children: [
            leading,
            const SizedBox(width: AppDimens.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.typo.label),
                  if (subtitle != null) ...[
                    const SizedBox(height: AppDimens.space4),
                    Text(
                      subtitle,
                      style: context.typo.caption.copyWith(
                        color: colors.textTertiary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check, size: 20, color: colors.accent)
            else
              const SizedBox(width: 20),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// A chain's mark: the registry's URL, with the bundled SVG standing in while
/// it loads and if it fails.
class ChainAvatar extends StatelessWidget {
  const ChainAvatar({super.key, required this.chain, this.size = 20});

  final ChainInfo chain;
  final double size;

  @override
  Widget build(BuildContext context) {
    final asset = chain.bundledIconAsset;
    final url = chain.iconUrl;

    final Widget fallback = asset == null
        ? SizedBox(width: size, height: size)
        : SvgPicture.asset(asset, width: size, height: size);

    if (url == null || url.isEmpty) return ClipOval(child: fallback);

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (_, _) => fallback,
        errorWidget: (_, _, _) => fallback,
      ),
    );
  }
}
