import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/theme.dart';
import 'widgets/widgets.dart';

/// Settings hub.
///
/// The layout is final; the destinations are not. Every row except the wallet
/// card and the Face ID switch has a null `onTap` — the screens behind them
/// land one at a time, and each will be wired here.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  /// Screen-local and deliberately not persisted.
  ///
  /// This is **not** biometric protection. The real gate is `local_auth`
  /// wrapping `readMnemonic()`, and until that exists this switch changes
  /// nothing about how the wallet is unlocked. Do not read it as "Face ID is
  /// on" anywhere else in the app.
  bool _faceId = true;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        title: Text('Settings', style: context.typo.titleMedium),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimens.screenPadding,
            AppDimens.space8,
            AppDimens.screenPadding,
            AppDimens.space32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SettingsWalletCard(),
              const SizedBox(height: AppDimens.space16),
              SettingsGroup(
                children: [
                  const SettingsTile(
                    icon: Icons.vpn_key_outlined,
                    title: 'Backup',
                  ),
                  const SettingsTile(
                    icon: Icons.notifications_none,
                    title: 'Notifications',
                  ),
                  // Placeholder value: display currency is not stored yet.
                  const SettingsTile(
                    icon: Icons.attach_money,
                    title: 'Currency',
                    value: 'USD',
                  ),
                  SettingsSwitchTile(
                    icon: Icons.emoji_emotions_outlined,
                    title: 'Face ID',
                    value: _faceId,
                    onChanged: (value) => setState(() => _faceId = value),
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.space16),
              const SettingsGroup(
                children: [
                  SettingsTile(icon: Icons.apps_outlined, title: 'App icon'),
                  // Placeholder value: localisation is not wired up yet.
                  SettingsTile(
                    icon: Icons.translate,
                    title: 'Language',
                    value: 'English',
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.space16),
              const SettingsGroup(
                children: [
                  SettingsTile(
                    icon: Icons.chat_bubble_outline,
                    title: 'Feedback',
                  ),
                  SettingsTile(
                    icon: Icons.lock_outline,
                    title: 'Privacy',
                    trailing: SettingsTileTrailing.externalLink,
                  ),
                  SettingsTile(
                    icon: Icons.alternate_email,
                    title: 'Follow us on Twitter',
                    trailing: SettingsTileTrailing.externalLink,
                  ),
                  SettingsTile(
                    icon: Icons.description_outlined,
                    title: 'Terms of Service',
                    trailing: SettingsTileTrailing.externalLink,
                  ),
                ],
              ),
              const SizedBox(height: AppDimens.space24),
              // TODO: read from package_info_plus once the dependency lands.
              Text(
                'Version 1.0.0',
                textAlign: TextAlign.center,
                style: context.typo.caption.copyWith(
                  color: colors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
