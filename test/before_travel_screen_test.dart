import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/before_travel_item.dart';
import 'package:visit_libya_app/data/repositories/before_travel_repository.dart';
import 'package:visit_libya_app/features/before_travel/before_travel_screen.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

import 'support/before_travel_test_support.dart';

void main() {
  testWidgets('BeforeTravelScreen shows a loading state', (
    WidgetTester tester,
  ) async {
    final DelayedBeforeTravelAssetBundle bundle =
        DelayedBeforeTravelAssetBundle(beforeTravelJson());

    await tester.pumpWidget(_beforeTravelApp(bundle: bundle));
    await tester.pump();

    expect(
      find.byKey(const Key('beforeTravelLoadingIndicator')),
      findsOneWidget,
    );

    bundle.release();
    await tester.pumpAndSettle();
  });

  testWidgets('repository failure shows a localized error state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _beforeTravelApp(bundle: FailingBeforeTravelAssetBundle()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Unable to load content'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('retry reloads the repository and succeeds', (
    WidgetTester tester,
  ) async {
    final RecoveringBeforeTravelAssetBundle bundle =
        RecoveringBeforeTravelAssetBundle(beforeTravelJson());

    await tester.pumpWidget(_beforeTravelApp(bundle: bundle));
    await tester.pumpAndSettle();
    expect(bundle.loadCount, 1);

    await tester.tap(find.byKey(const Key('beforeTravelRetryButton')));
    await tester.pumpAndSettle();

    expect(bundle.loadCount, 2);
    expect(
      find.byKey(const Key('beforeTravelCard-entry-documents')),
      findsOneWidget,
    );
  });

  testWidgets('renders localized Arabic screen content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _beforeTravelApp(
        bundle: TrackingBeforeTravelAssetBundle(beforeTravelJson()),
        locale: 'ar',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('قبل السفر'), findsOneWidget);
    expect(
      find.text('إرشادات أساسية تساعدك على الاستعداد للرحلة.'),
      findsOneWidget,
    );
    expect(find.text('الدخول والوثائق'), findsOneWidget);
  });

  testWidgets('renders localized English screen content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _beforeTravelApp(
        bundle: TrackingBeforeTravelAssetBundle(beforeTravelJson()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Before Travel'), findsOneWidget);
    expect(
      find.text('Essential guidance to help you prepare for your trip.'),
      findsOneWidget,
    );
    expect(find.text('Entry and Documents'), findsOneWidget);
  });

  testWidgets('renders all eight categories in repository order', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _beforeTravelApp(
        bundle: TrackingBeforeTravelAssetBundle(beforeTravelJson()),
      ),
    );
    await tester.pumpAndSettle();

    final List<double> positions = approvedBeforeTravelIds.map((String id) {
      return tester.getTopLeft(find.byKey(Key('beforeTravelCard-$id'))).dy;
    }).toList();

    expect(positions, orderedEquals(<double>[...positions]..sort()));
    expect(
      find.byKey(const Key('beforeTravelCard-weather-packing')),
      findsOneWidget,
    );
  });

  testWidgets('expanding a category renders its localized checklist', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _beforeTravelApp(
        bundle: TrackingBeforeTravelAssetBundle(beforeTravelJson()),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const Key('beforeTravelExpansion-entry-documents')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Checklist'), findsOneWidget);
    expect(find.text('Review required documents.'), findsOneWidget);
    expect(
      find.byKey(const Key('beforeTravelChecklist-entry-documents-1')),
      findsOneWidget,
    );
  });

  testWidgets('renders the mandatory official-verification notice', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _beforeTravelApp(
        bundle: TrackingBeforeTravelAssetBundle(beforeTravelJson()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('beforeTravelOfficialNotice')), findsOneWidget);
    expect(
      find.text(
        'This information is general guidance and may change. Verify it with the relevant official authorities before travel or taking action.',
      ),
      findsOneWidget,
    );
  });

  test('approved guidance contains no prohibited factual claims', () async {
    const BeforeTravelRepository repository = BeforeTravelRepository();
    final List<BeforeTravelItem> items = await repository.loadItems();
    final String content = items
        .expand(
          (BeforeTravelItem item) => <String>[
            item.titleAr,
            item.titleEn,
            item.summaryAr,
            item.summaryEn,
            ...item.checklistAr,
            ...item.checklistEn,
          ],
        )
        .join(' ')
        .toLowerCase();

    for (final String claim in <String>[
      'visa is not required',
      'visa is required',
      'visa required',
      'visa on arrival',
      'visa-free',
      'price',
      'cost',
      'booking',
      'book now',
      'booking guaranteed',
      'guaranteed safe',
      'تأشيرة غير مطلوبة',
      'تأشيرة مطلوبة',
      'سعر',
      'تكلفة',
      'حجز',
      'احجز الآن',
      'آمن مضمون',
    ]) {
      expect(content, isNot(contains(claim)));
    }
    expect(content, isNot(matches(RegExp(r'\+?\d[\d\s-]{6,}\d'))));
  });

  testWidgets('narrow English layout has no overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _beforeTravelApp(
        bundle: TrackingBeforeTravelAssetBundle(beforeTravelJson()),
      ),
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
      _beforeTravelApp(
        bundle: TrackingBeforeTravelAssetBundle(beforeTravelJson()),
        locale: 'ar',
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      Directionality.of(tester.element(find.byType(BeforeTravelScreen))),
      TextDirection.rtl,
    );
  });
}

Widget _beforeTravelApp({required AssetBundle bundle, String locale = 'en'}) {
  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: BeforeTravelScreen(
      repository: BeforeTravelRepository(assetBundle: bundle),
    ),
  );
}
