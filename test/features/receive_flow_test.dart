import 'package:fluid_wallet/app/router.dart';
import 'package:fluid_wallet/app/theme/theme.dart';
import 'package:fluid_wallet/core/security/secure_store.dart';
import 'package:fluid_wallet/data/chain/chain.dart';
import 'package:fluid_wallet/data/repositories/wallet_repository.dart';
import 'package:fluid_wallet/data/wallet_providers.dart';
import 'package:fluid_wallet/features/receive/receive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:toastification/toastification.dart';

import '../support/fake_secure_storage.dart';
import '../support/test_chain_registry.dart';

/// What this file protects: the QR encodes the account address, exactly, and
/// nothing renders a code when there is no address to encode.
void main() {
  const polygon = 137;
  const base = 8453;

  late FakeSecureStorage funded;
  late FakeSecureStorage empty;
  late ChainRegistry registry;

  setUpAll(() => registry = loadTestChainRegistry());

  // Seeded here, not inside a test body: createWallet derives on a spawned
  // isolate, and a `testWidgets` fake async zone never pumps the real event
  // loop, so the reply would never arrive.
  setUp(() async {
    // The toastification singleton keeps a manager per alignment that outlives
    // the widget tree; a leftover one points at an overlay that is already gone.
    toastification.managers.clear();
    empty = FakeSecureStorage();
    funded = FakeSecureStorage();
    await WalletRepository(
      secureStore: SecureStore(funded),
      storage: funded,
    ).createWallet();
  });

  Future<ProviderContainer> container({bool withWallet = true}) async {
    final container = ProviderContainer(
      overrides: [
        secureStorageProvider.overrideWithValue(withWallet ? funded : empty),
        ...chainTestOverrides(registry: registry),
      ],
    );
    addTearDown(container.dispose);

    // The controller reads the keystore asynchronously; the screens need an
    // answer before they render anything but their empty state.
    await container.read(walletControllerProvider.future);
    return container;
  }

  Future<ProviderContainer> pump(
    WidgetTester tester,
    Widget home, {
    bool withWallet = true,
  }) async {
    final c = await container(withWallet: withWallet);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: c,
        // Same shape as main.dart: copying the address fires an AppToast, and
        // the toast borrows the Navigator's overlay through this wrapper.
        child: ToastificationWrapper(
          child: MaterialApp(theme: AppTheme.dark, home: home),
        ),
      ),
    );
    await tester.pump();
    return c;
  }

  // `QrImageView` keeps its payload private, so the assertion lands on the
  // widget that decides it instead.
  String qrPayload(WidgetTester tester) =>
      tester.widget<AddressQr>(find.byType(AddressQr)).address;

  group('the network step', () {
    testWidgets('lists every enabled chain and offers no "all networks" '
        'shortcut', (tester) async {
      // The list is lazy: on the default 800x600 surface the last chains are
      // never built, and the assertion would pass or fail on viewport height
      // rather than on the registry.
      tester.view.physicalSize = const Size(1000, 2400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await pump(tester, const ReceiveNetworkScreen());

      for (final chain in registry.chains) {
        expect(find.text(chain.name), findsOneWidget);
      }
      expect(find.text('All networks'), findsNothing);
    });

    testWidgets('picking a chain opens the QR for that chain id', (
      tester,
    ) async {
      final c = await container();

      final router = GoRouter(
        initialLocation: AppRoute.receiveNetwork,
        routes: [
          GoRoute(
            path: AppRoute.receiveNetwork,
            builder: (_, _) => const ReceiveNetworkScreen(),
          ),
          GoRoute(
            path: AppRoute.receiveQr,
            builder: (_, state) => ReceiveQrScreen(
              chainId:
                  int.tryParse(state.uri.queryParameters['chainId'] ?? '') ?? 0,
            ),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: c,
          child: MaterialApp.router(
            theme: AppTheme.dark,
            routerConfig: router,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text(registry.chain(polygon)!.name));
      await tester.pumpAndSettle();

      expect(find.byType(AddressQr), findsOneWidget);
      expect(find.textContaining(registry.chain(polygon)!.name), findsWidgets);
    });
  });

  group('the QR step', () {
    // The test that catches a future refactor "normalising" the address: an
    // EIP-55 string carries its checksum in the letter casing.
    testWidgets('encodes the checksummed address verbatim', (tester) async {
      final c = await pump(tester, const ReceiveQrScreen(chainId: polygon));

      final address = c.read(currentAccountProvider)!.address;
      expect(qrPayload(tester), address);
    });

    // The chain only decorates this screen. If it ever reaches the payload,
    // codes stop being readable by wallets that expect a bare address.
    testWidgets('encodes the same payload whichever network was picked', (
      tester,
    ) async {
      await pump(tester, const ReceiveQrScreen(chainId: polygon));
      final onPolygon = qrPayload(tester);

      await pump(tester, const ReceiveQrScreen(chainId: base));
      expect(qrPayload(tester), onPolygon);
    });

    testWidgets('names the picked network in the warning', (tester) async {
      await pump(tester, const ReceiveQrScreen(chainId: polygon));

      expect(
        find.textContaining(registry.chain(polygon)!.name),
        findsWidgets,
      );
      expect(find.textContaining(registry.chain(base)!.name), findsNothing);
    });

    // A QR of an empty string is still a scannable code — an address that
    // belongs to nobody. There must be no code at all here.
    testWidgets('renders no code when there is no wallet', (tester) async {
      await pump(
        tester,
        const ReceiveQrScreen(chainId: polygon),
        withWallet: false,
      );

      expect(find.byType(AddressQr), findsNothing);
      expect(find.byType(QrImageView), findsNothing);
      expect(find.text('No wallet yet.'), findsOneWidget);
    });

    testWidgets('renders no code for a chain id the registry does not know', (
      tester,
    ) async {
      await pump(tester, const ReceiveQrScreen(chainId: 0));

      expect(find.byType(AddressQr), findsNothing);
      expect(find.byType(QrImageView), findsNothing);
      expect(find.text('Unsupported network.'), findsOneWidget);
    });

    testWidgets('shows every character of the address across two lines', (
      tester,
    ) async {
      final c = await pump(tester, const ReceiveQrScreen(chainId: polygon));
      final address = c.read(currentAccountProvider)!.address;

      final lines = AppFormat.addressLines(address);
      expect(lines.join(), address);
      for (final line in lines) {
        expect(find.text(line), findsOneWidget);
      }
    });

    testWidgets('renders the address in the monospace address token', (
      tester,
    ) async {
      final c = await pump(tester, const ReceiveQrScreen(chainId: polygon));
      final address = c.read(currentAccountProvider)!.address;

      final line = tester.widget<Text>(
        find.text(AppFormat.addressLines(address).first),
      );
      expect(line.style?.fontFamily, 'JetBrainsMono');
    });

    testWidgets('copies the whole address and says so', (tester) async {
      final c = await pump(tester, const ReceiveQrScreen(chainId: polygon));
      final address = c.read(currentAccountProvider)!.address;

      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            copied = call.arguments['text'] as String;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      await tester.tap(find.text('Copy'));
      await tester.pump();

      expect(copied, address);
      expect(find.text('Copied'), findsOneWidget);

      // The toast animates in from the overlay, so it needs its frames.
      await tester.pumpAndSettle();
      expect(find.text('Copied Successfully'), findsOneWidget);

      // Also proves the timer does not outlive the widget, which would fail
      // the test the moment it fired.
      await tester.pump(const Duration(seconds: 2, milliseconds: 100));
      expect(find.text('Copy'), findsOneWidget);

      // Run the toast's own auto-close out too, or its timer is still pending
      // when the tree is torn down.
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('Copied Successfully'), findsNothing);
    });
  });
}
