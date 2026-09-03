import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../app/theme/theme.dart';
import '../../data/chain/chain.dart';
import '../../data/wallet_providers.dart';
import '../../shared/widgets/widgets.dart';

/// Step two of receiving: the address as a QR.
///
/// What the QR encodes is the checksummed address and nothing else — no chain
/// id, no EIP-681 URI. [chainId] only picks the mark in the middle and the
/// network named in the warning. Encoding the chain into the payload would
/// make a code some wallets refuse to parse, for no gain: the address is
/// identical on every chain in the registry.
class ReceiveQrScreen extends ConsumerWidget {
  const ReceiveQrScreen({super.key, required this.chainId});

  final int chainId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final account = ref.watch(currentAccountProvider);
    final chain = ref.watch(chainRegistryProvider).chain(chainId);

    // Both guards render chrome without a code. A QR of an empty string is
    // still a valid, scannable symbol — that is an address someone can send
    // funds to, and it belongs to nobody.
    final Widget body;
    if (account == null) {
      body = const _Empty(message: 'No wallet yet.');
    } else if (chain == null) {
      body = const _Empty(message: 'Unsupported network.');
    } else {
      body = _ReceiveBody(address: account.address, chain: chain);
    }

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Receive', style: context.typo.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(child: body),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: context.typo.bodyLarge.copyWith(
          color: context.colors.textSecondary,
        ),
      ),
    );
  }
}

class _ReceiveBody extends StatelessWidget {
  const _ReceiveBody({required this.address, required this.chain});

  final String address;
  final ChainInfo chain;

  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.fromLTRB(
      AppDimens.screenPadding,
      AppDimens.space8,
      AppDimens.screenPadding,
      AppDimens.space24,
    );

    // The address card sits at the bottom; the code centres in what is left
    // above it. `spaceBetween` over an empty leader does that and still lets a
    // short screen scroll — a Spacer would need SliverFillRemaining, which
    // measures its child's intrinsic height and so cannot hold the
    // LayoutBuilder that sizes the QR.
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        padding: padding,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: constraints.maxHeight - padding.vertical,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox.shrink(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AddressQr(address: address, chain: chain),
                  const SizedBox(height: AppDimens.space16),
                  _NetworkCaption(chain: chain),
                ],
              ),
              _AddressCard(address: address, chain: chain),
            ],
          ),
        ),
      ),
    );
  }
}

/// The one place that decides what the code encodes.
///
/// Public, and taking [address] as a plain field, so a test can assert the
/// screen hands it the account address untouched: `QrImageView` keeps its
/// payload private, so there is no way to read it back off the rendered
/// widget.
class AddressQr extends StatelessWidget {
  const AddressQr({super.key, required this.address, required this.chain});

  /// Edge of the code, capped so it stays square on a wide screen.
  static const _maxSize = 280.0;

  /// The white margin around the modules. A scanner needs it to find the
  /// symbol at all, so it is the light ground the design asks for — no card
  /// behind the code, just this.
  static const _quietZone = AppDimens.space12;

  /// Fraction of the *code* the centre mark may cover. Level H recovers 30% of
  /// the symbol; 0.20 keeps the obscured area far enough under that budget to
  /// survive a scratched screen and an off-axis camera. Never raise it.
  static const _markRatio = 0.20;

  final String address;
  final ChainInfo chain;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = min(constraints.maxWidth, _maxSize);

