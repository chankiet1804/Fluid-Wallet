import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../chain/chain_config_dto.dart';
import '../chain/chain_registry.dart';

/// Loads the chain and token registry.
///
/// A repository rather than a bare parse call so that moving to a fetched and
/// cached remote list later is a change inside this class: the return type stays
/// [ChainRegistry] and the whole provider graph above it is unaffected.
class ChainRegistryRepository {
  const ChainRegistryRepository();

  static const String assetPath = 'assets/config/chains-default.json';

  /// Reads and validates the bundled registry.
  ///
  /// Throws — [RegistryFormatException] for bad data, [FormatException] for bad
  /// JSON. Both are deliberately fatal at startup: a wallet that quietly drops a
  /// chain or a token shows a smaller balance than the user actually has.
  Future<ChainRegistry> load() async {
    final raw = await rootBundle.loadString(assetPath);
    return parse(raw);
  }

  /// Split out so tests can read the same file from disk without a Flutter
  /// binding, and so a future remote body goes through identical validation.
  ChainRegistry parse(String jsonText) {
    final decoded = jsonDecode(jsonText);
    if (decoded is! List) {
      throw const RegistryFormatException(
        'chains-default.json must be a JSON array of chains',
      );
    }

    final dtos = <ChainConfigDto>[];
    for (var i = 0; i < decoded.length; i++) {
      final entry = decoded[i];
      if (entry is! Map<String, dynamic>) {
        throw RegistryFormatException('chain entry $i is not an object');
      }
      dtos.add(ChainConfigDto.fromJson(entry));
    }

    return ChainRegistry.fromDtos(dtos);
  }
}
