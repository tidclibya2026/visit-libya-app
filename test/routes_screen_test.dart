import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/tourist_route.dart';
import 'package:visit_libya_app/data/repositories/destination_repository.dart';
import 'package:visit_libya_app/data/repositories/route_repository.dart';
import 'package:visit_libya_app/features/routes/route_detail_screen.dart';
import 'package:visit_libya_app/features/routes/routes_screen.dart';
import 'package:visit_libya_app/features/routes/widgets/route_status_badge.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('RoutesScreen shows a loading state', (
    WidgetTester tester,
  ) async {
    final _DelayedAssetBundle routeBundle = _DelayedAssetBundle(_routesJson());

    await tester.pumpWidget(_routesApp(routeBundle: routeBundle));
    await tester.pump();

    expect(find.byKey(const Key('routesLoadingIndicator')), findsOneWidget);

    routeBundle.release();
    await tester.pumpAndSettle();
  });

  testWidgets('loads exactly five routes through RouteRepository', (
    WidgetTester tester,
  ) async {
    final _TrackingAssetBundle routeBundle = _TrackingAssetBundle(
      _routesJson(),
    );

    await tester.pumpWidget(_routesApp(routeBundle: routeBundle));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('routeCard-civilizations')), findsOneWidget);
    expect(find.byKey(const Key('routeCard-green-mountain')), findsOneWidget);
    expect(find.byKey(const Key('routeCard-desert')), findsOneWidget);
    expect(find.byKey(const Key('routeCard-oasis')), findsOneWidget);
    expect(find.byKey(const Key('routeCard-nafusa')), findsOneWidget);
    expect(routeBundle.loadCount, 1);
  });

  testWidgets('preserves repository route order', (WidgetTester tester) async {
    await tester.pumpWidget(
      _routesApp(routeBundle: _TrackingAssetBundle(_routesJson())),
    );
    await tester.pumpAndSettle();

    final List<double> positions =
        <String>[
          'civilizations',
          'green-mountain',
          'desert',
          'oasis',
          'nafusa',
        ].map((String id) {
          return tester.getTopLeft(find.byKey(Key('routeCard-$id'))).dy;
        }).toList();

    expect(positions, orderedEquals(<double>[...positions]..sort()));
  });

  testWidgets('renders Arabic route content', (WidgetTester tester) async {
    await tester.pumpWidget(
      _routesApp(
        routeBundle: _TrackingAssetBundle(_routesJson()),
        locale: 'ar',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('المسارات السياحية'), findsOneWidget);
    expect(find.text('مسار الحضارات'), findsOneWidget);
    expect(find.text('يربط طرابلس ولبدة الكبرى وصبراتة.'), findsOneWidget);
  });

  testWidgets('renders English route content', (WidgetTester tester) async {
    await tester.pumpWidget(
      _routesApp(routeBundle: _TrackingAssetBundle(_routesJson())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tourist Routes'), findsOneWidget);
    expect(find.text('Civilizations Route'), findsOneWidget);
    expect(
      find.text('Connects Tripoli, Leptis Magna, and Sabratha.'),
      findsOneWidget,
    );
  });

  testWidgets('renders ordered localized stop names', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _routesApp(routeBundle: _TrackingAssetBundle(_routesJson())),
    );
    await tester.pumpAndSettle();

    final Finder tripoli = find.byKey(const Key('routeStop-civilizations-0'));
    final Finder leptis = find.byKey(const Key('routeStop-civilizations-1'));
    final Finder sabratha = find.byKey(const Key('routeStop-civilizations-2'));

    expect(tester.widget<Text>(tripoli).data, 'Tripoli');
    expect(tester.widget<Text>(leptis).data, 'Leptis Magna');
    expect(tester.widget<Text>(sabratha).data, 'Sabratha');
    expect(
      tester.getTopLeft(tripoli).dy,
      lessThan(tester.getTopLeft(leptis).dy),
    );
    expect(
      tester.getTopLeft(leptis).dy,
      lessThan(tester.getTopLeft(sabratha).dy),
    );
  });

  testWidgets('renders localized stop counts', (WidgetTester tester) async {
    await tester.pumpWidget(
      _routesApp(routeBundle: _TrackingAssetBundle(_routesJson())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Stops: 3'), findsOneWidget);
    expect(find.text('Stops: 2'), findsNWidgets(4));
  });

  testWidgets('renders the localized draft status label', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _routesApp(routeBundle: _TrackingAssetBundle(_routesJson())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Draft'), findsNWidgets(5));
  });

  testWidgets('maps all four route statuses exhaustively', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(
          body: Column(
            children: TouristRouteStatus.values
                .map(
                  (TouristRouteStatus status) => RouteStatusBadge(
                    key: ValueKey<TouristRouteStatus>(status),
                    status: status,
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ),
    );

    expect(find.text('Draft'), findsOneWidget);
    expect(find.text('Reviewed'), findsOneWidget);
    expect(find.text('Approved'), findsOneWidget);
    expect(find.text('Archived'), findsOneWidget);
  });

  testWidgets('renders field-verification indicators', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _routesApp(routeBundle: _TrackingAssetBundle(_routesJson())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Field verification required'), findsNWidgets(5));
    expect(find.byIcon(Icons.fact_check_outlined), findsNWidgets(5));
  });

  testWidgets('tapping a route card opens RouteDetailScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _routesApp(routeBundle: _TrackingAssetBundle(_routesJson())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('routeCard-civilizations')));
    await tester.pumpAndSettle();

    expect(find.byType(RouteDetailScreen), findsOneWidget);
    expect(find.text('Route Details'), findsOneWidget);
  });

  testWidgets('repository error renders a localized error state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _routesApp(routeBundle: _AlwaysFailingAssetBundle(), locale: 'ar'),
    );
    await tester.pumpAndSettle();

    expect(find.text('تعذر تحميل المحتوى'), findsOneWidget);
    expect(find.text('إعادة المحاولة'), findsOneWidget);
  });

  testWidgets('retry reloads repository data and succeeds', (
    WidgetTester tester,
  ) async {
    final _RecoveringAssetBundle routeBundle = _RecoveringAssetBundle(
      _routesJson(),
    );

    await tester.pumpWidget(_routesApp(routeBundle: routeBundle));
    await tester.pumpAndSettle();
    expect(routeBundle.loadCount, 1);

    await tester.tap(find.byKey(const Key('routesRetryButton')));
    await tester.pumpAndSettle();

    expect(routeBundle.loadCount, 2);
    expect(find.byKey(const Key('routeCard-civilizations')), findsOneWidget);
  });

  testWidgets('empty route images use branded placeholders', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _routesApp(routeBundle: _TrackingAssetBundle(_routesJson())),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('routeImagePlaceholder')), findsNWidgets(5));
    expect(find.byIcon(Icons.route_rounded), findsNWidgets(5));
  });

  testWidgets('narrow English layout has no overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _routesApp(routeBundle: _TrackingAssetBundle(_routesJson())),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow Arabic RTL layout has no overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _routesApp(
        routeBundle: _TrackingAssetBundle(_routesJson()),
        locale: 'ar',
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      Directionality.of(tester.element(find.byType(RoutesScreen))),
      TextDirection.rtl,
    );
  });
}

