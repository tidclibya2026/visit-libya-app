import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

String guideIntentsJson() {
  return jsonEncode(<Map<String, dynamic>>[
    guideIntentJson(
      id: 'destinations',
      promptAr: 'ما الوجهات المتاحة؟',
      promptEn: 'Which destinations are available?',
      keywordsAr: <String>['وجهات', 'وجهة'],
      keywordsEn: <String>['destinations', 'destination'],
      answerAr: 'افتح قسم الوجهات لاستكشاف الأماكن المتاحة.',
      answerEn: 'Open Destinations to explore the available places.',
      actionType: 'openTab',
      actionValue: 'destinations',
    ),
    guideIntentJson(
      id: 'heritage',
      promptAr: 'أين أجد التراث؟',
      promptEn: 'Where can I find heritage?',
      keywordsAr: <String>['تراث', 'آثار'],
      keywordsEn: <String>['heritage', 'archaeology'],
      answerAr: 'استكشف تجارب التراث داخل التطبيق.',
      answerEn: 'Explore heritage experiences in the app.',
      actionType: 'openTab',
      actionValue: 'explore',
    ),
    guideIntentJson(
      id: 'desert',
      promptAr: 'كيف أستكشف الصحراء؟',
      promptEn: 'How can I explore the desert?',
      keywordsAr: <String>['صحراء', 'مغامرة'],
      keywordsEn: <String>['desert', 'adventure'],
      answerAr: 'استكشف تجارب الصحراء والمغامرة.',
      answerEn: 'Explore desert and adventure experiences.',
      actionType: 'openTab',
      actionValue: 'explore',
    ),
    guideIntentJson(
      id: 'coast',
      promptAr: 'أين أجد الساحل والبحر؟',
      promptEn: 'Where can I find coast and sea experiences?',
      keywordsAr: <String>['ساحل', 'بحر'],
      keywordsEn: <String>['coast', 'sea'],
      answerAr: 'استكشف تجارب الساحل والبحر.',
      answerEn: 'Explore coast and sea experiences.',
      actionType: 'openTab',
      actionValue: 'explore',
    ),
    guideIntentJson(
      id: 'trip-planning',
      promptAr: 'كيف أخطط رحلتي؟',
      promptEn: 'How can I plan my trip?',
      keywordsAr: <String>['تخطيط', 'رحلة'],
      keywordsEn: <String>['planning', 'trip'],
      answerAr: 'استخدم قسم التخطيط لإنشاء برنامج مقترح.',
      answerEn: 'Use Plan to create a suggested itinerary.',
      actionType: 'openTab',
      actionValue: 'plan',
    ),
    guideIntentJson(
      id: 'events',
      promptAr: 'ما الفعاليات المتاحة؟',
      promptEn: 'Which events are available?',
      keywordsAr: <String>['فعاليات', 'أحداث'],
      keywordsEn: <String>['events', 'highlights'],
      answerAr: 'افتح قسم الأحداث والفعاليات.',
      answerEn: 'Open Events and Highlights.',
      actionType: 'openScreen',
      actionValue: 'events',
    ),
    guideIntentJson(
      id: 'routes',
      promptAr: 'ما المسارات المتاحة؟',
      promptEn: 'Which routes are available?',
      keywordsAr: <String>['مسارات', 'مسار'],
      keywordsEn: <String>['routes', 'route'],
      answerAr: 'افتح المسارات السياحية المتاحة.',
      answerEn: 'Open the available tourist routes.',
      actionType: 'openScreen',
      actionValue: 'routes',
    ),
    guideIntentJson(
      id: 'before-travel',
      promptAr: 'ماذا أراجع قبل السفر؟',
      promptEn: 'What should I verify before travel?',
      keywordsAr: <String>['قبل السفر', 'متطلبات'],
      keywordsEn: <String>['before travel', 'requirements'],
      answerAr: 'تحقق من الجهات الرسمية المختصة قبل السفر.',
      answerEn: 'Verify requirements with the relevant official authorities.',
      actionType: 'openScreen',
      actionValue: 'beforeTravel',
    ),
  ]);
}

Map<String, dynamic> guideIntentJson({
  String id = 'destinations',
  String category = 'test',
  String promptAr = 'ما الوجهات المتاحة؟',
  String promptEn = 'Which destinations are available?',
  List<String> keywordsAr = const <String>['وجهات'],
  List<String> keywordsEn = const <String>['destinations'],
  String answerAr = 'إجابة عربية.',
  String answerEn = 'English answer.',
  String actionType = 'openTab',
  String actionValue = 'destinations',
  bool enabled = true,
}) {
  return <String, dynamic>{
    'id': id,
    'category': category,
    'promptAr': promptAr,
    'promptEn': promptEn,
    'keywordsAr': keywordsAr,
    'keywordsEn': keywordsEn,
    'answerAr': answerAr,
    'answerEn': answerEn,
    'actionType': actionType,
    'actionValue': actionValue,
    'enabled': enabled,
  };
}

class TrackingGuideAssetBundle extends AssetBundle {
  final String contents;
  int loadCount = 0;

  TrackingGuideAssetBundle(this.contents);

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;
    return contents;
  }
}

class DelayedGuideAssetBundle extends TrackingGuideAssetBundle {
  final Completer<void> _release = Completer<void>();

  DelayedGuideAssetBundle(super.contents);

  void release() => _release.complete();

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;
    await _release.future;
    return contents;
  }
}

class RecoveringGuideAssetBundle extends TrackingGuideAssetBundle {
  RecoveringGuideAssetBundle(super.contents);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;
    if (loadCount == 1) {
      throw StateError('Controlled first guide loading failure');
    }
    return contents;
  }
}
