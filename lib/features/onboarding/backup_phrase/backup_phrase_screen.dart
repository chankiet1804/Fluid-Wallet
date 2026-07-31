import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/theme.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';

/// Shows the recovery phrase once, in plain sight.
///
/// The cover-and-tap-to-reveal step was removed on request: the words are shown
/// as soon as the screen opens. Shoulder-surfing is now the user's problem, so
/// this is another reason the build must stay small-funds until `no_screenshot`
/// and FLAG_SECURE land.
///
/// Deliberately missing: a "copy all" button. A full phrase on the clipboard is
/// readable by every other app on the device and outlives the screen. Users
/// write these twelve words down.
///
/// Screenshot blocking is not wired up yet (`no_screenshot` is deferred), so
/// this build must not hold meaningful funds.
class BackupPhraseScreen extends ConsumerStatefulWidget {
  const BackupPhraseScreen({super.key, required this.walletId});

  final String walletId;

  @override
  ConsumerState<BackupPhraseScreen> createState() => _BackupPhraseScreenState();
}

class _BackupPhraseScreenState extends ConsumerState<BackupPhraseScreen> {
  /// Held only while this screen is mounted, and cleared in [dispose]. It never
  /// goes into a provider — provider state outlives the screen and shows up in
  /// devtools.
  List<String>? _words;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final mnemonic = await ref
        .read(walletControllerProvider.notifier)
        .readMnemonic(widget.walletId);
    if (!mounted) return;
    setState(() {
      _words = mnemonic?.split(' ');
      _failed = mnemonic == null;
    });
  }

  @override
  void dispose() {
    _words = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final words = _words;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Recovery phrase', style: context.typo.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.screenPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Write these words down in order and keep them offline. '
                'Anyone who has them can spend your funds, and nobody can '
                'restore them for you.',
                style: context.typo.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimens.space20),
              Expanded(
                child: switch ((words, _failed)) {
                  (_, true) => Center(
                    child: Text(
                      'Could not read the recovery phrase.',
                      style: context.typo.bodyLarge.copyWith(
                        color: colors.danger,
                      ),
                    ),
                  ),
                  (null, _) => Center(
                    child: CircularProgressIndicator(color: colors.accent),
                  ),
                  (final list?, _) => _PhraseGrid(words: list),
                },
              ),
              const SizedBox(height: AppDimens.space16),
              PrimaryButton(
                label: 'I wrote it down',
                // Nothing to confirm until the phrase has actually loaded.
                onPressed: words != null
                    ? () => context.go(
                        '${AppRoute.verifyPhrase}?walletId=${widget.walletId}',
                      )
                    : null,
              ),
              const SizedBox(height: AppDimens.space16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhraseGrid extends StatelessWidget {
  const _PhraseGrid({required this.words});

  final List<String> words;

  @override
  Widget build(BuildContext context) {
    final grid = GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppDimens.space8,
        crossAxisSpacing: AppDimens.space8,
        mainAxisExtent: 48,
      ),
      itemCount: words.length,
      itemBuilder: (context, index) => _WordCell(
        position: index + 1,
        word: words[index],
      ),
    );

    return SingleChildScrollView(child: grid);
  }
}

class _WordCell extends StatelessWidget {
  const _WordCell({required this.position, required this.word});

  final int position;
  final String word;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.space12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$position',
              style: context.typo.caption.copyWith(
                color: colors.textTertiary,
              ),
            ),
          ),
          Expanded(
            child: Text(word, style: context.typo.bodyLarge),
          ),
        ],
      ),
    );
  }
}
