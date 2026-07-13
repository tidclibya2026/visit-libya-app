import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/guide_intent.dart';
import 'package:visit_libya_app/data/repositories/guide_repository.dart';

import 'support/smart_guide_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const List<String> approvedIds = <String>[
    'destinations',
    'heritage',
    'desert',
    'coast',
    'trip-planning',
    'events',
    'routes',
    'before-travel',
  ];

  test('loads exactly eight guide intents', () async {
    const GuideRepository repository = GuideRepository();

    final List<GuideIntent> intents = await repository.loadIntents();

    expect(intents, hasLength(8));
  });

  test('loads the exact approved unique guide intent IDs', () async {
    const GuideRepository repository = GuideRepository();

    final List<String> ids = (await repository.loadIntents())
        .map((GuideIntent intent) => intent.id)
        .toList();

    expect(ids, approvedIds);
    expect(ids.toSet(), hasLength(approvedIds.length));
  });

  test('rejects empty non-array non-object and duplicate datasets', () async {
    final List<String> invalidDatasets = <String>[
      '[]',
      '{}',
      '["invalid"]',
      jsonEncode(<Map<String, dynamic>>[
        guideIntentJson(id: 'duplicate'),
        guideIntentJson(id: 'duplicate'),
      ]),
    ];

    for (final String dataset in invalidDatasets) {
      final GuideRepository repository = GuideRepository(
        assetBundle: TrackingGuideAssetBundle(dataset),
      );
      await expectLater(
        repository.loadIntents(),
        throwsA(isA<FormatException>()),
        reason: dataset,
      );
    }
  });

  test('returns an unmodifiable guide intent list', () async {
    const GuideRepository repository = GuideRepository();

    final List<GuideIntent> intents = await repository.loadIntents();

    expect(() => intents.removeLast(), throwsUnsupportedError);
  });
}
