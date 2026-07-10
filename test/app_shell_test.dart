import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/app/app.dart';
import 'package:visit_libya_app/app/app_shell.dart';
import 'package:visit_libya_app/core/localization/locale_controller.dart';

void main() {
  testWidgets('VisitLibyaApp starts in Arabic RTL', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VisitLibyaApp());
    await tester.pump();

    final BuildContext shellContext = tester.element(find.byType(AppShell));

    expect(Localizations.localeOf(shellContext).languageCode, 'ar');
    expect(Directionality.of(shellContext), TextDirection.rtl);
  });

  testWidgets('language switch changes locale and direction', (
    WidgetTester tester,
  ) async {
    final LocaleController localeController = LocaleController();

    await tester.pumpWidget(VisitLibyaApp(localeController: localeController));
    await tester.pump();

    localeController.useEnglish();
    await tester.pump();

    final BuildContext shellContext = tester.element(find.byType(AppShell));

    expect(Localizations.localeOf(shellContext).languageCode, 'en');
    expect(Directionality.of(shellContext), TextDirection.ltr);
  });

  testWidgets('AppShell exposes exactly five navigation destinations', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VisitLibyaApp());
    await tester.pump();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(5));
    expect(find.byType(IndexedStack), findsOneWidget);
  });
}