        return Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppDimens.radiusMd),
            child: SizedBox.square(
              dimension: size,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  QrImageView(
                    data: address,
                    version: QrVersions.auto,
                    size: size,
                    // Deliberately white in a dark app: a QR needs a light
                    // ground to scan.
                    backgroundColor: colors.qrSurface,
                    // The centre mark covers modules the encoder does not know
                    // about, so the redundancy of level H is the only thing
                    // making them recoverable.
                    errorCorrectionLevel: QrErrorCorrectLevel.H,
                    eyeStyle: QrEyeStyle(
                      eyeShape: QrEyeShape.square,
                      color: colors.onQrSurface,
                    ),
                    dataModuleStyle: QrDataModuleStyle(
                      dataModuleShape: QrDataModuleShape.square,
                      color: colors.onQrSurface,
                    ),
                    gapless: true,
                    padding: const EdgeInsets.all(_quietZone),
                    semanticsLabel: 'Wallet address QR code',
                  ),
                  // Measured against the modules, not the box: the quiet zone
                  // carries no data, so counting it would quietly let the mark
                  // cover more of the code than the ratio claims.
                  _CentreMark(
                    chain: chain,
                    size: (size - _quietZone * 2) * _markRatio,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CentreMark extends StatelessWidget {
  const _CentreMark({required this.chain, required this.size});

  final ChainInfo chain;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(AppDimens.space4),
      decoration: BoxDecoration(
        // Opaque, not transparent: several network marks have a clear
        // background, and QR modules showing through a logo is exactly the
        // ambiguity that breaks a decode.
        color: context.colors.qrSurface,
        shape: BoxShape.circle,
      ),
      child: ChainAvatar(chain: chain, size: size - AppDimens.space8),
    );
  }
}

class _NetworkCaption extends StatelessWidget {
  const _NetworkCaption({required this.chain});

  final ChainInfo chain;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // The emphasis is a type token swap, not a copyWith on the weight — both
    // spans are 16px Inter, so they share a baseline and read as one sentence.
    return Text.rich(
      TextSpan(
        children: [
          const TextSpan(text: 'Send assets only on the '),
          TextSpan(
            text: chain.name,
            style: context.typo.label.copyWith(color: colors.textPrimary),
          ),
          const TextSpan(text: ' network'),
        ],
      ),
      textAlign: TextAlign.center,
      style: context.typo.bodyLarge.copyWith(color: colors.textSecondary),
    );
  }
}

class _AddressCard extends StatelessWidget {
  const _AddressCard({required this.address, required this.chain});

  final String address;
  final ChainInfo chain;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg),
      ),
      padding: const EdgeInsets.all(AppDimens.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _NetworkChip(chain: chain),
          const SizedBox(height: AppDimens.space12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final line in AppFormat.addressLines(address))
                      Text(line, style: context.typo.address),
                  ],
                ),
              ),
              const SizedBox(width: AppDimens.space12),
              _CopyButton(address: address),
            ],
          ),
        ],
      ),
    );
  }
}

/// Shows the chosen network, and goes back to the picker to change it.
class _NetworkChip extends StatelessWidget {
  const _NetworkChip({required this.chain});

  final ChainInfo chain;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: colors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        child: InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(AppDimens.radiusPill),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimens.space12,
              vertical: AppDimens.space8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ChainAvatar(chain: chain, size: 16),
                const SizedBox(width: AppDimens.space8),
                Text(chain.name, style: context.typo.caption),
                const SizedBox(width: AppDimens.space4),
                Icon(Icons.expand_more, size: 16, color: colors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A pill, not a [PrimaryButton]: that one is full-width and 56dp tall, and it
/// stays that way for the screens that move funds.
///
/// The confirmation is the label swap — a sheet would be absurd for a copy,
/// and a SnackBar is out (overview §4.6).
class _CopyButton extends StatefulWidget {
  const _CopyButton({required this.address});

  final String address;

  @override
  State<_CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<_CopyButton> {
  static const _feedback = Duration(seconds: 2);

  Timer? _timer;
  bool _copied = false;

  void _copy() {
    // An address is public — unlike the recovery phrase, nothing here is
    // cleared from the clipboard afterwards. Pasting it is the whole point.
    Clipboard.setData(ClipboardData(text: widget.address));
    _timer?.cancel();
    setState(() => _copied = true);
    _timer = Timer(_feedback, () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.accent,
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      child: InkWell(
        onTap: _copy,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.space16,
            vertical: AppDimens.space8,
          ),
          child: Text(
            _copied ? 'Copied' : 'Copy',
            style: context.typo.label.copyWith(color: colors.onAccent),
          ),
        ),
      ),
    );
  }
}
