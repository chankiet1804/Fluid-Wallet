import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/theme.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';

/// How long the phrase is allowed to sit on the clipboard.
///
/// The plan overview forbids leaving a mnemonic there indefinitely — every
/// other app on the device can read it. A timeout is a mitigation, not a fix:
/// for this long the phrase really is readable by anything running.
const _clipboardLifetime = Duration(seconds: 60);

Future<void> showRecoveryPhraseSheet(BuildContext context, String walletId) {
  return showAppSheet<void>(
    context,
    (_) => RecoveryPhraseSheet(walletId: walletId),
  );
}

/// Shows the twelve words and offers a single action: copy them.
///
/// Copying is what marks the wallet backed up here. That is a weaker claim than
/// the onboarding flow's word-order challenge — it proves the phrase left the
/// app, not that the user kept it — and it is a deliberate product decision.
class RecoveryPhraseSheet extends ConsumerStatefulWidget {
  const RecoveryPhraseSheet({super.key, required this.walletId});

  final String walletId;

  @override
  ConsumerState<RecoveryPhraseSheet> createState() =>
      _RecoveryPhraseSheetState();
}

class _RecoveryPhraseSheetState extends ConsumerState<RecoveryPhraseSheet> {
  /// Held only while this sheet is mounted, and cleared in [dispose]. It never
  /// goes into a provider — provider state outlives the sheet and shows up in
  /// devtools.
  List<String>? _words;
  bool _failed = false;
  bool _copied = false;

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

  Future<void> _copy() async {
    final words = _words;
    if (words == null || _copied) return;
    final phrase = words.join(' ');

    await Clipboard.setData(ClipboardData(text: phrase));
    await ref
        .read(walletControllerProvider.notifier)
        .markBackedUp(widget.walletId);

    // Not cancelled in dispose on purpose: the clipboard has to be cleaned up
    // whether or not this sheet is still open.
    Timer(_clipboardLifetime, () => _clearClipboard(phrase));

    if (!mounted) return;
    setState(() => _copied = true);
  }

  /// Clears the clipboard only if the phrase is still the thing on it —
  /// otherwise this would wipe whatever the user copied in the meantime.
  static Future<void> _clearClipboard(String phrase) async {
    final current = await Clipboard.getData(Clipboard.kTextPlain);
    if (current?.text != phrase) return;
    await Clipboard.setData(const ClipboardData(text: ''));
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final words = _words;

    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Recovery phrase',
            textAlign: TextAlign.center,
            style: context.typo.titleLarge,
          ),
          const SizedBox(height: AppDimens.space8),
          Text(
            'Write the words in numerical sequence and save them in a safe '
            'place',
            textAlign: TextAlign.center,
            style: context.typo.bodyMedium.copyWith(
              color: colors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimens.space24),
          switch ((words, _failed)) {
            (_, true) => Text(
              'Could not read the recovery phrase.',
              textAlign: TextAlign.center,
              style: context.typo.bodyLarge.copyWith(color: colors.danger),
            ),
            (null, _) => Center(
              child: CircularProgressIndicator(color: colors.accent),
            ),
            (final list?, _) => _PhraseGrid(words: list),
          },
          const SizedBox(height: AppDimens.space24),
          SecondaryButton(
            icon: _copied ? Icons.check : Icons.copy_outlined,
            label: _copied ? 'Copied' : 'Copy',
            onPressed: words != null && !_copied ? _copy : null,
          ),
          if (_copied) ...[
            const SizedBox(height: AppDimens.space12),
            Text(
              'Clipboard clears automatically in '
              '${_clipboardLifetime.inSeconds} seconds.',
              textAlign: TextAlign.center,
              style: context.typo.caption.copyWith(color: colors.warning),
            ),
          ],
          const SizedBox(height: AppDimens.space32),
        ],
      ),
    );
  }
}

/// Two columns numbered down the left, matching the order the words must be
/// written in. Deliberately plainer than the onboarding grid: this sheet is a
/// reference, not a step the user is working through.
class _PhraseGrid extends StatelessWidget {
  const _PhraseGrid({required this.words});

  final List<String> words;

  @override
  Widget build(BuildContext context) {
    final half = (words.length + 1) ~/ 2;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _Column(words: words, start: 0, end: half),
        ),
        const SizedBox(width: AppDimens.space16),
        Expanded(
          child: _Column(words: words, start: half, end: words.length),
        ),
      ],
    );
  }
}

class _Column extends StatelessWidget {
  const _Column({required this.words, required this.start, required this.end});

  final List<String> words;
  final int start;
  final int end;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = start; i < end; i++)
          _WordRow(position: i + 1, word: words[i]),
      ],
    );
  }
}

class _WordRow extends StatelessWidget {
  const _WordRow({required this.position, required this.word});

  final int position;
  final String word;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.space8),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: Text(
              '$position',
              style: context.typo.caption.copyWith(color: colors.textTertiary),
            ),
          ),
          Expanded(child: Text(word, style: context.typo.bodyLarge)),
        ],
      ),
    );
  }
}
