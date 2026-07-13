import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/core/localization/locale_controller.dart';
import 'package:visit_libya_app/features/before_travel/before_travel_screen.dart';
import 'package:visit_libya_app/features/events/events_screen.dart';
import 'package:visit_libya_app/features/more/more_screen.dart';
import 'package:visit_libya_app/features/routes/routes_screen.dart';
import 'package:visit_libya_app/features/smart_guide/smart_guide_screen.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('MoreScreen Events item opens EventsScreen', (
    WidgetTester tester,
  ) async {
    final LocaleController localeController = LocaleController(
      initialLocale: const Locale('en'),
    );
    addTearDown(localeController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: localeController.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MoreScreen(localeController: localeController),
      ),
    );

    await tester.tap(find.byKey(const Key('moreEventsTile')));
    await tester.pumpAndSettle();

    expect(find.byType(EventsScreen), findsOneWidget);
    expect(find.text('Events & Highlights'), findsOneWidget);
  });

  testWidgets('MoreScreen Routes item opens RoutesScreen', (
    WidgetTester tester,
  ) async {
    final LocaleController localeController = LocaleController(
      initialLocale: const Locale('en'),
    );
    addTearDown(localeController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: localeController.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MoreScreen(localeController: localeController),
      ),
    );

    await tester.tap(find.byKey(const Key('moreRoutesTile')));
    await tester.pumpAndSettle();

    expect(find.byType(RoutesScreen), findsOneWidget);
    expect(find.text('Tourist Routes'), findsOneWidget);
  });

  testWidgets('MoreScreen Smart Guide item opens SmartGuideScreen', (
    WidgetTester tester,
  ) async {
    final LocaleController localeController = LocaleController(
      initialLocale: const Locale('en'),
    );
    addTearDown(localeController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: localeController.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MoreScreen(localeController: localeController),
      ),
    );

    final Finder smartGuideTile = find.byKey(const Key('moreSmartGuideTile'));
    await tester.ensureVisible(smartGuideTile);
    await tester.tap(smartGuideTile);
    await tester.pumpAndSettle();

    expect(find.byType(SmartGuideScreen), findsOneWidget);
    expect(find.text('Smart Guide — Beta'), findsNWidgets(2));
  });

  testWidgets('MoreScreen Before Travel item opens BeforeTravelScreen', (
    WidgetTester tester,
  ) async {
    final LocaleController localeController = LocaleController(
      initialLocale: const Locale('en'),
    );
    addTearDown(localeController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        locale: localeController.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: MoreScreen(localeController: localeController),
      ),
    );

    final Finder beforeTravelTile = find.byKey(
      const Key('moreBeforeTravelTile'),
    );
    await tester.ensureVisible(beforeTravelTile);
    await tester.tap(beforeTravelTile);
    await tester.pumpAndSettle();

    expect(find.byType(BeforeTravelScreen), findsOneWidget);
    expect(find.text('Before Travel'), findsOneWidget);
  });
}
