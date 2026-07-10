import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/app/app.dart';

void main() {
  testWidgets('VisitLibyaApp renders the five-tab foundation shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VisitLibyaApp());
    await tester.pump();

    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationDestination), findsNWidgets(5));
  });
}
