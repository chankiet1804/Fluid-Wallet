import 'dart:math';

/// One "which word was at position N?" question.
class PhraseChallenge {
  const PhraseChallenge({
    required this.position,
    required this.options,
    required this.answer,
  });

  /// 1-based, matching what the backup screen showed.
  final int position;
  final List<String> options;
  final String answer;
}

/// Builds the verification quiz.
///
/// Asking for a few positions rather than the whole phrase is a deliberate
/// trade: re-typing twelve words trains people to paste from a screenshot,
/// which is the habit this screen exists to discourage.
List<PhraseChallenge> buildPhraseChallenges(
  List<String> words, {
  int questions = 3,
  int optionsPerQuestion = 3,
  Random? random,
}) {
  final rng = random ?? Random.secure();
  if (words.length < optionsPerQuestion) return const [];

  final count = min(questions, words.length);
  final positions = <int>{};
  while (positions.length < count) {
    positions.add(rng.nextInt(words.length));
  }

  final ordered = positions.toList()..sort();
  return [
    for (final index in ordered)
      PhraseChallenge(
        position: index + 1,
        answer: words[index],
        options: _optionsFor(
          words,
          answerIndex: index,
          total: optionsPerQuestion,
          rng: rng,
        ),
      ),
  ];
}

/// Decoys come from the phrase itself: an option list of one real word and two
/// obvious outsiders would be guessable without ever reading the phrase.
List<String> _optionsFor(
  List<String> words, {
  required int answerIndex,
  required int total,
  required Random rng,
}) {
  final answer = words[answerIndex];
  final pool = <String>{answer};

  final candidates = words.toSet().toList()..shuffle(rng);
  for (final word in candidates) {
    if (pool.length >= total) break;
    pool.add(word);
  }

  return pool.toList()..shuffle(rng);
}
