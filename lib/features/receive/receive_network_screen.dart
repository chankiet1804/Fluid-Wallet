import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../app/theme/theme.dart';
import '../../data/chain/chain.dart';
import '../../shared/widgets/widgets.dart';

/// Step one of receiving: pick the network.
///
/// The address is the same on every chain here — every entry in
/// `chains-default.json` shares a `groupChain`, so one derivation covers all of
/// them. The pick decides which network the QR screen warns about, nothing
/// else. It is a step anyway because "which network is this?" is the question
/// that loses funds when someone withdraws from an exchange.
///
/// Not the existing [showChainFilterSheet]: that sheet also toggles balance
/// fetching, and a switch that stops a chain from loading has no business in a
/// flow about receiving money.
class ReceiveNetworkScreen extends ConsumerWidget {
  const ReceiveNetworkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final chains = ref.watch(supportedChainsProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Select network', style: context.typo.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.screenPadding,
            AppDimens.space8,
            AppDimens.screenPadding,
            AppDimens.space32,
          ),
          children: [
            Text(
              'Choose the network the sender will use. Your address is the '
              'same on all of them.',
              style: context.typo.bodyMedium.copyWith(
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimens.space16),
            for (final chain in chains) ...[
              _NetworkTile(chain: chain),
              const SizedBox(height: AppDimens.space8),
            ],
          ],
        ),
      ),
    );
  }
}

class _NetworkTile extends StatelessWidget {
  const _NetworkTile({required this.chain});

  final ChainInfo chain;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      child: InkWell(
        onTap: () => context.push(AppRoute.receiveQrPath(chain.chainId)),
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.space16),
          child: Row(
            children: [
              ChainAvatar(chain: chain, size: 32),
              const SizedBox(width: AppDimens.space12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(chain.name, style: context.typo.titleMedium),
                    Text(
                      chain.nativeSymbol,
                      style: context.typo.caption.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: colors.textTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
