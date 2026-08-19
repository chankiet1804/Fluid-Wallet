import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_wallet/app/theme/theme.dart';

void main() {
  group('AppTheme', () {
    test('registers both token extensions', () {
      final theme = AppTheme.dark;

      expect(theme.extension<AppColors>(), isNotNull);
      expect(theme.extension<AppTypography>(), isNotNull);
    });

    test('color scheme is wired to tokens, not Material defaults', () {
      final scheme = AppTheme.dark.colorScheme;

      expect(scheme.primary, AppColors.dark.accent);
      expect(scheme.error, AppColors.dark.danger);
      expect(scheme.surface, AppColors.dark.surface);
    });

    testWidgets('context accessors resolve the registered tokens', (
      tester,
    ) async {
      late AppColors colors;
      late AppTypography typo;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark,
          home: Builder(
            builder: (context) {
              colors = context.colors;
              typo = context.typo;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(colors.accent, AppColors.dark.accent);
      expect(typo.address.fontFamily, 'JetBrainsMono');
    });
  });

  group('AppTypography', () {
    // Without tabular figures a live-updating balance shifts horizontally on
    // every refresh.
    test('every numeric style uses tabular figures', () {
      const t = AppTypography.standard;

      for (final style in [t.balanceLarge, t.amountMedium, t.numericInput]) {
        expect(
          style.fontFeatures,
          contains(const FontFeature.tabularFigures()),
          reason: 'numeric styles must keep a fixed digit advance',
        );
      }
    });

    test('address style is monospace', () {
      expect(AppTypography.standard.address.fontFamily, 'JetBrainsMono');
    });

    // A hero title renders words, not amounts — tabular figures here would
    // only widen the spacing for nothing.
    test('displayMedium is a text style, not a numeric one', () {
      final style = AppTypography.standard.displayMedium;

      expect(style.fontSize, 32);
      expect(style.fontFeatures ?? const [], isEmpty);
    });
  });

  group('AppColors', () {
    // Guards against a copy-paste that leaves the glow equal to the backdrop,
    // which would silently flatten the onboarding gradient.
    test('hero glow tokens differ from the background', () {
      const c = AppColors.dark;

      expect(c.heroGlowPrimary, isNot(c.background));
      expect(c.heroGlowSecondary, isNot(c.background));
      expect(c.heroGlowPrimary, isNot(c.heroGlowSecondary));
    });
  });

  group('AppFormat.shortAddress', () {
    test('shortens a full address', () {
      expect(
        AppFormat.shortAddress('0x1388a1d3e0c2b4f5a6d7e8f9a0b1c2d3e4f547cf'),
        '0x1388…47cf',
      );
    });

    // A malformed value must stay visible rather than be disguised as valid.
    test('returns short input untouched', () {
      expect(AppFormat.shortAddress('0x1388'), '0x1388');
    });
  });
}
