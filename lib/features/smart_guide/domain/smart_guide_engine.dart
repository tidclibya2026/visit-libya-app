import '../../../data/models/guide_intent.dart';

class SmartGuideEngine {
  const SmartGuideEngine();

  GuideIntent? match(String query, List<GuideIntent> intents) {
    final String normalizedQuery = normalize(query);
    if (normalizedQuery.isEmpty) {
      return null;
    }

    GuideIntent? bestMatch;
    int bestScore = 0;
    for (final GuideIntent intent in intents) {
      if (!intent.enabled) {
        continue;
      }

      final int intentScore = score(normalizedQuery, intent);
      if (intentScore > bestScore) {
        bestScore = intentScore;
        bestMatch = intent;
      }
    }

    return bestMatch;
  }

  int score(String query, GuideIntent intent) {
    final String normalizedQuery = normalize(query);
    if (normalizedQuery.isEmpty || !intent.enabled) {
      return 0;
    }

    int total = 0;
    for (final String keyword in <String>[
      ...intent.keywordsAr,
      ...intent.keywordsEn,
    ]) {
      final String normalizedKeyword = normalize(keyword);
      if (normalizedQuery == normalizedKeyword) {
        total += 3;
      } else if (normalizedQuery.contains(normalizedKeyword)) {
        total += 1;
      }
    }
    return total;
  }

  static String normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp('[أإآ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