Widget _routesApp({required AssetBundle routeBundle, String locale = 'en'}) {
  final DestinationRepository destinationRepository = DestinationRepository(
    assetBundle: _TrackingAssetBundle(_destinationsJson()),
  );

  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: RoutesScreen(
      routeRepository: RouteRepository(
        assetBundle: routeBundle,
        destinationRepository: destinationRepository,
      ),
      destinationRepository: destinationRepository,
    ),
  );
}

String _routesJson() {
  return jsonEncode(<Map<String, dynamic>>[
    _routeJson(
      id: 'civilizations',
      titleAr: 'مسار الحضارات',
      titleEn: 'Civilizations Route',
      summaryAr: 'يربط طرابلس ولبدة الكبرى وصبراتة.',
      summaryEn: 'Connects Tripoli, Leptis Magna, and Sabratha.',
      destinationIds: <String>['tripoli', 'leptis-magna', 'sabratha'],
    ),
    _routeJson(
      id: 'green-mountain',
      titleAr: 'مسار الجبل الأخضر',
      titleEn: 'Green Mountain Route',
      summaryAr: 'يربط بنغازي والجبل الأخضر.',
      summaryEn: 'Connects Benghazi and the Green Mountain.',
      destinationIds: <String>['benghazi', 'green-mountain'],
    ),
    _routeJson(
      id: 'desert',
      titleAr: 'مسار الصحراء',
      titleEn: 'Desert Route',
      summaryAr: 'يربط أكاكوس وأوباري.',
      summaryEn: 'Connects Akakus and Ubari.',
      destinationIds: <String>['akakus', 'ubari'],
    ),
    _routeJson(
      id: 'oasis',
      titleAr: 'مسار الواحات',
      titleEn: 'Oasis Route',
      summaryAr: 'يربط غدامس وأوباري.',
      summaryEn: 'Connects Ghadames and Ubari.',
      destinationIds: <String>['ghadames', 'ubari'],
    ),
    _routeJson(
      id: 'nafusa',
      titleAr: 'مسار جبل نفوسة',
      titleEn: 'Nafusa Route',
      summaryAr: 'يربط طرابلس وجبل نفوسة.',
      summaryEn: 'Connects Tripoli and the Nafusa Mountains.',
      destinationIds: <String>['tripoli', 'nafusa-mountains'],
    ),
  ]);
}

