import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/guide_intent.dart';
import 'package:visit_libya_app/features/smart_guide/domain/smart_guide_engine.dart';

import 'support/smart_guide_test_support.dart';

void main() {
  const SmartGuideEngine engine = SmartGuideEngine();

  test('matches Arabic keywords', () {
    final GuideIntent intent = _intent(
      id: 'heritage',
      keywordsAr: <String>['تراث'],
      keywordsEn: <String>['heritage'],
    );

    expect(engine.match('أريد استكشاف التراث', <GuideIntent>[intent]), intent);
  });

  test('matches English keywords case-insensitively', () {
    final GuideIntent intent = _intent(
      id: 'destinations',
      keywordsAr: <String>['وجهات'],
      keywordsEn: <String>['destinations'],
    );

    expect(engine.match('SHOW DESTINATIONS', <GuideIntent>[intent]), intent);
  });

  test('normalizes Arabic alef whitespace taa and ya variants', () {
    final GuideIntent intent = _intent(
      id: 'normalized',
      keywordsAr: <String>['آثار رحلة على'],
      keywordsEn: <String>['heritage trip'],
    );

    expect(engine.match('  اثار   رحله علي  ', <GuideIntent>[intent]), intent);
  });

  test('ignores disabled intents', () {
    final GuideIntent disabled = _intent(
      id: 'disabled',
      keywordsAr: <String>['وجهات'],
      keywordsEn: <String>['destinations'],
      enabled: false,
    );

    expect(engine.match('destinations', <GuideIntent>[disabled]), isNull);
  });

  test('uses repository order for stable score ties', () {
    final GuideIntent first = _intent(
      id: 'first',
      keywordsAr: <String>['وجهة'],
      keywordsEn: <String>['place'],
    );
    final GuideIntent second = _intent(
      id: 'second',
      keywordsAr: <String>['مكان'],
      keywordsEn: <String>['place'],
    );

    expect(engine.match('place', <GuideIntent>[first, second]), first);
  });

  test('scores exact and contained keyword matches transparently', () {
    final GuideIntent intent = _intent(
      keywordsAr: <String>['وجهات'],
      keywordsEn: <String>['destinations', 'places'],
    );

    expect(engine.score('destinations', intent), 3);
    expect(engine.score('show destinations and places', intent), 2);
  });

  test('returns null for an empty query', () {
    expect(engine.match('   ', <GuideIntent>[_intent()]), isNull);
  });

  test('returns null for an unknown query', () {
    expect(engine.match('unrelated subject', <GuideIntent>[_intent()]), isNull);
  });
}

GuideIntent _intent({
  String id = 'destinations',
  List<String> keywordsAr = const <String>['وجهات'],
  List<String> keywordsEn = const <String>['destinations'],
  bool enabled = true,
}) {
  return GuideIntent.fromJson(
    guideIntentJson(
      id: id,
      keywordsAr: keywordsAr,
      keywordsEn: keywordsEn,
      enabled: enabled,
    ),
  );
}
