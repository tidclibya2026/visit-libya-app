import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/repositories/guide_repository.dart';
import 'package:visit_libya_app/features/before_travel/before_travel_screen.dart';
import 'package:visit_libya_app/features/events/events_screen.dart';
import 'package:visit_libya_app/features/routes/routes_screen.dart';
import 'package:visit_libya_app/features/smart_guide/smart_guide_screen.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

import 'support/smart_guide_test_support.dart';

void main() {
  testWidgets('SmartGuideScreen shows a loading state', (
    WidgetTester tester,
  ) async {
    final DelayedGuideAssetBundle bundle = DelayedGuideAssetBundle(
      guideIntentsJson(),
    );

    await tester.pumpWidget(_guideApp(bundle: bundle));
    await tester.pump();

    expect(find.byKey(const Key('smartGuideLoadingIndicator')), findsOneWidget);

    bundle.release();
    await tester.pumpAndSettle();
  });

  testWidgets('error and retry reload the guide repository', (
    WidgetTester tester,
  ) async {
    final RecoveringGuideAssetBundle bundle = RecoveringGuideAssetBundle(
      guideIntentsJson(),
    );

    await tester.pumpWidget(_guideApp(bundle: bundle));
    await tester.pumpAndSettle();

    expect(find.text('Unable to load content'), findsOneWidget);
    expect(bundle.loadCount, 1);

    await tester.tap(find.byKey(const Key('smartGuideRetryButton')));
    await tester.pumpAndSettle();

    expect(bundle.loadCount, 2);
    expect(find.byKey(const Key('smartGuideInput')), findsOneWidget);
  });

  testWidgets('renders approved Arabic Smart Guide content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _guideApp(
        bundle: TrackingGuideAssetBundle(guideIntentsJson()),
        locale: 'ar',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('الدليل الذكي — تجريبي'), findsNWidgets(2));
    expect(
      find.text(
        'دليل محلي يساعدك في الوصول إلى الوجهات والتجارب والخدمات المتاحة داخل التطبيق.',
      ),
      findsOneWidget,
    );
    expect(find.text('أسئلة سريعة'), findsOneWidget);
  });

  testWidgets('renders approved English Smart Guide content', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _guideApp(bundle: TrackingGuideAssetBundle(guideIntentsJson())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Smart Guide — Beta'), findsNWidgets(2));
    expect(
      find.text(
        'A local guide that helps you find destinations, experiences, and services available in the app.',
      ),
      findsOneWidget,
    );
    expect(find.text('Quick Prompts'), findsOneWidget);
  });

  testWidgets('renders all eight quick prompts', (WidgetTester tester) async {
    await tester.pumpWidget(
      _guideApp(bundle: TrackingGuideAssetBundle(guideIntentsJson())),
    );
    await tester.pumpAndSettle();

    for (final String id in <String>[
      'destinations',
      'heritage',
      'desert',
      'coast',
      'trip-planning',
      'events',
      'routes',
      'before-travel',
    ]) {
      expect(find.byKey(Key('smartGuidePrompt-$id')), findsOneWidget);
    }
  });

  testWidgets('quick prompt returns its matched localized answer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _guideApp(bundle: TrackingGuideAssetBundle(guideIntentsJson())),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('smartGuidePrompt-destinations')));
    await tester.pump();

    expect(
      find.text('Open Destinations to explore the available places.'),
      findsOneWidget,
    );
  });

  testWidgets('typed query returns the deterministic matched answer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _guideApp(bundle: TrackingGuideAssetBundle(guideIntentsJson())),
    );
    await tester.pumpAndSettle();

    await _submitQuery(tester, 'Tell me about desert adventure');

    expect(
      find.text('Explore desert and adventure experiences.'),
      findsOneWidget,
    );
  });

  testWidgets('unknown query shows the localized no-match response', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _guideApp(bundle: TrackingGuideAssetBundle(guideIntentsJson())),
    );
    await tester.pumpAndSettle();

    await _submitQuery(tester, 'unrelated subject');

    expect(
      find.text(
        'No matching guide topic was found. Try one of the quick prompts.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('events action opens EventsScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      _guideApp(bundle: TrackingGuideAssetBundle(guideIntentsJson())),
    );
    await tester.pumpAndSettle();

    await _submitQuery(tester, 'events');
    await _tapAction(tester);

    expect(find.byType(EventsScreen), findsOneWidget);
  });

  testWidgets('routes action opens RoutesScreen', (WidgetTester tester) async {
    await tester.pumpWidget(
      _guideApp(bundle: TrackingGuideAssetBundle(guideIntentsJson())),
    );
    await tester.pumpAndSettle();

    await _submitQuery(tester, 'routes');
    await _tapAction(tester);

    expect(find.byType(RoutesScreen), findsOneWidget);
  });

  testWidgets('before-travel action opens BeforeTravelScreen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _guideApp(bundle: TrackingGuideAssetBundle(guideIntentsJson())),
    );
    await tester.pumpAndSettle();

    await _submitQuery(tester, 'before travel');
    await _tapAction(tester);

    expect(find.byType(BeforeTravelScreen), findsOneWidget);
  });

  testWidgets('narrow English layout has no overflow', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      _guideApp(bundle: TrackingGuideAssetBundle(guideIntentsJson())),
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
      _guideApp(
        bundle: TrackingGuideAssetBundle(guideIntentsJson()),
        locale: 'ar',
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(
      Directionality.of(tester.element(find.byType(SmartGuideScreen))),
      TextDirection.rtl,
    );
  });

  testWidgets('renders no generative or remote intelligence claim', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _guideApp(bundle: TrackingGuideAssetBundle(guideIntentsJson())),
    );
    await tester.pumpAndSettle();

    for (final String claim in <String>[
      'generative AI',
      'artificial intelligence',
      'AI-generated',
      'remote request',
      'ذكاء اصطناعي',
    ]) {
      expect(find.textContaining(claim, findRichText: true), findsNothing);
    }
  });
}

Widget _guideApp({required AssetBundle bundle, String locale = 'en'}) {
  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: SmartGuideScreen(repository: GuideRepository(assetBundle: bundle)),
  );
}

Future<void> _submitQuery(WidgetTester tester, String query) async {
  await tester.enterText(find.byKey(const Key('smartGuideInput')), query);
  await tester.tap(find.byKey(const Key('smartGuideSubmitButton')));
  await tester.pump();
}

Future<void> _tapAction(WidgetTester tester) async {
  final Finder action = find.byKey(const Key('smartGuideActionButton'));
  await tester.ensureVisible(action);
  await tester.pumpAndSettle();
  await tester.tap(action);
  await tester.pumpAndSettle();
}
