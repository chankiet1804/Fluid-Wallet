import 'package:flutter/material.dart';

import 'app/theme/app_theme.dart';
import 'app/theme/design_gallery.dart';

void main() {
  runApp(const FluidWalletApp());
}

class FluidWalletApp extends StatelessWidget {
  const FluidWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluid Wallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      // Placeholder home until routing lands — the gallery is how the tokens
      // get checked by eye.
      home: const DesignGallery(),
    );
  }
}
