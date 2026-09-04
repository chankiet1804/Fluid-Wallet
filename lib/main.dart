import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

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
    // Above MaterialApp, not inside its `builder`: the wrapper reaches *down*
    // for the Navigator to borrow its overlay, so it has to be an ancestor.
    // The toast itself is still built inside that overlay, below the theme, so
    // `context.colors` resolves there.
    //
    // Full-width toasts on a phone: the default item width is a fixed 400,
    // which is wider than a 360dp screen. Infinity is clamped to the screen by
    // the enclosing constraints, and AppToast adds its own side gutter.
    return ToastificationWrapper(
      config: const ToastificationConfig(
        alignment: Alignment.topCenter,
        itemWidth: double.infinity,
      ),
      child: MaterialApp.router(
        title: 'Fluid Wallet',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        // To eyeball the design tokens, temporarily swap this for a MaterialApp
        // with `DesignGallery` from app/theme as its home.
        routerConfig: ref.watch(routerProvider),
      ),
    );
  }
}
