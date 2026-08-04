import 'dart:io';

import 'package:fluid_wallet/data/chain/chain.dart';
import 'package:fluid_wallet/data/repositories/chain_registry_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// `Override` is not part of the main riverpod barrel; misc.dart is where it is
// exported from.
import 'package:flutter_riverpod/misc.dart' show Override;

/// The real shipped registry, read from disk.
///
/// `rootBundle` needs a Flutter binding and an asset manifest; `dart:io` needs
/// neither, and the file is the same one the app ships.
ChainRegistry loadTestChainRegistry() => const ChainRegistryRepository().parse(
  File(ChainRegistryRepository.assetPath).readAsStringSync(),
);

/// Overrides every widget test needs once the portfolio reads live data.
///
/// [portfolio] defaults to an empty successful snapshot. Leaving it unset also
/// stops the balance providers from ever running, which matters: they install a
/// cache-expiry timer, and a pending timer fails the test it outlives.
List<Override> chainTestOverrides({
  AsyncValue<PortfolioSnapshot>? portfolio,
  ChainRegistry? registry,
}) => [
  chainRegistryProvider.overrideWithValue(registry ?? loadTestChainRegistry()),
  currentPortfolioProvider.overrideWithValue(
    portfolio ?? AsyncValue.data(PortfolioSnapshot.empty('0x0')),
  ),
];
