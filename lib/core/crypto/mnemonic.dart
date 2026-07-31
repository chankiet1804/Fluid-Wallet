import 'package:blockchain_utils/blockchain_utils.dart';

/// BIP39 mnemonic generation and validation.
///
/// Nothing here may be logged, printed, or copied into any provider state — a
/// mnemonic is the whole wallet.
class MnemonicService {
  const MnemonicService();

  /// Words a new wallet is created with. 12 words = 128 bits of entropy, which
  /// is what MetaMask and every other consumer wallet default to.
  static const Bip39WordsNum defaultWordsNum = Bip39WordsNum.wordsNum12;

  /// Word counts accepted on import. BIP39 also allows 15/18/21, and rejecting
  /// them would lock out a seed the user legitimately holds.
  static const List<int> acceptedWordCounts = [12, 15, 18, 21, 24];

  String generate({Bip39WordsNum wordsNum = defaultWordsNum}) {
    return Bip39MnemonicGenerator().fromWordsNumber(wordsNum).toStr();
  }

  /// Full BIP39 check: word count, wordlist membership, and checksum.
  ///
  /// Word count alone is not validation — a phrase can be 12 valid words and
  /// still fail the checksum, in which case it belongs to nobody.
  bool isValid(String mnemonic) {
    final normalized = normalize(mnemonic);
    if (normalized.isEmpty) return false;
    return Bip39MnemonicValidator().isValid(normalized);
  }

  /// Trims, lowercases, and collapses runs of whitespace so a phrase pasted
  /// with newlines or double spaces still validates.
  String normalize(String mnemonic) {
    return mnemonic.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  List<String> words(String mnemonic) {
    final normalized = normalize(mnemonic);
    if (normalized.isEmpty) return const [];
    return normalized.split(' ');
  }
}
