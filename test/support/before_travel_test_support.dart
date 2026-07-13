import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

const List<String> approvedBeforeTravelIds = <String>[
  'entry-documents',
  'health',
  'safety',
  'money',
  'connectivity',
  'transport',
  'culture',
  'weather-packing',
];

const List<String> approvedBeforeTravelCategories = <String>[
  'entryDocuments',
  'health',
  'safety',
  'money',
  'connectivity',
  'transport',
  'culture',
  'weatherAndPacking',
];

String beforeTravelJson() {
  return jsonEncode(
    List<Map<String, dynamic>>.generate(
      approvedBeforeTravelIds.length,
      (int index) => beforeTravelItemJson(
        id: approvedBeforeTravelIds[index],
        category: approvedBeforeTravelCategories[index],
        titleAr: <String>[
          'الدخول والوثائق',
          'الصحة والاستعداد',
          'السلامة والطوارئ',
          'الأموال ووسائل الدفع',
          'الاتصالات والإنترنت',
          'التنقل والمواصلات',
          'الثقافة وآداب الزيارة',
          'الطقس وتجهيز الأمتعة',
        ][index],
        titleEn: <String>[
          'Entry and Documents',
          'Health and Preparation',
          'Safety and Emergencies',
          'Money and Payments',
          'Connectivity and Internet',
          'Transport and Mobility',
          'Culture and Visitor Etiquette',
          'Weather and Packing',
        ][index],
      ),
    ),
  );
}

Map<String, dynamic> beforeTravelItemJson({
  String id = 'entry-documents',
  String category = 'entryDocuments',
  String titleAr = 'الدخول والوثائق',
  String titleEn = 'Entry and Documents',
  String summaryAr = 'تحقق من المتطلبات الحالية قبل السفر.',
  String summaryEn = 'Verify current requirements before travel.',
  List<String> checklistAr = const <String>[
    'راجع الوثائق المطلوبة.',
    'تحقق من الجهات الرسمية.',
  ],
  List<String> checklistEn = const <String>[
    'Review required documents.',
    'Check with official authorities.',
  ],
  bool requiresOfficialVerification = true,
  bool enabled = true,
}) {
  return <String, dynamic>{
    'id': id,
    'category': category,
    'titleAr': titleAr,
    'titleEn': titleEn,
    'summaryAr': summaryAr,
    'summaryEn': summaryEn,
    'checklistAr': checklistAr,
    'checklistEn': checklistEn,
    'requiresOfficialVerification': requiresOfficialVerification,
    'enabled': enabled,
  };
}

class TrackingBeforeTravelAssetBundle extends AssetBundle {
  final String contents;
  int loadCount = 0;

  TrackingBeforeTravelAssetBundle(this.contents);

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

class DelayedBeforeTravelAssetBundle extends TrackingBeforeTravelAssetBundle {
  final Completer<void> _release = Completer<void>();

  DelayedBeforeTravelAssetBundle(super.contents);

  void release() => _release.complete();

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;
    await _release.future;
    return contents;
  }
}

class RecoveringBeforeTravelAssetBundle
    extends TrackingBeforeTravelAssetBundle {
  RecoveringBeforeTravelAssetBundle(super.contents);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;
    if (loadCount == 1) {
      throw StateError('Controlled first before-travel loading failure');
    }
    return contents;
  }
}

class FailingBeforeTravelAssetBundle extends AssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    throw StateError('Controlled before-travel loading failure');
  }
}
