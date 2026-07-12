import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/app/app.dart';
import 'package:visit_libya_app/data/repositories/destination_repository.dart';
import 'package:visit_libya_app/data/repositories/event_repository.dart';
import 'package:visit_libya_app/data/repositories/experience_repository.dart';
import 'package:visit_libya_app/features/destinations/destination_detail_screen.dart';
import 'package:visit_libya_app/features/home/home_screen.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('hero renders the approved localized content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        locale: const Locale('ar'),
        repository: _repositoryWith(_testDestinationsJson()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('اكتشف ليبيا'), findsOneWidget);
    expect(
      find.text('حضارات عريقة، طبيعة متنوعة، وتجارب لا تُنسى'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('homeHeroExploreButton')), findsOneWidget);
    expect(find.byKey(const Key('homeHeroPlanButton')), findsOneWidget);
  });

  testWidgets('hero Explore CTA selects Destinations tab index 2', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VisitLibyaApp());
    await tester.pump();

    await tester.tap(find.byKey(const Key('homeHeroExploreButton')));
    await tester.pump();

    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      2,
    );
  });

  testWidgets('hero Plan CTA selects Plan tab index 3', (
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

  testWidgets('featured preview loads through DestinationRepository', (
    WidgetTester tester,
  ) async {
    final _TrackingAssetBundle assetBundle = _TrackingAssetBundle(
      _testDestinationsJson(count: 5),
    );

    await tester.pumpWidget(
      _testApp(repository: DestinationRepository(assetBundle: assetBundle)),
    );
    await tester.pumpAndSettle();

    expect(assetBundle.loadCount, 1);
    expect(
      find.byKey(const ValueKey<String>('featuredDestination-place-1')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('featuredDestination-place-4')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('featuredDestination-place-5')),
      findsNothing,
    );
  });

  testWidgets('featured destination opens detail and preserves Plan callback', (
    WidgetTester tester,
  ) async {
    int planRequests = 0;

    await tester.pumpWidget(
      _testApp(
        repository: _repositoryWith(_testDestinationsJson()),
        onPlanTrip: () => planRequests += 1,
      ),
    );
    await tester.pumpAndSettle();

    final Finder card = find.byKey(
      const ValueKey<String>('featuredDestination-place-1'),
    );
    await tester.drag(
      find.descendant(
        of: find.byType(HomeScreen),
        matching: find.byType(ListView),
      ),
      const Offset(0, -360),
    );
    await tester.pumpAndSettle();
    await tester.tap(card);
    await tester.pumpAndSettle();

    expect(find.byType(DestinationDetailScreen), findsOneWidget);
    expect(find.text('Destination 1'), findsWidgets);

    final Finder planButton = find.widgetWithText(
      ElevatedButton,
      'Plan Your Trip',
    );
    await tester.drag(
      find.descendant(
        of: find.byType(DestinationDetailScreen),
        matching: find.byType(ListView),
      ),
      const Offset(0, -800),
    );
    await tester.pumpAndSettle();
    await tester.tap(planButton);
    await tester.pumpAndSettle();

    expect(planRequests, 1);
  });

  testWidgets('featured error state displays and retry reloads data', (
    WidgetTester tester,
  ) async {
    final _RecoveringAssetBundle assetBundle = _RecoveringAssetBundle(
      _testDestinationsJson(),
    );

    await tester.pumpWidget(
      _testApp(repository: DestinationRepository(assetBundle: assetBundle)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Unable to load content'), findsOneWidget);
    expect(assetBundle.loadCount, 1);

    final Finder retryButton = find.byKey(const Key('homeFeaturedRetryButton'));
    await tester.drag(
      find.descendant(
        of: find.byType(HomeScreen),
        matching: find.byType(ListView),
      ),
      const Offset(0, -400),
    );
    await tester.pumpAndSettle();
    await tester.tap(retryButton);
    await tester.pumpAndSettle();

    expect(assetBundle.loadCount, 2);
    expect(
      find.byKey(const ValueKey<String>('featuredDestination-place-1')),
      findsOneWidget,
    );
  });
}

Widget _testApp({
  Locale locale = const Locale('en'),
  required DestinationRepository repository,
  VoidCallback? onExploreDestinations,
  VoidCallback? onPlanTrip,
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: HomeScreen(
      repository: repository,
      experienceRepository: ExperienceRepository(
        assetBundle: _TrackingAssetBundle(_testExperienceJson()),
      ),
      eventRepository: EventRepository(
        assetBundle: _TrackingAssetBundle(_testEventsJson()),
      ),
      onExploreDestinations: onExploreDestinations ?? () {},
      onExploreExperiences: () {},
      onPlanTrip: onPlanTrip ?? () {},
    ),
  );
}

DestinationRepository _repositoryWith(String json) {
  return DestinationRepository(assetBundle: _TrackingAssetBundle(json));
}

String _testDestinationsJson({int count = 1}) {
  return jsonEncode(
    List<Map<String, dynamic>>.generate(
      count,
      (int index) => _destinationJson(index + 1),
      growable: false,
    ),
  );
}

String _testExperienceJson() {
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

String _testEventsJson() {
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

Map<String, dynamic> _destinationJson(int number) {
  return <String, dynamic>{
    'id': 'place-$number',
    'nameAr': 'وجهة $number',
    'nameEn': 'Destination $number',
    'locationAr': 'ليبيا',
    'locationEn': 'Libya',
    'categoryId': 'heritage',
    'categoryAr': 'التراث',
    'categoryEn': 'Heritage',
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

class _RecoveringAssetBundle extends _TrackingAssetBundle {
  _RecoveringAssetBundle(super.json);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;

    if (loadCount == 1) {
      await Future<void>.delayed(Duration.zero);
      throw StateError('Controlled test failure');
    }

    return contents;
  }
}
