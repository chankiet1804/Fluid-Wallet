import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router.dart';
import 'app/theme/app_theme.dart';
import 'data/chain/chain_providers.dart';
import 'data/repositories/chain_registry_repository.dart';

Future<void> main() async {
  // The secure storage plugin talks over a MethodChannel, so the binding has to
  // exist before anything reads a wallet.
  WidgetsFlutterBinding.ensureInitialized();

  // The chain and token registry is the premise of every provider below it, so
  // it is parsed here rather than exposed as a FutureProvider — otherwise every
  // balance, price and widget provider would have to thread an AsyncValue
  // through something that cannot fail after the first load.
  //
  // And when it does fail, failing here is the point: a malformed registry means
  // a wrong address or a wrong `decimals`, and a wallet that starts anyway would
  // show a number that is not the user's balance.
  final registry = await const ChainRegistryRepository().load();

  runApp(
    ProviderScope(
      overrides: [chainRegistryProvider.overrideWithValue(registry)],
      child: const FluidWalletApp(),
    ),
  );
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