Map<String, dynamic> _routeJson({
  required String id,
  required String titleAr,
  required String titleEn,
  required String summaryAr,
  required String summaryEn,
  required List<String> destinationIds,
}) {
  return <String, dynamic>{
    'id': id,
    'titleAr': titleAr,
    'titleEn': titleEn,
    'summaryAr': summaryAr,
    'summaryEn': summaryEn,
    'destinationIds': destinationIds,
    'status': 'draft',
    'featured': true,
    'image': '',
    'requiresFieldVerification': true,
  };
}

String _destinationsJson() {
  return jsonEncode(<Map<String, dynamic>>[
    _destinationJson('tripoli', 'طرابلس', 'Tripoli'),
    _destinationJson('leptis-magna', 'لبدة الكبرى', 'Leptis Magna'),
    _destinationJson('sabratha', 'صبراتة', 'Sabratha'),
    _destinationJson('benghazi', 'بنغازي', 'Benghazi'),
    _destinationJson('green-mountain', 'الجبل الأخضر', 'Green Mountain'),
    _destinationJson('akakus', 'أكاكوس', 'Akakus'),
    _destinationJson('ubari', 'أوباري', 'Ubari'),
    _destinationJson('ghadames', 'غدامس', 'Ghadames'),
    _destinationJson('nafusa-mountains', 'جبل نفوسة', 'Nafusa Mountains'),
  ]);
}

Map<String, dynamic> _destinationJson(String id, String nameAr, String nameEn) {
  return <String, dynamic>{
    'id': id,
    'nameAr': nameAr,
    'nameEn': nameEn,
    'locationAr': 'ليبيا',
    'locationEn': 'Libya',
    'categoryId': 'route-stop',
    'categoryAr': 'محطة مسار',
    'categoryEn': 'Route Stop',
    'shortDescriptionAr': 'وصف موجز للمحطة.',
    'shortDescriptionEn': 'A short stop description.',
    'descriptionAr': 'وصف المحطة.',
    'descriptionEn': 'Stop description.',
    'whyVisitAr': 'لزيارة المحطة.',
    'whyVisitEn': 'To visit the stop.',
    'image': '',
    'highlightsAr': <String>['معلم'],
    'highlightsEn': <String>['Landmark'],
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

class _DelayedAssetBundle extends _TrackingAssetBundle {
  final Completer<void> _release = Completer<void>();

  _DelayedAssetBundle(super.contents);

  void release() => _release.complete();

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;
    await _release.future;
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
    throw StateError('Controlled route loading failure');
  }
}

class _RecoveringAssetBundle extends _TrackingAssetBundle {
  _RecoveringAssetBundle(super.contents);

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;
    if (loadCount == 1) {
      throw StateError('Controlled first route loading failure');
    }
    return contents;
  }
}
