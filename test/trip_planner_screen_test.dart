import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/trip_preference.dart';
import 'package:visit_libya_app/data/repositories/destination_repository.dart';
import 'package:visit_libya_app/features/trip_planner/trip_result_screen.dart';

import 'support/trip_planner_test_support.dart';

void main() {
  testWidgets('shows destination loading state', (WidgetTester tester) async {
    final PendingDestinationBundle bundle = PendingDestinationBundle();

    await tester.pumpWidget(
      plannerTestApp(repository: DestinationRepository(assetBundle: bundle)),
    );
    await tester.pump();

    expect(find.byKey(const Key('tripPlannerLoading')), findsOneWidget);
    expect(bundle.loadCount, 1);

    bundle.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('loads repository destinations once', (
    WidgetTester tester,
  ) async {
    final TrackingDestinationBundle bundle = TrackingDestinationBundle();

    await tester.pumpWidget(
      plannerTestApp(repository: DestinationRepository(assetBundle: bundle)),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('tripDestinationField')));
    await tester.pumpAndSettle();
    expect(find.text('Tripoli'), findsOneWidget);
    expect(find.text('Ghadames'), findsOneWidget);
    await tester.tap(find.text('Tripoli'));
    await tester.pumpAndSettle();
    await _tapVisible(tester, find.byKey(const Key('tripDuration-5')));

    expect(bundle.loadCount, 1);
  });

  testWidgets('shows localized destination error state', (
    WidgetTester tester,
  ) async {
    final FailingDestinationBundle bundle = FailingDestinationBundle();

    await tester.pumpWidget(
      plannerTestApp(repository: DestinationRepository(assetBundle: bundle)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Unable to load content'), findsOneWidget);
    expect(find.text('Try Again'), findsOneWidget);
    expect(bundle.loadCount, 1);
  });

  testWidgets('retry performs a second repository load', (
    WidgetTester tester,
  ) async {
    final RecoveringDestinationBundle bundle = RecoveringDestinationBundle();

    await tester.pumpWidget(
      plannerTestApp(repository: DestinationRepository(assetBundle: bundle)),
    );
    await tester.pumpAndSettle();
    expect(bundle.loadCount, 1);

    await tester.tap(find.byKey(const Key('tripPlannerRetryButton')));
    await tester.pumpAndSettle();

    expect(bundle.loadCount, 2);
    expect(find.byKey(const Key('tripPlannerForm')), findsOneWidget);
  });

  testWidgets('renders approved English form content', (
    WidgetTester tester,
  ) async {
    await _pumpPlanner(tester);

    expect(find.text('Plan Your Trip'), findsOneWidget);
    expect(
      find.text(
        'Choose your destination, duration, and interests to create a suggested itinerary.',
      ),
      findsOneWidget,
    );
    expect(find.text('Create Itinerary'), findsOneWidget);
  });

  testWidgets('renders approved Arabic form content', (
    WidgetTester tester,
  ) async {
    await _pumpPlanner(tester, locale: 'ar');

    expect(find.text('خطط رحلتك'), findsOneWidget);
    expect(
      find.text('اختر وجهتك ومدة الرحلة واهتماماتك لإنشاء برنامج سياحي مقترح.'),
      findsOneWidget,
    );
    expect(find.text('أنشئ البرنامج'), findsOneWidget);
    expect(
      Directionality.of(
        tester.element(find.byKey(const Key('tripPlannerForm'))),
      ),
      TextDirection.rtl,
    );
  });

  testWidgets('renders all approved duration choices with default three days', (
    WidgetTester tester,
  ) async {
    await _pumpPlanner(tester);

    for (final int duration in <int>[1, 2, 3, 5, 7]) {
      expect(find.byKey(Key('tripDuration-$duration')), findsOneWidget);
    }
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const Key('tripDuration-3')))
          .selected,
      isTrue,
    );
  });

  testWidgets('all nine interests can be selected', (
    WidgetTester tester,
  ) async {
    await _pumpPlanner(tester);

    for (final TripInterest interest in TripInterest.values) {
      final Finder chip = find.byKey(Key('tripInterest-${interest.id}'));
      await _tapVisible(tester, chip);
      expect(tester.widget<FilterChip>(chip).selected, isTrue);
    }
  });

  testWidgets('renders all styles with balanced selected by default', (
    WidgetTester tester,
  ) async {
    await _pumpPlanner(tester);

    for (final TravelStyle style in TravelStyle.values) {
      expect(find.byKey(Key('tripStyle-${style.id}')), findsOneWidget);
    }
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const Key('tripStyle-balanced')))
          .selected,
      isTrue,
    );
  });

  testWidgets('renders all group types with solo selected by default', (
    WidgetTester tester,
  ) async {
    await _pumpPlanner(tester);

    for (final TripGroupType groupType in TripGroupType.values) {
      expect(find.byKey(Key('tripGroup-${groupType.id}')), findsOneWidget);
    }
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const Key('tripGroup-solo')))
          .selected,
      isTrue,
    );
  });

  testWidgets('missing destination blocks generation', (
    WidgetTester tester,
  ) async {
    await _pumpPlanner(tester);
    await _tapVisible(tester, find.byKey(const Key('tripInterest-heritage')));

    await _tapVisible(tester, find.byKey(const Key('tripPlannerSubmitButton')));

    expect(find.text('Select a destination to continue.'), findsOneWidget);
    expect(find.byType(TripResultScreen), findsNothing);
  });

  testWidgets('empty interests block generation', (WidgetTester tester) async {
    await _pumpPlanner(tester);
    await _selectDestination(tester, 'Tripoli');

    await _tapVisible(tester, find.byKey(const Key('tripPlannerSubmitButton')));

    expect(find.text('Select at least one interest.'), findsOneWidget);
    expect(find.byType(TripResultScreen), findsNothing);
  });

  testWidgets('validation messages render in Arabic', (
    WidgetTester tester,
  ) async {
    await _pumpPlanner(tester, locale: 'ar');

    await _tapVisible(tester, find.byKey(const Key('tripPlannerSubmitButton')));

    expect(find.text('اختر وجهة للمتابعة.'), findsOneWidget);
    expect(find.text('اختر اهتمامًا واحدًا على الأقل.'), findsOneWidget);
  });

  testWidgets('valid submission creates preference and opens result', (
    WidgetTester tester,
  ) async {
    await _pumpPlanner(tester);
    await _selectDestination(tester, 'Ghadames');
    await _tapVisible(tester, find.byKey(const Key('tripDuration-5')));
    await _tapVisible(tester, find.byKey(const Key('tripInterest-desert')));
    await _tapVisible(tester, find.byKey(const Key('tripStyle-active')));
    await _tapVisible(tester, find.byKey(const Key('tripGroup-family')));

    await _tapVisible(tester, find.byKey(const Key('tripPlannerSubmitButton')));
    await tester.pumpAndSettle();

    final TripResultScreen result = tester.widget<TripResultScreen>(
      find.byType(TripResultScreen),
    );
    expect(result.preference.destinationId, 'ghadames');
    expect(result.preference.durationDays, 5);
    expect(result.preference.interests, <TripInterest>[TripInterest.desert]);
    expect(result.preference.travelStyle, TravelStyle.active);
    expect(result.preference.groupType, TripGroupType.family);
    expect(result.plan.days, hasLength(5));
  });

  testWidgets('narrow English form has no overflow', (
    WidgetTester tester,
  ) async {
    _useNarrowView(tester);
    await _pumpPlanner(tester);

    await _scrollToBottom(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('narrow Arabic RTL form has no overflow', (
    WidgetTester tester,
  ) async {
    _useNarrowView(tester);
    await _pumpPlanner(tester, locale: 'ar');

    await _scrollToBottom(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('planner contains no AI-generated wording', (
    WidgetTester tester,
  ) async {
    await _pumpPlanner(tester);
    final Iterable<String> text = tester
        .widgetList<Text>(find.byType(Text))
        .map((Text widget) => widget.data ?? '')
        .where((String value) => value.isNotEmpty);

    expect(
      text.join(' '),
      isNot(matches(RegExp(r'\bAI\b|artificial intelligence|AI-generated'))),
    );
  });
}

Future<void> _pumpPlanner(WidgetTester tester, {String locale = 'en'}) async {
  await tester.pumpWidget(
    plannerTestApp(
      repository: DestinationRepository(
        assetBundle: TrackingDestinationBundle(),
      ),
      locale: locale,
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> _selectDestination(WidgetTester tester, String label) async {
  await tester.ensureVisible(find.byKey(const Key('tripDestinationField')));
  await tester.tap(find.byKey(const Key('tripDestinationField')));
  await tester.pumpAndSettle();
  await tester.tap(find.text(label).last);
  await tester.pumpAndSettle();
}

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump();
}

Future<void> _scrollToBottom(WidgetTester tester) async {
  final Finder form = find.byKey(const Key('tripPlannerForm'));
  await tester.drag(form, const Offset(0, -1600));
  await tester.pumpAndSettle();
}

void _useNarrowView(WidgetTester tester) {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(320, 640);
  addTearDown(() {
    tester.view.resetDevicePixelRatio();
    tester.view.resetPhysicalSize();
  });
}
