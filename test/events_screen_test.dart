import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/repositories/event_repository.dart';
import 'package:visit_libya_app/features/events/event_detail_screen.dart';
import 'package:visit_libya_app/features/events/events_screen.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('EventsScreen loads exactly two events through the repository', (
    WidgetTester tester,
  ) async {
    final _TrackingAssetBundle bundle = _TrackingAssetBundle(_eventsJson());

    await tester.pumpWidget(_eventsApp(bundle: bundle));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('eventCard-libya-2027-rcme53')),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const Key('eventCard-tripoli-islamic-tourism-capital-candidacy'),
      ),
      findsOneWidget,
    );
    expect(bundle.loadCount, 1);
  });

  testWidgets('EventsScreen renders Arabic localized content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _eventsApp(bundle: _TrackingAssetBundle(_eventsJson()), locale: 'ar'),
    );
    await tester.pumpAndSettle();

    expect(find.text('الأحداث والفعاليات'), findsOneWidget);
    expect(find.text('الاجتماع السياحي الدولي'), findsOneWidget);
    expect(find.text('طرابلس، ليبيا'), findsNWidgets(2));
  });

  testWidgets('EventsScreen renders English localized content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _eventsApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Events & Highlights'), findsOneWidget);
    expect(find.text('International Tourism Meeting'), findsOneWidget);
    expect(find.text('Tripoli, Libya'), findsNWidgets(2));
  });

  testWidgets('dated event renders a Material-localized date range', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _eventsApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Thursday, January 7, 2027 - Sunday, January 10, 2027'),
      findsOneWidget,
    );
  });

  testWidgets('undated event renders the localized pending-date label', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _eventsApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Date to be confirmed'), findsOneWidget);
  });

  testWidgets('event cards render localized category and status labels', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _eventsApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(find.text('International'), findsOneWidget);
    expect(find.text('Provisional'), findsOneWidget);
    expect(find.text('Nomination or Award'), findsOneWidget);
    expect(find.text('Under Review'), findsOneWidget);
  });

  testWidgets('verification indicator renders for both approved events', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _eventsApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('eventVerification-libya-2027-rcme53')),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const Key(
          'eventVerification-tripoli-islamic-tourism-capital-candidacy',
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('tapping an event card opens EventDetailScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _eventsApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('eventCard-libya-2027-rcme53')));
    await tester.pumpAndSettle();

    expect(find.byType(EventDetailScreen), findsOneWidget);
    expect(find.text('International event full description'), findsOneWidget);
  });

  testWidgets('repository error shows localized error and retry action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _eventsApp(bundle: _AlwaysFailingAssetBundle(), locale: 'ar'),
    );
    await tester.pumpAndSettle();

    expect(find.text('تعذر تحميل المحتوى'), findsOneWidget);
    expect(find.text('حاول مرة أخرى'), findsOneWidget);
  });

  testWidgets('retry performs a second repository load and renders events', (
    WidgetTester tester,
  ) async {
    final _RecoveringAssetBundle bundle = _RecoveringAssetBundle(_eventsJson());

    await tester.pumpWidget(_eventsApp(bundle: bundle));
    await tester.pumpAndSettle();
    expect(bundle.loadCount, 1);

    await tester.tap(find.byKey(const Key('eventsRetryButton')));
    await tester.pumpAndSettle();

    expect(bundle.loadCount, 2);
    expect(
      find.byKey(const Key('eventCard-libya-2027-rcme53')),
      findsOneWidget,
    );
  });

  testWidgets('narrow mobile layout renders without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _eventsApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const Key('eventCard-libya-2027-rcme53')),
      findsOneWidget,
    );
  });
}

Widget _eventsApp({required AssetBundle bundle, String locale = 'en'}) {
  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: EventsScreen(repository: EventRepository(assetBundle: bundle)),
  );
}

String _eventsJson() {
  return jsonEncode(<Map<String, dynamic>>[
    _eventJson(
      id: 'libya-2027-rcme53',
      category: 'international',
      status: 'provisional',
      titleAr: 'الاجتماع السياحي الدولي',
      titleEn: 'International Tourism Meeting',
      descriptionAr: 'الوصف الكامل للحدث الدولي',
      descriptionEn: 'International event full description',
      startDate: '2027-01-07',
      endDate: '2027-01-10',
    ),
    _eventJson(
      id: 'tripoli-islamic-tourism-capital-candidacy',
      category: 'nominationAward',
      status: 'underReview',
      titleAr: 'ترشيح طرابلس السياحي',
      titleEn: 'Tripoli Tourism Candidacy',
      descriptionAr: 'الوصف الكامل لملف الترشيح',
      descriptionEn: 'Candidacy full description',
      startDate: null,
      endDate: null,
    ),
  ]);
}

Map<String, dynamic> _eventJson({
  required String id,
  required String category,
  required String status,
  required String titleAr,
  required String titleEn,
  required String descriptionAr,
  required String descriptionEn,
  required String? startDate,
  required String? endDate,
}) {
  return <String, dynamic>{
    'id': id,
    'category': category,
    'status': status,
    'titleAr': titleAr,
    'titleEn': titleEn,
    'summaryAr': 'ملخص الحدث',
    'summaryEn': 'Event summary',
    'descriptionAr': descriptionAr,
    'descriptionEn': descriptionEn,
    'locationAr': 'طرابلس، ليبيا',
    'locationEn': 'Tripoli, Libya',
    'startDate': startDate,
    'endDate': endDate,
    'featured': true,
    'image': '',
    'officialUrl': '',
    'requiresOfficialVerification': true,
  };
}

class _TrackingAssetBundle extends AssetBundle {
  final String contents;
  int loadCount = 0;

  _TrackingAssetBundle(this.contents);

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

class _AlwaysFailingAssetBundle extends AssetBundle {
  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    throw StateError('Controlled test failure');
  }
}

class _RecoveringAssetBundle extends _TrackingAssetBundle {
  _RecoveringAssetBundle(super.contents);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;

    if (loadCount == 1) {
      throw StateError('Controlled test failure');
    }

    return contents;
  }
}
