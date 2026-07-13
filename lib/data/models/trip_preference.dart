enum TripInterest {
  heritage('heritage'),
  archaeology('archaeology'),
  nature('nature'),
  desert('desert'),
  coast('coast'),
  culture('culture'),
  food('food'),
  adventure('adventure'),
  photography('photography');

  final String id;

  const TripInterest(this.id);

  static TripInterest fromId(String id) {
    return switch (id) {
      'heritage' => TripInterest.heritage,
      'archaeology' => TripInterest.archaeology,
      'nature' => TripInterest.nature,
      'desert' => TripInterest.desert,
      'coast' => TripInterest.coast,
      'culture' => TripInterest.culture,
      'food' => TripInterest.food,
      'adventure' => TripInterest.adventure,
      'photography' => TripInterest.photography,
      _ => throw FormatException('Unknown trip interest ID: $id'),
    };
  }
}

enum TravelStyle {
  relaxed('relaxed'),
  balanced('balanced'),
  active('active');

  final String id;

  const TravelStyle(this.id);

  static TravelStyle fromId(String id) {
    return switch (id) {
      'relaxed' => TravelStyle.relaxed,
      'balanced' => TravelStyle.balanced,
      'active' => TravelStyle.active,
      _ => throw FormatException('Unknown travel style ID: $id'),
    };
  }
}

enum TripGroupType {
  solo('solo'),
  couple('couple'),
  family('family'),
  friends('friends'),
  group('group');

  final String id;

  const TripGroupType(this.id);

  static TripGroupType fromId(String id) {
    return switch (id) {
      'solo' => TripGroupType.solo,
      'couple' => TripGroupType.couple,
      'family' => TripGroupType.family,
      'friends' => TripGroupType.friends,
      'group' => TripGroupType.group,
      _ => throw FormatException('Unknown trip group type ID: $id'),
    };
  }
}

enum TripActivitySlot {
  morning('morning'),
  midday('midday'),
  afternoon('afternoon'),
  evening('evening');

  final String id;

  const TripActivitySlot(this.id);

  static TripActivitySlot fromId(String id) {
    return switch (id) {
      'morning' => TripActivitySlot.morning,
      'midday' => TripActivitySlot.midday,
      'afternoon' => TripActivitySlot.afternoon,
      'evening' => TripActivitySlot.evening,
      _ => throw FormatException('Unknown trip activity slot ID: $id'),
    };
  }
}

enum PreparationNoteKey {
  generalPreparation('generalPreparation'),
  soloSafety('soloSafety'),
  couplePacing('couplePacing'),
  familyComfort('familyComfort'),
  friendsCoordination('friendsCoordination'),
  groupLogistics('groupLogistics');

  final String id;

  const PreparationNoteKey(this.id);

  static PreparationNoteKey fromId(String id) {
    return switch (id) {
      'generalPreparation' => PreparationNoteKey.generalPreparation,
      'soloSafety' => PreparationNoteKey.soloSafety,
      'couplePacing' => PreparationNoteKey.couplePacing,
      'familyComfort' => PreparationNoteKey.familyComfort,
      'friendsCoordination' => PreparationNoteKey.friendsCoordination,
      'groupLogistics' => PreparationNoteKey.groupLogistics,
      _ => throw FormatException('Unknown preparation note ID: $id'),
    };
  }
}

class TripPreference {
  static const Set<int> supportedDurations = <int>{1, 2, 3, 5, 7};

  final String destinationId;
  final int durationDays;
  final List<TripInterest> interests;
  final TravelStyle travelStyle;
  final TripGroupType groupType;

  TripPreference({
    required String destinationId,
    required int durationDays,
    required List<TripInterest> interests,
    required this.travelStyle,
    required this.groupType,
  }) : destinationId = _validateDestinationId(destinationId),
       durationDays = _validateDuration(durationDays),
       interests = _prepareInterests(interests);

  static String _validateDestinationId(String value) {
    final String destinationId = value.trim();

    if (destinationId.isEmpty) {
      throw ArgumentError.value(value, 'destinationId', 'Must not be blank.');
    }

    return destinationId;
  }

  static int _validateDuration(int value) {
    if (!supportedDurations.contains(value)) {
      throw ArgumentError.value(
        value,
        'durationDays',
        'Must be one of 1, 2, 3, 5, or 7.',
      );
    }

    return value;
  }

  static List<TripInterest> _prepareInterests(List<TripInterest> values) {
    if (values.isEmpty) {
      throw ArgumentError.value(values, 'interests', 'Must not be empty.');
    }

    final Set<TripInterest> seen = <TripInterest>{};
    final List<TripInterest> unique = <TripInterest>[];

    for (final TripInterest interest in values) {
      if (seen.add(interest)) {
        unique.add(interest);
      }
    }

    return List<TripInterest>.unmodifiable(unique);
  }
}
