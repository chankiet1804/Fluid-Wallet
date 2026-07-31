import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/theme/app_theme.dart';

void main() {
  // The secure storage plugin talks over a MethodChannel, so the binding has to
  // exist before anything reads a wallet.
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: FluidWalletApp()));
}

class FluidWalletApp extends ConsumerWidget {
  const FluidWalletApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Fluid Wallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      // To eyeball the design tokens, temporarily swap this for a MaterialApp
      // with `DesignGallery` from app/theme as its home.
      routerConfig: ref.watch(routerProvider),
    );
  }
}
