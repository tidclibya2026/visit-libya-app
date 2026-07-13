import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/guide_intent.dart';

import 'support/smart_guide_test_support.dart';

void main() {
  test('parses a valid bilingual guide intent', () {
    final GuideIntent intent = GuideIntent.fromJson(guideIntentJson());

    expect(intent.id, 'destinations');
    expect(intent.category, 'test');
    expect(intent.keywordsAr, <String>['وجهات']);
    expect(intent.keywordsEn, <String>['destinations']);
    expect(intent.actionType, GuideActionType.openTab);
    expect(intent.actionValue, 'destinations');
    expect(intent.enabled, isTrue);
  });

  test('provides Arabic and English prompt and answer helpers', () {
    final GuideIntent intent = GuideIntent.fromJson(guideIntentJson());

    expect(intent.prompt(const Locale('ar')), 'ما الوجهات المتاحة؟');
    expect(intent.answer(const Locale('ar')), 'إجابة عربية.');
    expect(
      intent.prompt(const Locale('en')),
      'Which destinations are available?',
    );
    expect(intent.answer(const Locale('en')), 'English answer.');
  });

  test('parses all guide action types', () {
    const Map<String, GuideActionType> actionTypes = <String, GuideActionType>{
      'openTab': GuideActionType.openTab,
      'openScreen': GuideActionType.openScreen,
      'none': GuideActionType.none,
    };

    for (final MapEntry<String, GuideActionType> entry in actionTypes.entries) {
      final GuideIntent intent = GuideIntent.fromJson(
        guideIntentJson(
          actionType: entry.key,
          actionValue: entry.value == GuideActionType.none ? '' : 'target',
        ),
      );
      expect(intent.actionType, entry.value, reason: entry.key);
    }
  });

  test('rejects an unknown guide action type', () {
    expect(
      () => GuideIntent.fromJson(guideIntentJson(actionType: 'remote')),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects invalid required strings and enabled values', () {
    const List<String> requiredStrings = <String>[
      'id',
      'category',
      'promptAr',
      'promptEn',
      'answerAr',
      'answerEn',
      'actionType',
    ];

    for (final String field in requiredStrings) {
      final Map<String, dynamic> json = guideIntentJson()..[field] = ' ';
      expect(
        () => GuideIntent.fromJson(json),
        throwsA(isA<FormatException>()),
        reason: field,
      );
    }

    expect(
      () => GuideIntent.fromJson(guideIntentJson()..['enabled'] = 'true'),
      throwsA(isA<FormatException>()),
    );
  });

  test('requires an action value for navigation actions', () {
    expect(
      () => GuideIntent.fromJson(guideIntentJson(actionValue: '')),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects empty bilingual keyword lists', () {
    for (final String field in <String>['keywordsAr', 'keywordsEn']) {
      final Map<String, dynamic> json = guideIntentJson()..[field] = <String>[];
      expect(
        () => GuideIntent.fromJson(json),
        throwsA(isA<FormatException>()),
        reason: field,
      );
    }
  });

  test('removes normalized duplicate keywords in stable order', () {
    final GuideIntent intent = GuideIntent.fromJson(
      guideIntentJson(
        keywordsAr: <String>['آثار', 'اثار', 'تراث'],
        keywordsEn: <String>['Heritage', ' heritage ', 'HERITAGE', 'culture'],
      ),
    );

    expect(intent.keywordsAr, <String>['آثار', 'تراث']);
    expect(intent.keywordsEn, <String>['Heritage', 'culture']);
  });

  test('defensively copies and protects keyword lists', () {
    final List<String> keywordsAr = <String>['وجهات'];
    final List<String> keywordsEn = <String>['destinations'];
    final GuideIntent intent = GuideIntent(
      id: 'destinations',
      category: 'test',
      promptAr: 'ما الوجهات؟',
      promptEn: 'Which destinations?',
      keywordsAr: keywordsAr,
      keywordsEn: keywordsEn,
      answerAr: 'إجابة.',
      answerEn: 'Answer.',
      actionType: GuideActionType.openTab,
      actionValue: 'destinations',
      enabled: true,
    );

    keywordsAr.add('مدن');
    keywordsEn.add('cities');

    expect(intent.keywordsAr, <String>['وجهات']);
    expect(intent.keywordsEn, <String>['destinations']);
    expect(() => intent.keywordsAr.add('أماكن'), throwsUnsupportedError);
  });
}
