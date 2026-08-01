import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';
import '../../../app/theme/theme.dart';
import 'import_phrase_form.dart';

/// Imports an existing recovery phrase during onboarding.
///
/// The field, its validation, and the import call live in [ImportPhraseForm] —
/// the add-wallet sheet inside the app hosts the same form.
class ImportWalletScreen extends ConsumerWidget {
  const ImportWalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

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
          child: ImportPhraseForm(
            expand: true,
            onImported: () => context.go(AppRoute.walletReady),
          ),
        ),
      ),
    );
  }
}
