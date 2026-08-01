import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/theme.dart';
import '../../../core/crypto/mnemonic.dart';
import '../../../data/repositories/wallet_repository.dart';
import '../../../data/wallet_providers.dart';
import '../../../shared/widgets/widgets.dart';

/// Imports an existing recovery phrase.
///
/// Validation is the full BIP39 check — wordlist plus checksum — run on every
/// keystroke. Counting words is not validation: twelve real words with a bad
/// checksum belong to no wallet, and telling the user it looks fine is how a
/// mistyped phrase turns into "my funds vanished".
class ImportWalletScreen extends ConsumerStatefulWidget {
  const ImportWalletScreen({super.key});

  @override
  ConsumerState<ImportWalletScreen> createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends ConsumerState<ImportWalletScreen> {
  static const _mnemonicService = MnemonicService();

  final _controller = TextEditingController();
  bool _valid = false;
  bool _touched = false;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    // Clears the phrase out of the field's buffer when leaving the screen.
    _controller.clear();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    setState(() {
      _touched = value.trim().isNotEmpty;
      _valid = _mnemonicService.isValid(value);
      _error = null;
    });
  }

  Future<void> _import() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref
          .read(walletControllerProvider.notifier)
          .importWallet(_controller.text);
      if (!mounted) return;
      context.go(AppRoute.walletReady);
    } on InvalidMnemonicException {
      _fail('That recovery phrase is not valid. Check the words and order.');
    } on DuplicateWalletException {
      _fail('This wallet is already in the app.');
    } catch (_) {
      _fail('Could not import the wallet. Please try again.');
    }
  }

  void _fail(String message) {
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final wordCount = _mnemonicService.words(_controller.text).length;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Import wallet', style: context.typo.titleMedium),
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
                'Enter your 12 or 24 word recovery phrase, separated by '
                'spaces.',
                style: context.typo.bodyMedium.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimens.space20),
              _PhraseField(controller: _controller, onChanged: _onChanged),
              const SizedBox(height: AppDimens.space12),
              _StatusLine(
                touched: _touched,
                valid: _valid,
                wordCount: wordCount,
                error: _error,
              ),
              const Spacer(),
              PrimaryButton(
                label: _busy ? 'Importing…' : 'Import wallet',
                // Enabled only once the checksum passes.
                onPressed: _valid && !_busy ? _import : null,
              ),
              const SizedBox(height: AppDimens.space16),
            ],
          ),
        ),
      ),
    );
  }
}

class _PhraseField extends StatelessWidget {
  const _PhraseField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      maxLines: 4,
      autocorrect: false,
      enableSuggestions: false,
      // Keeps the phrase out of the keyboard's learned-words dictionary.
      keyboardType: TextInputType.visiblePassword,
      style: context.typo.bodyLarge,
      decoration: InputDecoration(
        filled: true,
        fillColor: colors.surface,
        hintText: 'ripple gadget ocean …',
        hintStyle: context.typo.bodyLarge.copyWith(color: colors.textTertiary),
        contentPadding: const EdgeInsets.all(AppDimens.space16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          borderSide: BorderSide(color: colors.accent),
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    required this.touched,
    required this.valid,
    required this.wordCount,
    required this.error,
  });

  final bool touched;
  final bool valid;
  final int wordCount;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (error != null) {
      return _Line(icon: Icons.error_outline, color: colors.danger, text: error!);
    }
    if (!touched) return const SizedBox(height: 20);
    if (valid) {
      return _Line(
        icon: Icons.check_circle_outline,
        color: colors.success,
        text: 'Valid recovery phrase',
      );
    }
    // Distinguishes "not finished typing" from "finished and wrong", so a
    // complete phrase failing its checksum reads as an error rather than as
    // progress.
    final complete = MnemonicService.acceptedWordCounts.contains(wordCount);
    return _Line(
      icon: complete ? Icons.error_outline : Icons.more_horiz,
      color: complete ? colors.danger : colors.textSecondary,
      text: complete
          ? 'These words do not form a valid phrase'
          : '$wordCount ${wordCount == 1 ? 'word' : 'words'} so far',
    );
  }
}

class _Line extends StatelessWidget {
  const _Line({required this.icon, required this.color, required this.text});

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: AppDimens.space8),
        Expanded(
          child: Text(
            text,
            style: context.typo.bodyMedium.copyWith(color: color),
          ),
        ),
      ],
    );
  }
}
