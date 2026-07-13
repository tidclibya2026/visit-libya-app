import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/trip_plan.dart';
import 'package:visit_libya_app/data/models/trip_preference.dart';

void main() {
  test('activity accepts and trims a localization-ready key', () {
    final TripActivity activity = TripActivity(
      slot: TripActivitySlot.morning,
      interest: TripInterest.heritage,
      activityKey: '  tripActivity_heritage_morning  ',
    );

    expect(activity.activityKey, 'tripActivity_heritage_morning');
  });

  test('activity rejects blank or paragraph-like keys', () {
    expect(() => _activity(activityKey: ' '), throwsArgumentError);
    expect(
      () => _activity(activityKey: 'Visit the old city in the morning.'),
      throwsArgumentError,
    );
  });

  test('day number must be positive', () {
    expect(() => _day(dayNumber: 0), throwsArgumentError);
  });

  test('day rejects empty focus interests', () {
    expect(() => _day(focusInterests: <TripInterest>[]), throwsArgumentError);
  });

  test('day rejects an empty activity list', () {
    expect(() => _day(activities: <TripActivity>[]), throwsArgumentError);
  });

  test('day defensively copies and protects its collections', () {
    final List<TripInterest> focus = <TripInterest>[TripInterest.heritage];
    final List<TripActivity> activities = <TripActivity>[_activity()];
    final TripDay day = _day(focusInterests: focus, activities: activities);

    focus.clear();
    activities.clear();

    expect(day.focusInterests, <TripInterest>[TripInterest.heritage]);
    expect(day.activities, hasLength(1));
    expect(
      () => day.focusInterests.add(TripInterest.food),
      throwsUnsupportedError,
    );
    expect(() => day.activities.add(_activity()), throwsUnsupportedError);
  });

  test('plan rejects blank destination ID', () {
    expect(() => _plan(destinationId: '  '), throwsArgumentError);
  });

  test('plan rejects unsupported duration', () {
    expect(() => _plan(durationDays: 4), throwsArgumentError);
  });

  test('plan requires day count to equal duration', () {
    expect(
      () => _plan(durationDays: 2, days: <TripDay>[_day()]),
      throwsArgumentError,
    );
  });

  test('plan requires sequential day numbers starting at one', () {
    expect(
      () => _plan(durationDays: 2, days: <TripDay>[_day(), _day(dayNumber: 3)]),
      throwsArgumentError,
    );
  });

  test('plan defensively copies and protects all collections', () {
    final List<TripDay> days = <TripDay>[_day()];
    final List<TripInterest> suggested = <TripInterest>[TripInterest.heritage];
    final List<PreparationNoteKey> notes = <PreparationNoteKey>[
      PreparationNoteKey.generalPreparation,
      PreparationNoteKey.soloSafety,
    ];
    final TripPlan plan = _plan(
      days: days,
      suggestedExperiences: suggested,
      preparationNotes: notes,
    );

    days.clear();
    suggested.clear();
    notes.clear();

    expect(plan.days, hasLength(1));
    expect(plan.suggestedExperiences, <TripInterest>[TripInterest.heritage]);
    expect(plan.preparationNotes, <PreparationNoteKey>[
      PreparationNoteKey.generalPreparation,
      PreparationNoteKey.soloSafety,
    ]);
    expect(() => plan.days.add(_day()), throwsUnsupportedError);
    expect(
      () => plan.suggestedExperiences.add(TripInterest.food),
      throwsUnsupportedError,
    );
    expect(
      () => plan.preparationNotes.add(PreparationNoteKey.familyComfort),
      throwsUnsupportedError,
    );
  });

  test('equivalent plan structures compare equal', () {
    final TripPlan first = _plan();
    final TripPlan second = _plan();

    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });
}

TripActivity _activity({
  TripActivitySlot slot = TripActivitySlot.morning,
  TripInterest interest = TripInterest.heritage,
  String activityKey = 'tripActivity_heritage_morning',
}) {
  return TripActivity(slot: slot, interest: interest, activityKey: activityKey);
}

TripDay _day({
  int dayNumber = 1,
  List<TripInterest> focusInterests = const <TripInterest>[
    TripInterest.heritage,
  ],
  List<TripActivity>? activities,
  TravelStyle pace = TravelStyle.relaxed,
}) {
  return TripDay(
    dayNumber: dayNumber,
    focusInterests: focusInterests,
    activities: activities ?? <TripActivity>[_activity()],
    pace: pace,
  );
}

TripPlan _plan({
  String destinationId = 'tripoli',
  int durationDays = 1,
  List<TripDay>? days,
  List<TripInterest> suggestedExperiences = const <TripInterest>[
    TripInterest.heritage,
  ],
  List<PreparationNoteKey> preparationNotes = const <PreparationNoteKey>[
    PreparationNoteKey.generalPreparation,
    PreparationNoteKey.soloSafety,
  ],
}) {
  return TripPlan(
    destinationId: destinationId,
    durationDays: durationDays,
    days: days ?? <TripDay>[_day()],
    suggestedExperiences: suggestedExperiences,
    preparationNotes: preparationNotes,
  );
}
