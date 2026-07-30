import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'app_dimens.dart';
import 'app_format.dart';
import 'theme_context.dart';

/// Dev-only screen that renders every design token so they can be checked by
/// eye against the design. Not part of the app — gate its route behind
/// `kDebugMode` once routing exists.
class DesignGallery extends StatelessWidget {
  const DesignGallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppDimens.screenPadding),
          children: const [
            _Section('Colors'),
            _ColorSwatches(),
            SizedBox(height: AppDimens.space32),
            _Section('Typography'),
            _TypeScale(),
            SizedBox(height: AppDimens.space32),
            _Section('Tabular figures'),
            _TabularFiguresProof(),
            SizedBox(height: AppDimens.space32),
            _Section('Monospace address'),
            _AddressProof(),
            SizedBox(height: AppDimens.space32),
            _Section('QR surface'),
            _QrSurfaceProof(),
            SizedBox(height: AppDimens.space32),
            _Section('Chain icons'),
            _IconGrid(_IconGrid.networks),
            SizedBox(height: AppDimens.space32),
            _Section('Token icons'),
            _IconGrid(_IconGrid.tokens),
            SizedBox(height: AppDimens.space32),
            _Section('Spacing'),
            _SpacingScale(),
            SizedBox(height: AppDimens.space32),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.space16),
      child: Text(title, style: context.typo.titleLarge),
    );
  }
}

class _ColorSwatches extends StatelessWidget {
  const _ColorSwatches();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final entries = <(String, Color)>[
      ('background', c.background),
      ('surface', c.surface),
      ('surfaceElevated', c.surfaceElevated),
      ('border', c.border),
      ('textPrimary', c.textPrimary),
      ('textSecondary', c.textSecondary),
      ('textTertiary', c.textTertiary),
      ('accent', c.accent),
      ('accentPressed', c.accentPressed),
      ('success', c.success),
      ('successSurface', c.successSurface),
      ('danger', c.danger),
      ('dangerSurface', c.dangerSurface),
      ('warning', c.warning),
      ('warningSurface', c.warningSurface),
      ('qrSurface', c.qrSurface),
    ];

    return Column(
      children: [
        for (final (name, color) in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.space8),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                    border: Border.all(color: c.border),
                  ),
                ),
                const SizedBox(width: AppDimens.space16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: context.typo.bodyMedium),
                      Text(
                        _hex(color),
                        style: context.typo.caption
                            .copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static String _hex(Color color) {
    final argb = color.toARGB32();
    return '#${argb.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}

class _TypeScale extends StatelessWidget {
  const _TypeScale();

  @override
  Widget build(BuildContext context) {
    final t = context.typo;
    // Vietnamese diacritics on purpose — verifies Inter covers the full set.
    const sample = 'Số dư ví của bạn — Gửi tiền đã xác nhận';
    final entries = <(String, TextStyle)>[
      ('balanceLarge', t.balanceLarge),
      ('numericInput', t.numericInput),
      ('titleLarge', t.titleLarge),
      ('titleMedium', t.titleMedium),
      ('bodyLarge', t.bodyLarge),
      ('bodyMedium', t.bodyMedium),
      ('amountMedium', t.amountMedium),
      ('label', t.label),
      ('caption', t.caption),
      ('address', t.address),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (name, style) in entries)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.space16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: context.typo.caption
                      .copyWith(color: context.colors.textSecondary),
                ),
                const SizedBox(height: AppDimens.space4),
                Text(sample, style: style),
              ],
            ),
          ),
      ],
    );
  }
}

/// Amount changes every second. If tabular figures are working the digits stay
/// put; without them the whole line jitters horizontally on every tick.
class _TabularFiguresProof extends StatefulWidget {
  const _TabularFiguresProof();

  @override
  State<_TabularFiguresProof> createState() => _TabularFiguresProofState();
}

class _TabularFiguresProofState extends State<_TabularFiguresProof> {
  static const _tickInterval = Duration(seconds: 1);

  final _random = Random(7);
  late Timer _timer;
  var _value = 1111.11;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(_tickInterval, (_) {
      setState(() => _value = _random.nextDouble() * 99999);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatted = '\$${_value.toStringAsFixed(2)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(formatted, style: context.typo.balanceLarge),
        const SizedBox(height: AppDimens.space8),
        Text(
          'Chữ số phải đứng yên khi giá trị đổi',
          style:
              context.typo.caption.copyWith(color: context.colors.textSecondary),
        ),
      ],
    );
  }
}

class _AddressProof extends StatelessWidget {
  const _AddressProof();

  static const _address = '0x1388a1d3e0c2b4f5a6d7e8f9a0b1c2d3e4f547cf';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_address, style: context.typo.address),
        const SizedBox(height: AppDimens.space8),
        Text(AppFormat.shortAddress(_address), style: context.typo.address),
        const SizedBox(height: AppDimens.space8),
        Text('0 O o · 1 l I i · 5 S · 8 B', style: context.typo.address),
      ],
    );
  }
}

class _QrSurfaceProof extends StatelessWidget {
  const _QrSurfaceProof();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.qrSurface,
        borderRadius: BorderRadius.circular(AppDimens.radiusMd),
      ),
      child: Icon(Icons.qr_code_2, size: 88, color: context.colors.onQrSurface),
    );
  }
}

/// Renders bundled SVG icons so a broken or invisible-on-dark asset shows up by
/// eye instead of at runtime on a wallet screen.
class _IconGrid extends StatelessWidget {
  const _IconGrid(this.assets);

  static const iconSize = 40.0;
  static const tileSize = 72.0;

  static const networks = <String>[
    'assets/icons/networks/ethereum.svg',
    'assets/icons/networks/base.svg',
    'assets/icons/networks/arbitrum-one.svg',
    'assets/icons/networks/optimism.svg',
    'assets/icons/networks/polygon.svg',
    'assets/icons/networks/binance-smart-chain.svg',
  ];

  static const tokens = <String>[
    'assets/icons/tokens/eth.svg',
    'assets/icons/tokens/usdt.svg',
    'assets/icons/tokens/usdc.svg',
    'assets/icons/tokens/bnb.svg',
    'assets/icons/tokens/arb.svg',
    'assets/icons/tokens/op.svg',
    'assets/icons/tokens/pol.svg',
    'assets/icons/tokens/matic.svg',
  ];

  final List<String> assets;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppDimens.space16,
      runSpacing: AppDimens.space16,
      children: [
        for (final asset in assets)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: tileSize,
                height: tileSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.colors.surface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusSm),
                ),
                child: SvgPicture.asset(
                  asset,
                  width: iconSize,
                  height: iconSize,
                ),
              ),
              const SizedBox(height: AppDimens.space4),
              SizedBox(
                width: tileSize,
                child: Text(
                  asset.split('/').last.replaceAll('.svg', ''),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: context.typo.caption
                      .copyWith(color: context.colors.textSecondary),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _SpacingScale extends StatelessWidget {
  const _SpacingScale();

  static const _steps = <(String, double)>[
    ('space4', AppDimens.space4),
    ('space8', AppDimens.space8),
    ('space12', AppDimens.space12),
    ('space16', AppDimens.space16),
    ('space20', AppDimens.space20),
    ('space24', AppDimens.space24),
    ('space32', AppDimens.space32),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final (name, value) in _steps)
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.space8),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  child: Text(
                    name,
                    style: context.typo.caption
                        .copyWith(color: context.colors.textSecondary),
                  ),
                ),
                Container(
                  width: value,
                  height: 16,
                  color: context.colors.accent,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
