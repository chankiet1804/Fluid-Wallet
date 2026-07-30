import 'package:flutter/material.dart';

import 'app/theme/app_theme.dart';
import 'features/onboarding/get_started/get_started.dart';

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
      // Placeholder home until routing lands. To eyeball the design tokens,
      // temporarily swap this for `DesignGallery` from app/theme.
      home: const GetStartedScreen(),
    );
  }
}
