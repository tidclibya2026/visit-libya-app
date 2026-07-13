import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/app/app.dart';
import 'package:visit_libya_app/data/repositories/destination_repository.dart';
import 'package:visit_libya_app/data/repositories/event_repository.dart';
import 'package:visit_libya_app/data/repositories/experience_repository.dart';
import 'package:visit_libya_app/features/home/home_screen.dart';
import 'package:visit_libya_app/features/home/widgets/plan_your_trip_section.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('section renders approved Arabic content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_sectionApp(locale: 'ar'));

    expect(find.text('خطط رحلتك'), findsOneWidget);
    expect(
      find.text(
        'أنشئ برنامجًا سياحيًا مقترحًا يناسب مدة رحلتك واهتماماتك وأسلوب سفرك.',
      ),
      findsOneWidget,
    );
    expect(find.text('ابدأ التخطيط'), findsOneWidget);
  });

  testWidgets('section renders approved English content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_sectionApp());

    expect(find.text('Plan Your Trip'), findsOneWidget);
    expect(
      find.text(
        'Create a suggested itinerary based on your trip duration, interests, and travel style.',
      ),
      findsOneWidget,
    );
    expect(find.text('Start Planning'), findsOneWidget);
  });

  testWidgets('section CTA selects AppShell Plan tab index 3', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VisitLibyaApp());
    await tester.pumpAndSettle();
    await _scrollHomeUntil(tester, find.byKey(const Key('homePlanTripButton')));

    await tester.tap(find.byKey(const Key('homePlanTripButton')));
    await tester.pump();

    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      3,
    );
  });

  testWidgets('Hero Plan CTA remains connected to tab index 3', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VisitLibyaApp());
    await tester.pump();

    await tester.tap(find.byKey(const Key('homeHeroPlanButton')));
    await tester.pump();

    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      3,
    );
  });

  testWidgets('Destinations and Explore callbacks remain unchanged', (
    WidgetTester tester,
  ) async {
    _useView(tester, const Size(1000, 2400));
    int destinationRequests = 0;
    int experienceRequests = 0;

    await tester.pumpWidget(
      _homeApp(
        onExploreDestinations: () => destinationRequests += 1,
        onExploreExperiences: () => experienceRequests += 1,
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('homeHeroExploreButton')));
    final Finder experienceCard = find.byKey(
      const Key('experienceCard-heritage'),
    );
    expect(experienceCard, findsOneWidget);
    await tester.ensureVisible(experienceCard);
    await tester.tap(experienceCard);

    expect(destinationRequests, 1);
    expect(experienceRequests, 1);
  });

  testWidgets('Home places Plan section after Events section', (
    WidgetTester tester,
  ) async {
    _useView(tester, const Size(1000, 3200));

    await tester.pumpWidget(_homeApp());
    await tester.pumpAndSettle();

    final Finder events = find.byKey(const Key('homeEventsHighlightsSection'));
    final Finder plan = find.byKey(const Key('homePlanTripSection'));

    expect(events, findsOneWidget);
    expect(plan, findsOneWidget);
    expect(tester.getTopLeft(events).dy, lessThan(tester.getTopLeft(plan).dy));
  });

  testWidgets('narrow English layout renders without overflow', (
    WidgetTester tester,
  ) async {
    _useView(tester, const Size(320, 640));

    await tester.pumpWidget(_sectionApp());

    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('homePlanTripButton')), findsOneWidget);
  });

  testWidgets('narrow Arabic RTL layout renders without overflow', (
    WidgetTester tester,
  ) async {
    _useView(tester, const Size(320, 640));

    await tester.pumpWidget(_sectionApp(locale: 'ar'));

    final BuildContext context = tester.element(
      find.byKey(const Key('homePlanTripSection')),
    );
    expect(Directionality.of(context), TextDirection.rtl);
    expect(tester.takeException(), isNull);
    expect(find.byKey(const Key('homePlanTripButton')), findsOneWidget);
  });
}

Widget _sectionApp({String locale = 'en'}) {
  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: PlanYourTripSection(onStartPlanning: () {}),
      ),
    ),
  );
}

Widget _homeApp({
  VoidCallback? onExploreDestinations,
  VoidCallback? onExploreExperiences,
}) {
  return MaterialApp(
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: HomeScreen(
      repository: DestinationRepository(
        assetBundle: _JsonAssetBundle(_destinationJson()),
      ),
      experienceRepository: ExperienceRepository(
        assetBundle: _JsonAssetBundle(_experienceJson()),
      ),
      eventRepository: EventRepository(
        assetBundle: _JsonAssetBundle(_eventJson()),
      ),
      onExploreDestinations: onExploreDestinations ?? () {},
      onExploreExperiences: onExploreExperiences ?? () {},
      onPlanTrip: () {},
    ),
  );
}

Future<void> _scrollHomeUntil(WidgetTester tester, Finder target) async {
  for (int attempt = 0; attempt < 16 && target.evaluate().isEmpty; attempt++) {
    final Finder homeList = find
        .descendant(
          of: find.byType(HomeScreen),
          matching: find.byType(ListView),
        )
        .first;
    await tester.drag(homeList, const Offset(0, -520));
    await tester.pump(const Duration(milliseconds: 250));
  }

  expect(target, findsOneWidget);
  await tester.ensureVisible(target);
  await tester.pump(const Duration(milliseconds: 250));
}

void _useView(WidgetTester tester, Size size) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(() {
    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
  });
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

String _eventJson() {
  return jsonEncode(<Map<String, dynamic>>[
    <String, dynamic>{
      'id': 'test-event',
      'category': 'international',
      'status': 'provisional',
      'titleAr': 'فعالية تجريبية',
      'titleEn': 'Test Event',
      'summaryAr': 'ملخص الفعالية',
      'summaryEn': 'Event summary',
      'descriptionAr': 'وصف الفعالية',
      'descriptionEn': 'Event description',
      'locationAr': 'طرابلس، ليبيا',
      'locationEn': 'Tripoli, Libya',
      'startDate': null,
      'endDate': null,
      'featured': true,
      'image': '',
      'officialUrl': '',
      'requiresOfficialVerification': true,
    },
  ]);
}

class _JsonAssetBundle extends AssetBundle {
  final String contents;

  _JsonAssetBundle(this.contents);

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async => contents;
}
