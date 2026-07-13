import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/app/app.dart';
import 'package:visit_libya_app/features/trip_planner/trip_planner_screen.dart';

void main() {
  testWidgets('Plan remains AppShell tab index 3', (WidgetTester tester) async {
    await tester.pumpWidget(const VisitLibyaApp());
    await tester.pump();

    await tester.tap(find.byType(NavigationDestination).at(3));
    await tester.pumpAndSettle();

    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      3,
    );
    expect(find.byType(TripPlannerScreen), findsOneWidget);
  });

  testWidgets('AppShell retains five destinations and IndexedStack', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const VisitLibyaApp());
    await tester.pump();

    expect(find.byType(NavigationDestination), findsNWidgets(5));
    expect(find.byType(IndexedStack), findsOneWidget);
  });
}
