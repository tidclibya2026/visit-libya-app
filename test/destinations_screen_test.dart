import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/repositories/destination_repository.dart';
import 'package:visit_libya_app/features/destinations/destinations_screen.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('DestinationsScreen renders loaded destination content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        repository: DestinationRepository(
          assetBundle: _JsonAssetBundle(_testDestinationsJson()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.widgetWithText(Card, 'Tripoli'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('DestinationsScreen filters by search query', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        repository: DestinationRepository(
          assetBundle: _JsonAssetBundle(_testDestinationsJson()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Ghadames');
    await tester.pump();

    expect(find.widgetWithText(Card, 'Ghadames'), findsOneWidget);
    expect(find.widgetWithText(Card, 'Tripoli'), findsNothing);
  });

  testWidgets('DestinationsScreen shows error state and retries loading', (
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
    expect(find.text('Try Again'), findsOneWidget);
    expect(assetBundle.loadCount, 1);

    await tester.tap(find.text('Try Again'));
    await tester.pumpAndSettle();

    expect(assetBundle.loadCount, 2);
    expect(find.widgetWithText(Card, 'Tripoli'), findsOneWidget);
  });
}

Widget _testApp({required DestinationRepository repository}) {
  return MaterialApp(
    locale: const Locale('en'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: DestinationsScreen(repository: repository, onPlanTrip: () {}),
  );
}

String _testDestinationsJson() {
  return jsonEncode(<Map<String, dynamic>>[
    _destinationJson(
      id: 'tripoli',
      nameEn: 'Tripoli',
      categoryId: 'cities',
      categoryEn: 'Cities',
    ),
    _destinationJson(
      id: 'ghadames',
      nameEn: 'Ghadames',
      categoryId: 'heritage',
      categoryEn: 'Heritage',
    ),
  ]);
}

Map<String, dynamic> _destinationJson({
  required String id,
  required String nameEn,
  required String categoryId,
  required String categoryEn,
}) {
  return <String, dynamic>{
    'id': id,
    'nameAr': 'وجهة',
    'nameEn': nameEn,
    'locationAr': 'ليبيا',
    'locationEn': 'Libya',
    'categoryId': categoryId,
    'categoryAr': 'تصنيف',
    'categoryEn': categoryEn,
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

class _JsonAssetBundle extends AssetBundle {
  final String json;

  _JsonAssetBundle(this.json);

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async => json;
}

class _RecoveringAssetBundle extends AssetBundle {
  final String json;
  int loadCount = 0;

  _RecoveringAssetBundle(this.json);

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;

    if (loadCount == 1) {
      await Future<void>.delayed(Duration.zero);
      throw StateError('Controlled test failure');
    }

    return json;
  }
}
