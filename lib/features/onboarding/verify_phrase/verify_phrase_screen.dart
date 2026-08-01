import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/theme.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';
import 'phrase_challenge.dart';

/// Confirms the user actually wrote the phrase down before the wallet is
/// usable. Passing flips `isBackedUp` and lands on the wallet-ready screen.
class VerifyPhraseScreen extends ConsumerStatefulWidget {
  const VerifyPhraseScreen({super.key, required this.walletId});

  final String walletId;

  @override
  ConsumerState<VerifyPhraseScreen> createState() => _VerifyPhraseScreenState();
}

class _VerifyPhraseScreenState extends ConsumerState<VerifyPhraseScreen> {
  List<PhraseChallenge>? _challenges;
  final Map<int, String> _picked = {};
  bool _wrong = false;
  bool _failedToLoad = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Reads the phrase, derives the questions, and drops it again — only the
  /// challenge words stay in memory, never the ordered phrase.
  Future<void> _load() async {
    final mnemonic = await ref
        .read(walletControllerProvider.notifier)
        .readMnemonic(widget.walletId);
    if (!mounted) return;
    if (mnemonic == null) {
      setState(() => _failedToLoad = true);
      return;
    }
    setState(() {
      _challenges = buildPhraseChallenges(mnemonic.split(' '));
    });
  }

  bool get _allAnswered {
    final challenges = _challenges;
    if (challenges == null || challenges.isEmpty) return false;
    return challenges.every((c) => _picked.containsKey(c.position));
  }

  Future<void> _confirm() async {
    final challenges = _challenges;
    if (challenges == null) return;

    final correct = challenges.every(
      (c) => _picked[c.position] == c.answer,
    );
    if (!correct) {
      setState(() {
        _wrong = true;
        _picked.clear();
      });
      return;
    }

    await ref
        .read(walletControllerProvider.notifier)
        .markBackedUp(widget.walletId);
    if (!mounted) return;
    context.go(AppRoute.walletReady);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final challenges = _challenges;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Confirm your phrase', style: context.typo.titleMedium),
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
              if (_failedToLoad)
                Expanded(
                  child: Center(
                    child: Text(
                      'Could not read the recovery phrase.',
                      style:
                          context.typo.bodyLarge.copyWith(color: colors.danger),
                    ),
                  ),
                )
              else if (challenges == null)
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: colors.accent),
                  ),
                )
              else
                Expanded(
                  child: ListView(
                    children: [
                      Text(
                        'Pick the word that belongs at each position.',
                        style: context.typo.bodyMedium.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      if (_wrong) ...[
                        const SizedBox(height: AppDimens.space16),
                        _WrongBanner(),
                      ],
                      const SizedBox(height: AppDimens.space24),
                      for (final challenge in challenges) ...[
                        _ChallengeBlock(
                          challenge: challenge,
                          selected: _picked[challenge.position],
                          onPick: (word) => setState(() {
                            _picked[challenge.position] = word;
                            _wrong = false;
                          }),
                        ),
                        const SizedBox(height: AppDimens.space24),
                      ],
                    ],
                  ),
                ),
              PrimaryButton(
                label: 'Confirm',
                onPressed: _allAnswered ? _confirm : null,
              ),
              const SizedBox(height: AppDimens.space12),
              SecondaryButton(
                label: 'Show the phrase again',
                onPressed: () => context.go(
                  '${AppRoute.backupPhrase}?walletId=${widget.walletId}',
                ),
              ),
              const SizedBox(height: AppDimens.space16),
            ],
          ),
        ),
      ),
    );
  }
}

class _WrongBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.all(AppDimens.space12),
      decoration: BoxDecoration(
        color: colors.dangerSurface,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, size: 20, color: colors.danger),
          const SizedBox(width: AppDimens.space8),
          Expanded(
            child: Text(
              'That is not the right order. Check your written copy and try '
              'again.',
              style: context.typo.bodyMedium.copyWith(color: colors.danger),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChallengeBlock extends StatelessWidget {
  const _ChallengeBlock({
    required this.challenge,
    required this.selected,
    required this.onPick,
  });

  final PhraseChallenge challenge;
  final String? selected;
  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Word #${challenge.position}',
          style: context.typo.titleMedium,
        ),
        const SizedBox(height: AppDimens.space12),
        Row(
          children: [
            for (final option in challenge.options) ...[
              Expanded(
                child: _OptionChip(
                  label: option,
                  selected: option == selected,
                  onTap: () => onPick(option),
                ),
              ),
              if (option != challenge.options.last)
                const SizedBox(width: AppDimens.space8),
            ],
          ],
        ),
        const SizedBox(height: AppDimens.space4),
        Divider(color: colors.border, height: AppDimens.space16),
      ],
    );
  }
}

class _OptionChip extends StatelessWidget {
  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final radius = BorderRadius.circular(AppDimens.radiusSm);

    return Material(
      color: selected ? colors.successSurface : colors.surface,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(
              color: selected ? colors.success : colors.border,
            ),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.typo.bodyLarge.copyWith(
              color: selected ? colors.success : colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
