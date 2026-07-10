import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';
import 'package:visit_libya_app/shared/widgets/image_fallback.dart';

void main() {
  testWidgets('ImageFallback exposes localized semantic label', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Scaffold(body: ImageFallback()),
      ),
    );

    final Icon icon = tester.widget(find.byIcon(Icons.landscape_rounded));

    expect(icon.semanticLabel, 'Image unavailable');
  });
}
