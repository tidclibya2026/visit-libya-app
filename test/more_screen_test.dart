import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/core/localization/locale_controller.dart';
import 'package:visit_libya_app/features/events/events_screen.dart';
import 'package:visit_libya_app/features/more/more_screen.dart';
import 'package:visit_libya_app/features/routes/routes_screen.dart';
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
}
