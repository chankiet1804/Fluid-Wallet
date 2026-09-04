import 'package:fluid_wallet/app/theme/app_theme.dart';
import 'package:fluid_wallet/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:toastification/toastification.dart';

void main() {
  /// The toast borrows the Navigator's overlay, so the harness needs the same
  /// wrapper-above-MaterialApp shape the app uses in `main.dart`.
  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(
      ToastificationWrapper(
        config: const ToastificationConfig(
          alignment: Alignment.topCenter,
          itemWidth: double.infinity,
        ),
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const Scaffold(body: SizedBox.shrink()),
        ),
      ),
    );
  }

  // `toastification` is a singleton keyed by alignment. Its manager outlives
  // the widget tree, so a manager left over from the previous test would hold
  // an overlay entry that no longer exists and the next toast would go
  // nowhere.
  setUp(() => toastification.managers.clear());

  /// Runs the auto-close out. Without this the 3s timer is still pending when
  /// the tree is torn down and the test fails on that instead of on its
  /// expectations.
  Future<void> drain(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  }

  testWidgets('success renders the title, the subtitle and a tick', (
    tester,
  ) async {
    await pumpApp(tester);

    AppToast.success(title: 'Address copied', subtitle: '0x2170…33F8');
    await tester.pumpAndSettle();

    expect(find.text('Address copied'), findsOneWidget);
    expect(find.text('0x2170…33F8'), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsNothing);

    await drain(tester);
  });

  testWidgets('error renders a cross', (tester) async {
    await pumpApp(tester);

    AppToast.error(title: 'Could not refresh prices');
    await tester.pumpAndSettle();

    expect(find.text('Could not refresh prices'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_rounded), findsNothing);

    await drain(tester);
  });

  testWidgets('without a subtitle only the title is in the tree', (
    tester,
  ) async {
    await pumpApp(tester);

    AppToast.success(title: 'Settings saved');
    await tester.pumpAndSettle();

    expect(find.text('Settings saved'), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);

    await drain(tester);
  });

  testWidgets('closes itself', (tester) async {
    await pumpApp(tester);

    AppToast.success(title: 'Address copied');
    await tester.pumpAndSettle();
    expect(find.text('Address copied'), findsOneWidget);

    await drain(tester);

    expect(find.text('Address copied'), findsNothing);
  });

  testWidgets('swiping up closes it early', (tester) async {
    await pumpApp(tester);

    AppToast.success(title: 'Address copied');
    await tester.pumpAndSettle();

    await tester.fling(find.text('Address copied'), const Offset(0, -300), 1000);
    await tester.pumpAndSettle();

    expect(find.text('Address copied'), findsNothing);
  });
}
