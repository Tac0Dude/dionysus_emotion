import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

const _sentencesAssetPath = 'docs/sentences.txt';

const _knownEmotions = <String>{
  'Joie',
  'Fierté',
  'Admiration',
  'Intérêt',
  'Amusement',
  'Plaisir',
  'Contentement',
  'Amour',
  'Soulagement',
  'Compassion',
  'Colère',
  'Mépris',
  'Haine',
  'Dégoût',
  'Honte',
  'Tristesse',
  'Culpabilité',
  'Regret',
  'Déception',
  'Peur',
};

Map<String, List<String>> _parseSentences(String raw) {
  final result = <String, List<String>>{};
  String? current;
  for (final line in raw.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;
    if (_knownEmotions.contains(trimmed)) {
      current = trimmed;
      result.putIfAbsent(current, () => <String>[]);
    } else if (current != null) {
      result[current]!.add(trimmed);
    }
  }
  return result;
}

final sentencesProvider = FutureProvider<Map<String, List<String>>>((ref) async {
  final raw = await rootBundle.loadString(_sentencesAssetPath);
  return _parseSentences(raw);
});

String pickSentenceFor(
  Map<String, List<String>> sentences,
  String emotionName, {
  Random? random,
}) {
  final list = sentences[emotionName];
  if (list == null || list.isEmpty) {
    return 'Tu fais déjà beaucoup. Sois doux·ce avec toi-même.';
  }
  final rng = random ?? Random();
  return list[rng.nextInt(list.length)];
}
