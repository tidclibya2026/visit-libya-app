import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/repositories/destination_repository.dart';
import 'package:visit_libya_app/data/repositories/event_repository.dart';
import 'package:visit_libya_app/data/repositories/experience_repository.dart';
import 'package:visit_libya_app/features/events/event_detail_screen.dart';
import 'package:visit_libya_app/features/events/events_screen.dart';
import 'package:visit_libya_app/features/home/home_screen.dart';
import 'package:visit_libya_app/features/home/widgets/events_highlights_section.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('section loads events through EventRepository', (
    WidgetTester tester,
  ) async {
    final _TrackingAssetBundle bundle = _TrackingAssetBundle(_eventsJson());

    await tester.pumpWidget(_sectionApp(bundle: bundle));
    await tester.pumpAndSettle();

    expect(bundle.loadCount, 1);
    expect(
      find.byKey(const Key('homeEventCard-libya-2027-rcme53')),
      findsOneWidget,
    );
  });

  testWidgets('section preserves order and shows at most two featured events', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _sectionApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    final Finder first = find.byKey(
      const Key('homeEventCard-libya-2027-rcme53'),
    );
    final Finder second = find.byKey(
      const Key('homeEventCard-tripoli-islamic-tourism-capital-candidacy'),
    );

    expect(first, findsOneWidget);
    expect(second, findsOneWidget);
    expect(find.byKey(const Key('homeEventCard-extra-featured')), findsNothing);
    expect(tester.getTopLeft(first).dx, lessThan(tester.getTopLeft(second).dx));
  });

  testWidgets('section excludes non-featured events', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _sectionApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('homeEventCard-not-featured')), findsNothing);
    expect(find.text('Hidden Event'), findsNothing);
  });

  testWidgets('section renders Arabic heading and event content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _sectionApp(bundle: _TrackingAssetBundle(_eventsJson()), locale: 'ar'),
    );
    await tester.pumpAndSettle();

    expect(find.text('أحداث وفعاليات بارزة'), findsOneWidget);
    expect(find.text('الاجتماع السياحي الدولي'), findsOneWidget);
    expect(find.text('ملخص الفعالية الأولى'), findsOneWidget);
    expect(find.text('طرابلس، ليبيا'), findsNWidgets(2));
    expect(find.text('دولي'), findsOneWidget);
    expect(find.text('أولي'), findsOneWidget);
  });

  testWidgets('section renders English heading and event content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _sectionApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Major Events & Highlights'), findsOneWidget);
    expect(find.text('International Tourism Meeting'), findsOneWidget);
    expect(find.text('First event summary'), findsOneWidget);
    expect(find.text('Tripoli, Libya'), findsNWidgets(2));
    expect(find.text('International'), findsOneWidget);
    expect(find.text('Provisional'), findsOneWidget);
    expect(
      find.byKey(const Key('homeEventVerification-libya-2027-rcme53')),
      findsOneWidget,
    );
  });

  testWidgets('dated event displays a Material-localized date range', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _sectionApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Thursday, January 7, 2027 - Sunday, January 10, 2027'),
      findsOneWidget,
    );
  });

  testWidgets('undated event displays the pending-date label', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _sectionApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Date to be confirmed'), findsOneWidget);
  });

  testWidgets('event card opens EventDetailScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _sectionApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('homeEventCard-libya-2027-rcme53')));
    await tester.pumpAndSettle();

    expect(find.byType(EventDetailScreen), findsOneWidget);
    expect(find.text('First event full description'), findsOneWidget);
  });

  testWidgets('View All opens EventsScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      _sectionApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('homeEventsViewAllButton')));
    await tester.pumpAndSettle();

    expect(find.byType(EventsScreen), findsOneWidget);
    expect(find.text('Events & Highlights'), findsOneWidget);
  });

  testWidgets('repository error displays localized error state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _sectionApp(bundle: _AlwaysFailingAssetBundle(), locale: 'ar'),
    );
    await tester.pumpAndSettle();

    expect(find.text('تعذر تحميل المحتوى'), findsOneWidget);
    expect(find.text('حاول مرة أخرى'), findsOneWidget);
  });

  testWidgets('retry performs another load and renders events', (
    WidgetTester tester,
  ) async {
    final _RecoveringAssetBundle bundle = _RecoveringAssetBundle(_eventsJson());

    await tester.pumpWidget(_sectionApp(bundle: bundle));
    await tester.pumpAndSettle();
    expect(bundle.loadCount, 1);

    await tester.tap(find.byKey(const Key('homeEventsRetryButton')));
    await tester.pumpAndSettle();

    expect(bundle.loadCount, 2);
    expect(
      find.byKey(const Key('homeEventCard-libya-2027-rcme53')),
      findsOneWidget,
    );
  });

  testWidgets('narrow English layout has no overflow', (
    WidgetTester tester,
  ) async {
    _useNarrowView(tester);

    await tester.pumpWidget(
      _sectionApp(bundle: _TrackingAssetBundle(_eventsJson())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('homeEventsHorizontalList')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow Arabic RTL layout has no overflow', (
    WidgetTester tester,
  ) async {
    _useNarrowView(tester);

    await tester.pumpWidget(
      _sectionApp(bundle: _TrackingAssetBundle(_eventsJson()), locale: 'ar'),
    );
    await tester.pumpAndSettle();

    final BuildContext context = tester.element(
      find.byKey(const Key('homeEventsHighlightsSection')),
    );
    expect(Directionality.of(context), TextDirection.rtl);
    expect(find.byKey(const Key('homeEventsHorizontalList')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Home preserves Hero and Explore callback behavior', (
    WidgetTester tester,
  ) async {
    int destinationRequests = 0;
    int planRequests = 0;
    int experienceRequests = 0;

    await tester.pumpWidget(
      _homeApp(
        onExploreDestinations: () => destinationRequests += 1,
        onPlanTrip: () => planRequests += 1,
        onExploreExperiences: () => experienceRequests += 1,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('homeHeroExploreButton')));
    await tester.tap(find.byKey(const Key('homeHeroPlanButton')));

    final Finder homeScrollable = find
        .descendant(
          of: find.byType(HomeScreen),
          matching: find.byType(Scrollable),
        )
        .first;
    final Finder experienceCard = find.byKey(
      const Key('experienceCard-heritage'),
    );
    await tester.scrollUntilVisible(
      experienceCard,
      400,
      scrollable: homeScrollable,
    );
    await tester.pumpAndSettle();
    await tester.tap(experienceCard);

    expect(destinationRequests, 1);
    expect(planRequests, 1);
    expect(experienceRequests, 1);
  });
}

Widget _sectionApp({required AssetBundle bundle, String locale = 'en'}) {
  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: EventsHighlightsSection(
          repository: EventRepository(assetBundle: bundle),
        ),
      ),
    ),
  );
}

