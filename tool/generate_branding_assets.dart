// Rasterises assets/icons/brand/fluid.svg into the PNGs that
// flutter_launcher_icons and flutter_native_splash consume.
//
// Run with:  flutter test tool/generate_branding_assets.dart
//
// It is a widget test only because that is the cheapest way to get a real
// Flutter raster pipeline: the launcher icon then comes out of the exact same
// renderer as the in-app logo, so the two can never drift apart. Re-run it
// after editing fluid.svg, then re-run the two generators.
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

const _source = 'assets/icons/brand/fluid.svg';
const _outDir = 'assets/branding';

/// Splash and adaptive-icon backgrounds are white on purpose — same value as
/// the `qrSurface` token the in-app logo sits on. The brand glyph is blue and
/// only reads on a light surface.
const _white = Color(0xFFFFFFFF);

void main() {
  late String svg;

  setUpAll(() {
    svg = File(_source).readAsStringSync();
    Directory(_outDir).createSync(recursive: true);
  });

  testWidgets('app_icon.png — full-bleed launcher icon', (tester) async {
    // Glyph at 62% leaves the margin iOS and legacy Android expect around a
    // square icon that gets rounded by the OS.
    await _render(
      tester,
      svg,
      canvas: 1024,
      glyph: 635,
      background: _white,
      out: 'app_icon.png',
    );
  });

  testWidgets('app_icon_foreground.png — Android adaptive foreground', (
    tester,
  ) async {
    // Adaptive icons crop to the inner 66% safe zone (676px here) and may be
    // masked to a circle, so the glyph has to stay inside it.
    await _render(
      tester,
      svg,
      canvas: 1024,
      glyph: 600,
      background: null,
      out: 'app_icon_foreground.png',
    );
  });

  testWidgets('splash_icon.png — legacy splash', (tester) async {
    // Consumed as the 4x asset: 512px here lands at roughly 128dp on screen.
    await _render(
      tester,
      svg,
      canvas: 512,
      glyph: 512,
      background: null,
      out: 'splash_icon.png',
    );
  });

  testWidgets('splash_icon_android12.png — Android 12+ splash', (tester) async {
    // Android 12 spec: 1152px canvas, artwork confined to the inner 768px.
    await _render(
      tester,
      svg,
      canvas: 1152,
      glyph: 768,
      background: null,
      out: 'splash_icon_android12.png',
    );
  });
}

/// Paints [svg] at [glyph] px centred on a [canvas] px square and writes the
/// result to [_outDir]/[out]. A null [background] keeps the canvas transparent.
Future<void> _render(
  WidgetTester tester,
  String svg, {
  required double canvas,
  required double glyph,
  required Color? background,
  required String out,
}) async {
  final key = GlobalKey();

  tester.view.physicalSize = Size(canvas, canvas);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    RepaintBoundary(
      key: key,
      child: Container(
        width: canvas,
        height: canvas,
        color: background,
        alignment: Alignment.center,
        child: SvgPicture.string(svg, width: glyph, height: glyph),
      ),
    ),
  );
  await tester.pumpAndSettle();

  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;

  // toImage/toByteData need a real event loop, which only runAsync provides.
  final bytes = await tester.runAsync(() async {
    final image = await boundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    return data!.buffer.asUint8List();
  });

  File('$_outDir/$out').writeAsBytesSync(bytes as Uint8List);
}
