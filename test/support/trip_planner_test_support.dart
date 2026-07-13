import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visit_libya_app/core/theme/app_theme.dart';
import 'package:visit_libya_app/data/models/destination.dart';
import 'package:visit_libya_app/data/repositories/destination_repository.dart';
import 'package:visit_libya_app/features/trip_planner/trip_planner_screen.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

Widget plannerTestApp({
  required DestinationRepository repository,
  String locale = 'en',
}) {
  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    theme: AppTheme.light(isArabic: locale == 'ar'),
    home: TripPlannerScreen(repository: repository),
  );
}

Destination testDestination({
  String id = 'tripoli',
  String nameAr = 'طرابلس',
  String nameEn = 'Tripoli',
}) {
  return Destination.fromJson(
    destinationRecord(id: id, nameAr: nameAr, nameEn: nameEn),
  );
}

String testDestinationsJson() {
  return jsonEncode(<Map<String, dynamic>>[
    destinationRecord(id: 'tripoli', nameAr: 'طرابلس', nameEn: 'Tripoli'),
    destinationRecord(id: 'ghadames', nameAr: 'غدامس', nameEn: 'Ghadames'),
  ]);
}

Map<String, dynamic> destinationRecord({
  required String id,
  required String nameAr,
  required String nameEn,
}) {
  return <String, dynamic>{
    'id': id,
    'nameAr': nameAr,
    'nameEn': nameEn,
    'locationAr': 'ليبيا',
    'locationEn': 'Libya',
    'categoryId': 'cities',
    'categoryAr': 'مدن',
    'categoryEn': 'Cities',
    'shortDescriptionAr': 'وصف مختصر',
    'shortDescriptionEn': 'Short description',
    'descriptionAr': 'وصف تفصيلي',
    'descriptionEn': 'Full description',
    'whyVisitAr': 'سبب الزيارة',
    'whyVisitEn': 'Reason to visit',
    'image': '',
    'highlightsAr': <String>['تجربة'],
    'highlightsEn': <String>['Experience'],
  };
}

class TrackingDestinationBundle extends AssetBundle {
  final String contents;
  int loadCount = 0;

  TrackingDestinationBundle([String? contents])
    : contents = contents ?? testDestinationsJson();

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

class FailingDestinationBundle extends AssetBundle {
  int loadCount = 0;

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;
    throw StateError('Controlled destination failure');
  }
}

class RecoveringDestinationBundle extends TrackingDestinationBundle {
  RecoveringDestinationBundle() : super();

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;

    if (loadCount == 1) {
      throw StateError('Controlled first-load failure');
    }

    return contents;
  }
}

class PendingDestinationBundle extends AssetBundle {
  final Completer<String> _completer = Completer<String>();
  int loadCount = 0;

  void complete() {
    _completer.complete(testDestinationsJson());
  }

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) {
    loadCount += 1;
    return _completer.future;
  }
}
