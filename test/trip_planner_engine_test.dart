import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/trip_plan.dart';
import 'package:visit_libya_app/data/models/trip_preference.dart';
import 'package:visit_libya_app/features/trip_planner/domain/trip_planner_engine.dart';

void main() {
  test('same preference produces structurally identical output', () {
    final TripPreference preference = _preference();

    final TripPlan first = TripPlannerEngine.generate(preference);
    final TripPlan second = TripPlannerEngine.generate(preference);

    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });

  for (final int duration in <int>[1, 2, 3, 5, 7]) {
    test('generates exactly $duration sequential trip days', () {
      final TripPlan plan = TripPlannerEngine.generate(
        _preference(durationDays: duration),
      );

      expect(plan.durationDays, duration);
      expect(plan.days, hasLength(duration));
    });
  }

  test('day numbering starts at one and remains sequential', () {
    final TripPlan plan = TripPlannerEngine.generate(
      _preference(durationDays: 7),
    );

    expect(plan.days.map((TripDay day) => day.dayNumber), <int>[
      1,
      2,
      3,
      4,
      5,
      6,
      7,
    ]);
  });

  test('every generated day has focus interests and activities', () {
    final TripPlan plan = TripPlannerEngine.generate(
      _preference(durationDays: 7, travelStyle: TravelStyle.relaxed),
    );

    for (final TripDay day in plan.days) {
      expect(day.focusInterests, isNotEmpty);
      expect(day.activities, isNotEmpty);
    }
  });

  test('destination ID is preserved', () {
    final TripPlan plan = TripPlannerEngine.generate(
      _preference(destinationId: 'leptis-magna'),
    );

    expect(plan.destinationId, 'leptis-magna');
  });

  test('all selected interests are represented across itinerary focus', () {
    const List<TripInterest> allInterests = TripInterest.values;
    final TripPlan plan = TripPlannerEngine.generate(
      _preference(
        durationDays: 1,
        travelStyle: TravelStyle.relaxed,
        interests: allInterests,
      ),
    );
    final Set<TripInterest> represented = plan.days
        .expand((TripDay day) => day.focusInterests)
        .toSet();

    expect(represented, allInterests.toSet());
  });

  const Map<TravelStyle, int> activityDensities = <TravelStyle, int>{
    TravelStyle.relaxed: 2,
    TravelStyle.balanced: 3,
    TravelStyle.active: 4,
  };
  for (final MapEntry<TravelStyle, int> entry in activityDensities.entries) {
    test('${entry.key.id} creates ${entry.value} activities per day', () {
      final TripPlan plan = TripPlannerEngine.generate(
        _preference(durationDays: 5, travelStyle: entry.key),
      );

      for (final TripDay day in plan.days) {
        expect(day.activities, hasLength(entry.value));
        expect(day.pace, entry.key);
      }
    });
  }

  test('activity slots remain in logical order for every style', () {
    for (final TravelStyle style in TravelStyle.values) {
      final TripPlan plan = TripPlannerEngine.generate(
        _preference(travelStyle: style),
      );

      for (final TripDay day in plan.days) {
        final List<int> slotOrder = day.activities
            .map((TripActivity activity) => activity.slot.index)
            .toList(growable: false);
        final List<int> sortedOrder = <int>[...slotOrder]..sort();
        expect(slotOrder, sortedOrder);
      }
    }
  });

  const Map<TripGroupType, PreparationNoteKey> groupNotes =
      <TripGroupType, PreparationNoteKey>{
        TripGroupType.solo: PreparationNoteKey.soloSafety,
        TripGroupType.couple: PreparationNoteKey.couplePacing,
        TripGroupType.family: PreparationNoteKey.familyComfort,
        TripGroupType.friends: PreparationNoteKey.friendsCoordination,
        TripGroupType.group: PreparationNoteKey.groupLogistics,
      };
  for (final MapEntry<TripGroupType, PreparationNoteKey> entry
      in groupNotes.entries) {
    test('${entry.key.id} receives exactly its group-specific note', () {
      final TripPlan plan = TripPlannerEngine.generate(
        _preference(groupType: entry.key),
      );

      expect(plan.preparationNotes, <PreparationNoteKey>[
        PreparationNoteKey.generalPreparation,
        entry.value,
      ]);
    });
  }

  test('general preparation note is always present exactly once', () {
    for (final TripGroupType groupType in TripGroupType.values) {
      final TripPlan plan = TripPlannerEngine.generate(
        _preference(groupType: groupType),
      );

      expect(
        plan.preparationNotes
            .where(
              (PreparationNoteKey note) =>
                  note == PreparationNoteKey.generalPreparation,
            )
            .length,
        1,
      );
    }
  });

  test('suggested experiences preserve selected-interest order', () {
    const List<TripInterest> interests = <TripInterest>[
      TripInterest.food,
      TripInterest.culture,
      TripInterest.coast,
    ];
    final TripPlan plan = TripPlannerEngine.generate(
      _preference(interests: interests),
    );

    expect(plan.suggestedExperiences, interests);
  });

  test('activities cycle selected interests deterministically', () {
    final TripPlan plan = TripPlannerEngine.generate(
      _preference(
        durationDays: 2,
        interests: const <TripInterest>[
          TripInterest.heritage,
          TripInterest.nature,
        ],
        travelStyle: TravelStyle.active,
      ),
    );

    expect(
      plan.days
          .expand((TripDay day) => day.activities)
          .map((TripActivity activity) => activity.interest),
      <TripInterest>[
        TripInterest.heritage,
        TripInterest.nature,
        TripInterest.heritage,
        TripInterest.nature,
        TripInterest.heritage,
        TripInterest.nature,
        TripInterest.heritage,
        TripInterest.nature,
      ],
    );
  });

  test('generated activity keys are stable localization identifiers', () {
    final TripPreference preference = _preference(
      durationDays: 2,
      travelStyle: TravelStyle.active,
    );
    final TripPlan first = TripPlannerEngine.generate(preference);
    final TripPlan second = TripPlannerEngine.generate(preference);
    final List<String> firstKeys = _activityKeys(first);
    final List<String> secondKeys = _activityKeys(second);

    expect(firstKeys, secondKeys);
    for (final String key in firstKeys) {
      expect(key, isNotEmpty);
      expect(RegExp(r'^[A-Za-z][A-Za-z0-9_]*$').hasMatch(key), isTrue);
    }
  });

  test('generation does not mutate the preference', () {
    final TripPreference preference = _preference(
      interests: const <TripInterest>[
        TripInterest.desert,
        TripInterest.adventure,
        TripInterest.photography,
      ],
    );
    final List<TripInterest> interestsBefore = <TripInterest>[
      ...preference.interests,
    ];

    TripPlannerEngine.generate(preference);

    expect(preference.destinationId, 'tripoli');
    expect(preference.durationDays, 3);
    expect(preference.interests, interestsBefore);
    expect(preference.travelStyle, TravelStyle.balanced);
    expect(preference.groupType, TripGroupType.solo);
  });

  test(
    'core source has no UI, asset, network, repository, or random access',
    () {
      const List<String> paths = <String>[
        'lib/data/models/trip_preference.dart',
        'lib/data/models/trip_plan.dart',
        'lib/features/trip_planner/domain/trip_planner_engine.dart',
      ];
      final RegExp forbidden = RegExp(
        r'package:flutter|material\.dart|widgets\.dart|rootBundle|AssetBundle|'
        r'repository|dart:math|Random\(|http|DateTime\.now',
        caseSensitive: false,
      );

      for (final String path in paths) {
        final String source = File(path).readAsStringSync();
        expect(
          forbidden.hasMatch(source),
          isFalse,
          reason: '$path must remain pure Dart and deterministic',
        );
      }
    },
  );
}

TripPreference _preference({
  String destinationId = 'tripoli',
  int durationDays = 3,
  List<TripInterest> interests = const <TripInterest>[
    TripInterest.heritage,
    TripInterest.nature,
    TripInterest.food,
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

List<String> _activityKeys(TripPlan plan) {
  return plan.days
      .expand((TripDay day) => day.activities)
      .map((TripActivity activity) => activity.activityKey)
      .toList(growable: false);
}
