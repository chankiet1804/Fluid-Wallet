import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/theme.dart';
import '../../../shared/widgets/widgets.dart';
import 'widgets/chain_arc.dart';

/// First screen of onboarding: pick between creating a wallet and importing
/// one. Actions are intentionally inert — the key flows land with Phase 1.
class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  /// Centre of the radial glow as a fraction of the body height. The logo and
  /// the arc crest are derived from this same value, so all three layers stay
  /// concentric instead of drifting apart.
  static const _glowCenter = 0.45;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      body: LayoutBuilder(
        builder: (context, bodyConstraints) {
          final glowCenterY = bodyConstraints.maxHeight * _glowCenter;
          // The hero box is the first child of the Column and the only
          // vertical inset above it is the safe area, so this converts the
          // body-space glow centre into hero-space. Adding anything above the
          // hero box breaks it.
          final logoCenterY = glowCenterY - MediaQuery.paddingOf(context).top;

          return DecoratedBox(
            decoration: BoxDecoration(
              // The design is a raster export with no gradient handoff, so the
              // stops are matched by eye against the screenshot.
              gradient: RadialGradient(
                center: const Alignment(0, _glowCenter * 2 - 1),
                radius: 1.1,
                colors: [
                  colors.heroGlowSecondary,
                  colors.heroGlowPrimary,
                  colors.background,
                ],
                stops: const [0.0, 0.45, 1.0],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.screenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 3,
                      // The glow centre sits below the middle of this box, so
                      // the logo may hang a few pixels past it — never clip.
                      child: Stack(
                        fit: StackFit.expand,
                        clipBehavior: Clip.none,
                        children: [
                          ChainArc(crestY: logoCenterY),
                          Positioned(
                            top: logoCenterY - _AppLogo.size / 2,
                            left: 0,
                            right: 0,
                            child: const Center(child: _AppLogo()),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppDimens.space32),
                    Text(
                      'Fluid Wallet',
                      textAlign: TextAlign.center,
                      style: context.typo.displayMedium,
                    ),
                    const Expanded(child: SizedBox.shrink()),
                    PrimaryButton(
                      label: 'Create wallet',
                      onPressed: () => context.push(AppRoute.createWallet),
                    ),
                    const SizedBox(height: AppDimens.space12),
                    SecondaryButton(
                      label: 'Add an existing wallet',
                      onPressed: () => context.push(AppRoute.importWallet),
                    ),
                    const SizedBox(height: AppDimens.space24),
                    const _LegalLinks(),
                    const SizedBox(height: AppDimens.space16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  static const size = 96.0;
  static const _glyphSize = 84.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.colors.qrSurface,
        shape: BoxShape.circle,
      ),
      child: SvgPicture.asset(
        'assets/icons/brand/fluid.svg',
        width: _glyphSize,
        height: _glyphSize,
      ),
    );
  }
}

class _LegalLinks extends StatelessWidget {
  const _LegalLinks();

  @override
  Widget build(BuildContext context) {
    final style = context.typo.bodyMedium.copyWith(
      color: context.colors.accent,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Terms of service', style: style),
        Text('Privacy policy', style: style),
      ],
    );
  }
}
