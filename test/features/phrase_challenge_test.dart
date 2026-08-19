import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fluid_wallet/features/onboarding/verify_phrase/phrase_challenge.dart';

void main() {
  final words = List.generate(12, (i) => 'word$i');

  test('asks for the requested number of distinct positions', () {
    final challenges = buildPhraseChallenges(words, random: Random(1));
    expect(challenges, hasLength(3));
    expect(challenges.map((c) => c.position).toSet(), hasLength(3));
  });

  test('positions are 1-based and inside the phrase', () {
    for (final c in buildPhraseChallenges(words, random: Random(2))) {
      expect(c.position, greaterThanOrEqualTo(1));
      expect(c.position, lessThanOrEqualTo(words.length));
    }
  });

  test('the answer is the word actually at that position', () {
    for (final c in buildPhraseChallenges(words, random: Random(3))) {
      expect(c.answer, words[c.position - 1]);
    }
  });

  test('options contain the answer and no duplicates', () {
    for (final c in buildPhraseChallenges(words, random: Random(4))) {
      expect(c.options, contains(c.answer));
      expect(c.options.toSet(), hasLength(c.options.length));
      expect(c.options, hasLength(3));
    }
  });

  test(
    'decoys come from the phrase, so options are not guessable by shape',
    () {
      for (final c in buildPhraseChallenges(words, random: Random(5))) {
        for (final option in c.options) {
          expect(words, contains(option));
        }
      }
    },
  );

  test('the answer is not always in the same slot', () {
    final slots = {
      for (var seed = 0; seed < 20; seed++)
        ...buildPhraseChallenges(
          words,
          random: Random(seed),
        ).map((c) => c.options.indexOf(c.answer)),
    };
    expect(slots.length, greaterThan(1));
  });

  test('a phrase shorter than the option count yields nothing', () {
    expect(buildPhraseChallenges(['a', 'b'], random: Random(6)), isEmpty);
  });
}