Widget _homeApp({
  required VoidCallback onExploreDestinations,
  required VoidCallback onPlanTrip,
  required VoidCallback onExploreExperiences,
}) {
  return MaterialApp(
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: HomeScreen(
      repository: DestinationRepository(
        assetBundle: _TrackingAssetBundle(_destinationJson()),
      ),
      experienceRepository: ExperienceRepository(
        assetBundle: _TrackingAssetBundle(_experienceJson()),
      ),
      eventRepository: EventRepository(
        assetBundle: _TrackingAssetBundle(_eventsJson()),
      ),
      onExploreDestinations: onExploreDestinations,
      onExploreExperiences: onExploreExperiences,
      onPlanTrip: onPlanTrip,
    ),
  );
}

void _useNarrowView(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(320, 640);
  addTearDown(() {
    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
  });
}

String _eventsJson() {
  return jsonEncode(<Map<String, dynamic>>[
    _eventJson(
      id: 'libya-2027-rcme53',
      category: 'international',
      status: 'provisional',
      titleAr: 'الاجتماع السياحي الدولي',
      titleEn: 'International Tourism Meeting',
      summaryAr: 'ملخص الفعالية الأولى',
      summaryEn: 'First event summary',
      descriptionEn: 'First event full description',
      featured: true,
      startDate: '2027-01-07',
      endDate: '2027-01-10',
    ),
    _eventJson(
      id: 'not-featured',
      category: 'seasonal',
      status: 'announced',
      titleAr: 'فعالية مخفية',
      titleEn: 'Hidden Event',
      summaryAr: 'ملخص مخفي',
      summaryEn: 'Hidden summary',
      descriptionEn: 'Hidden full description',
      featured: false,
      startDate: null,
      endDate: null,
    ),
    _eventJson(
      id: 'tripoli-islamic-tourism-capital-candidacy',
      category: 'nominationAward',
      status: 'underReview',
      titleAr: 'ترشيح طرابلس السياحي',
      titleEn: 'Tripoli Tourism Candidacy',
      summaryAr: 'ملخص الفعالية الثانية',
      summaryEn: 'Second event summary',
      descriptionEn: 'Second event full description',
      featured: true,
      startDate: null,
      endDate: null,
    ),
    _eventJson(
      id: 'extra-featured',
      category: 'national',
      status: 'announced',
      titleAr: 'فعالية إضافية',
      titleEn: 'Extra Featured Event',
      summaryAr: 'ملخص إضافي',
      summaryEn: 'Extra summary',
      descriptionEn: 'Extra full description',
      featured: true,
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
  required String summaryAr,
  required String summaryEn,
  required String descriptionEn,
  required bool featured,
  required String? startDate,
  required String? endDate,
}) {
  return <String, dynamic>{
    'id': id,
    'category': category,
    'status': status,
    'titleAr': titleAr,
    'titleEn': titleEn,
    'summaryAr': summaryAr,
    'summaryEn': summaryEn,
    'descriptionAr': 'وصف تفصيلي للفعالية',
    'descriptionEn': descriptionEn,
    'locationAr': 'طرابلس، ليبيا',
    'locationEn': 'Tripoli, Libya',
    'startDate': startDate,
    'endDate': endDate,
    'featured': featured,
    'image': '',
    'officialUrl': '',
    'requiresOfficialVerification': true,
  };
}

String _destinationJson() {
  return jsonEncode(<Map<String, dynamic>>[
    <String, dynamic>{
      'id': 'tripoli',
      'nameAr': 'طرابلس',
      'nameEn': 'Tripoli',
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
    },
  ]);
}

String _experienceJson() {
  return jsonEncode(<Map<String, dynamic>>[
    <String, dynamic>{
      'id': 'heritage',
      'titleAr': 'التراث والحضارات',
      'titleEn': 'Heritage & Civilizations',
      'descriptionAr': 'اكتشف تاريخ ليبيا.',
      'descriptionEn': 'Discover Libya history.',
      'icon': 'museum',
      'image': '',
    },
  ]);
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
