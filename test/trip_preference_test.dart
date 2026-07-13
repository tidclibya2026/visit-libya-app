import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/trip_preference.dart';

void main() {
  for (final int duration in <int>[1, 2, 3, 5, 7]) {
    test('accepts supported duration $duration', () {
      final TripPreference preference = _preference(durationDays: duration);

      expect(preference.durationDays, duration);
    });
  }

  test('rejects every unsupported duration', () {
    for (final int duration in <int>[-1, 0, 4, 6, 8]) {
      expect(
        () => _preference(durationDays: duration),
        throwsArgumentError,
        reason: '$duration is not an approved duration',
      );
    }
  });

  test('parses all nine trip interest IDs', () {
    const Map<String, TripInterest> expected = <String, TripInterest>{
      'heritage': TripInterest.heritage,
      'archaeology': TripInterest.archaeology,
      'nature': TripInterest.nature,
      'desert': TripInterest.desert,
      'coast': TripInterest.coast,
      'culture': TripInterest.culture,
      'food': TripInterest.food,
      'adventure': TripInterest.adventure,
      'photography': TripInterest.photography,
    };

    for (final MapEntry<String, TripInterest> entry in expected.entries) {
      expect(TripInterest.fromId(entry.key), entry.value);
      expect(entry.value.id, entry.key);
    }
  });

  test('rejects unknown or padded trip interest IDs', () {
    expect(
      () => TripInterest.fromId('history'),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => TripInterest.fromId(' heritage '),
      throwsA(isA<FormatException>()),
    );
  });

  test('parses all three travel style IDs', () {
    const Map<String, TravelStyle> expected = <String, TravelStyle>{
      'relaxed': TravelStyle.relaxed,
      'balanced': TravelStyle.balanced,
      'active': TravelStyle.active,
    };

    for (final MapEntry<String, TravelStyle> entry in expected.entries) {
      expect(TravelStyle.fromId(entry.key), entry.value);
      expect(entry.value.id, entry.key);
    }
  });

  test('rejects unknown travel style IDs', () {
    expect(
      () => TravelStyle.fromId('intense'),
      throwsA(isA<FormatException>()),
    );
  });

  test('parses all five trip group IDs', () {
    const Map<String, TripGroupType> expected = <String, TripGroupType>{
      'solo': TripGroupType.solo,
      'couple': TripGroupType.couple,
      'family': TripGroupType.family,
      'friends': TripGroupType.friends,
      'group': TripGroupType.group,
    };

    for (final MapEntry<String, TripGroupType> entry in expected.entries) {
      expect(TripGroupType.fromId(entry.key), entry.value);
      expect(entry.value.id, entry.key);
    }
  });

  test('rejects unknown trip group IDs', () {
    expect(() => TripGroupType.fromId('team'), throwsA(isA<FormatException>()));
  });

  test('parses all four activity slot IDs', () {
    const Map<String, TripActivitySlot> expected = <String, TripActivitySlot>{
      'morning': TripActivitySlot.morning,
      'midday': TripActivitySlot.midday,
      'afternoon': TripActivitySlot.afternoon,
      'evening': TripActivitySlot.evening,
    };

    for (final MapEntry<String, TripActivitySlot> entry in expected.entries) {
      expect(TripActivitySlot.fromId(entry.key), entry.value);
      expect(entry.value.id, entry.key);
    }
  });

  test('rejects unknown activity slot IDs', () {
    expect(
      () => TripActivitySlot.fromId('night'),
      throwsA(isA<FormatException>()),
    );
  });

  test('parses every structured preparation note ID', () {
    const Map<String, PreparationNoteKey> expected =
        <String, PreparationNoteKey>{
          'generalPreparation': PreparationNoteKey.generalPreparation,
          'soloSafety': PreparationNoteKey.soloSafety,
          'couplePacing': PreparationNoteKey.couplePacing,
          'familyComfort': PreparationNoteKey.familyComfort,
          'friendsCoordination': PreparationNoteKey.friendsCoordination,
          'groupLogistics': PreparationNoteKey.groupLogistics,
        };

    for (final MapEntry<String, PreparationNoteKey> entry in expected.entries) {
      expect(PreparationNoteKey.fromId(entry.key), entry.value);
      expect(entry.value.id, entry.key);
    }
  });

  test('rejects unknown preparation note IDs', () {
    expect(
      () => PreparationNoteKey.fromId('general'),
      throwsA(isA<FormatException>()),
    );
  });

  test('trims destination ID', () {
    final TripPreference preference = _preference(destinationId: '  tripoli  ');

    expect(preference.destinationId, 'tripoli');
  });

  test('rejects blank destination ID', () {
    expect(() => _preference(destinationId: '   '), throwsArgumentError);
  });

  test('rejects an empty interest list', () {
    expect(() => _preference(interests: <TripInterest>[]), throwsArgumentError);
  });

  test('removes duplicate interests while preserving first occurrence', () {
    final TripPreference preference = _preference(
      interests: <TripInterest>[
        TripInterest.coast,
        TripInterest.heritage,
        TripInterest.coast,
        TripInterest.food,
        TripInterest.heritage,
      ],
    );

    expect(preference.interests, <TripInterest>[
      TripInterest.coast,
      TripInterest.heritage,
      TripInterest.food,
    ]);
  });

  test('external list mutation cannot change stored interests', () {
    final List<TripInterest> input = <TripInterest>[
      TripInterest.heritage,
      TripInterest.nature,
    ];
    final TripPreference preference = _preference(interests: input);

    input
      ..clear()
      ..add(TripInterest.food);

    expect(preference.interests, <TripInterest>[
      TripInterest.heritage,
      TripInterest.nature,
    ]);
  });

  test('stored interests are unmodifiable', () {
    final TripPreference preference = _preference();

    expect(
      () => preference.interests.add(TripInterest.food),
      throwsUnsupportedError,
    );
  });
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
