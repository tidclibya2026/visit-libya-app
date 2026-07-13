import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/core/theme/app_theme.dart';
import 'package:visit_libya_app/data/models/destination.dart';
import 'package:visit_libya_app/data/models/trip_plan.dart';
import 'package:visit_libya_app/data/models/trip_preference.dart';
import 'package:visit_libya_app/features/trip_planner/domain/trip_planner_engine.dart';
import 'package:visit_libya_app/features/trip_planner/trip_result_screen.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

import 'support/trip_planner_test_support.dart';

void main() {
  testWidgets('renders English destination and preference summary', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _resultApp(
        preference: _preference(
          durationDays: 5,
          travelStyle: TravelStyle.active,
          groupType: TripGroupType.family,
        ),
      ),
    );

    expect(find.text('Your Suggested Itinerary'), findsOneWidget);
    expect(find.text('Tripoli'), findsOneWidget);
    expect(find.text('5 days'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Family'), findsOneWidget);
  });

  testWidgets('renders Arabic destination and preference summary', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _resultApp(preference: _preference(), locale: 'ar'),
    );

    expect(find.text('برنامج رحلتك المقترح'), findsOneWidget);
    expect(find.text('طرابلس'), findsOneWidget);
    expect(find.text('3 أيام'), findsOneWidget);
    expect(find.text('متوازن'), findsOneWidget);
    expect(find.text('فردي'), findsOneWidget);
  });

  testWidgets('result preserves destination and duration', (
    WidgetTester tester,
  ) async {
    final Destination destination = testDestination(
      id: 'ghadames',
      nameAr: 'غدامس',
      nameEn: 'Ghadames',
    );
    final TripPreference preference = _preference(
      destinationId: 'ghadames',
      durationDays: 7,
    );

    await tester.pumpWidget(
      _resultApp(preference: preference, destination: destination),
    );

    final TripResultScreen screen = tester.widget<TripResultScreen>(
      find.byType(TripResultScreen),
    );
    expect(screen.destination.id, 'ghadames');
    expect(screen.plan.destinationId, 'ghadames');
    expect(screen.plan.durationDays, 7);
  });

  testWidgets('day count and headings are sequential', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _resultApp(preference: _preference(durationDays: 5)),
    );

    for (int day = 1; day <= 5; day += 1) {
      expect(find.byKey(Key('tripDay-$day')), findsOneWidget);
      expect(find.text('Day $day'), findsOneWidget);
    }
  });

  testWidgets('activity slots and interests render from structured plan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _resultApp(
        preference: _preference(
          durationDays: 1,
          interests: const <TripInterest>[
            TripInterest.heritage,
            TripInterest.nature,
          ],
          travelStyle: TravelStyle.active,
        ),
      ),
    );

    expect(find.text('Morning'), findsOneWidget);
    expect(find.text('Midday'), findsOneWidget);
    expect(find.text('Afternoon'), findsOneWidget);
    expect(find.text('Evening'), findsOneWidget);
    expect(find.text('Heritage'), findsWidgets);
    expect(find.text('Nature'), findsWidgets);
  });

  testWidgets('suggested experiences render from generated plan', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _resultApp(
        preference: _preference(
          interests: const <TripInterest>[
            TripInterest.food,
            TripInterest.culture,
          ],
        ),
      ),
    );

    expect(find.byKey(const Key('tripSuggestedExperiences')), findsOneWidget);
    expect(find.text('Food'), findsWidgets);
    expect(find.text('Culture'), findsWidgets);
  });

  testWidgets('general and group-specific preparation notes render', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _resultApp(preference: _preference(groupType: TripGroupType.family)),
    );

    expect(
      find.text(
        'Confirm opening hours, weather, and local guidance before each day.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Plan regular breaks and confirm family-friendly access in advance.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('edit preferences returns to previous screen safely', (
    WidgetTester tester,
  ) async {
    final TripPreference preference = _preference();
    final Destination destination = testDestination();

    await tester.pumpWidget(
      MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (BuildContext context) => Scaffold(
            body: TextButton(
              key: const Key('openResultButton'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => TripResultScreen(
                      destination: destination,
                      preference: preference,
                      plan: TripPlannerEngine.generate(preference),
                    ),
                  ),
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('openResultButton')));
    await tester.pumpAndSettle();
    final Finder editButton = find.byKey(const Key('tripResultEditButton'));
    final Finder resultScrollable = find
        .descendant(
          of: find.byKey(const Key('tripResultList')),
          matching: find.byType(Scrollable),
        )
        .first;
    await tester.scrollUntilVisible(
      editButton,
      400,
      scrollable: resultScrollable,
    );
    await tester.pumpAndSettle();
    await tester.tap(editButton);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('openResultButton')), findsOneWidget);
    expect(find.byType(TripResultScreen), findsNothing);
  });

  testWidgets('narrow English result has no overflow', (
    WidgetTester tester,
  ) async {
    _useNarrowView(tester);
    await tester.pumpWidget(_resultApp(preference: _preference()));
    await tester.pump();

    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow Arabic RTL result has no overflow', (
    WidgetTester tester,
  ) async {
    _useNarrowView(tester);
    await tester.pumpWidget(
      _resultApp(preference: _preference(), locale: 'ar'),
    );
    await tester.pump();

    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('tripResultList'))),
      ),
      TextDirection.rtl,
    );
    expect(tester.takeException(), isNull);
  });
}

Widget _resultApp({
  required TripPreference preference,
  Destination? destination,
  String locale = 'en',
}) {
  final Destination selectedDestination = destination ?? testDestination();
  final TripPlan plan = TripPlannerEngine.generate(preference);

  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    theme: AppTheme.light(isArabic: locale == 'ar'),
    home: TripResultScreen(
      destination: selectedDestination,
      preference: preference,
      plan: plan,
    ),
  );
}

TripPreference _preference({
  String destinationId = 'tripoli',
  int durationDays = 3,
  List<TripInterest> interests = const <TripInterest>[
    TripInterest.heritage,
    TripInterest.nature,
  ],
  TravelStyle travelStyle = TravelStyle.balanced,
  TripGroupType groupType = TripGroupType.solo,
}) {
  return TripPreference(
    destinationId: destinationId,
    durationDays: durationDays,
    interests: interests,
    travelStyle: travelStyle,
    groupType: groupType,
  );
}

void _useNarrowView(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(320, 640);
  addTearDown(() {
    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
  });
}
