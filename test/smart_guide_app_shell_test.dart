import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/app/app_shell.dart';
import 'package:visit_libya_app/core/localization/locale_controller.dart';
import 'package:visit_libya_app/data/repositories/guide_repository.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

import 'support/smart_guide_test_support.dart';

void main() {
  testWidgets('destination action selects AppShell tab 2', (
    WidgetTester tester,
  ) async {
    await _pumpShell(tester);

    await _openIntentAction(tester, 'destinations');

    expect(_selectedTab(tester), 2);
  });

  testWidgets('explore action selects AppShell tab 1', (
    WidgetTester tester,
  ) async {
    await _pumpShell(tester);

    await _openIntentAction(tester, 'heritage');

    expect(_selectedTab(tester), 1);
  });

  testWidgets('plan action selects AppShell tab 3', (
    WidgetTester tester,
  ) async {
    await _pumpShell(tester);

    await _openIntentAction(tester, 'trip-planning');

    expect(_selectedTab(tester), 3);
  });
}

Future<void> _pumpShell(WidgetTester tester) async {
  final LocaleController localeController = LocaleController(
    initialLocale: const Locale('en'),
  );
  addTearDown(localeController.dispose);

  await tester.pumpWidget(
    MaterialApp(
      locale: localeController.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: AppShell(
        localeController: localeController,
        smartGuideRepository: GuideRepository(
          assetBundle: TrackingGuideAssetBundle(guideIntentsJson()),
        ),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

Future<void> _openIntentAction(WidgetTester tester, String intentId) async {
  await tester.tap(find.byType(NavigationDestination).at(4));
  await tester.pump(const Duration(milliseconds: 300));

  final Finder smartGuideTile = find.byKey(const Key('moreSmartGuideTile'));
  await tester.ensureVisible(smartGuideTile);
  await tester.pump();
  await tester.tap(smartGuideTile);
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));

  final Finder prompt = find.byKey(Key('smartGuidePrompt-$intentId'));
  await tester.ensureVisible(prompt);
  await tester.pump();
  await tester.tap(prompt);
  await tester.pump();

  final Finder action = find.byKey(const Key('smartGuideActionButton'));
  await tester.ensureVisible(action);
  await tester.pump();
  await tester.tap(action);
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

int _selectedTab(WidgetTester tester) {
  return tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex;
}
