import 'trip_preference.dart';

class TripActivity {
  final TripActivitySlot slot;
  final TripInterest interest;
  final String activityKey;

  TripActivity({
    required this.slot,
    required this.interest,
    required String activityKey,
  }) : activityKey = _validateActivityKey(activityKey);

  static String _validateActivityKey(String value) {
    final String key = value.trim();

    if (!RegExp(r'^[A-Za-z][A-Za-z0-9_]*$').hasMatch(key)) {
      throw ArgumentError.value(
        value,
        'activityKey',
        'Must be a non-empty localization-ready identifier.',
      );
    }

    return key;
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TripActivity &&
            slot == other.slot &&
            interest == other.interest &&
            activityKey == other.activityKey;
  }

  @override
  int get hashCode => Object.hash(slot, interest, activityKey);
}

class TripDay {
  final int dayNumber;
  final List<TripInterest> focusInterests;
  final List<TripActivity> activities;
  final TravelStyle pace;

  TripDay({
    required int dayNumber,
    required List<TripInterest> focusInterests,
    required List<TripActivity> activities,
    required this.pace,
  }) : dayNumber = _validateDayNumber(dayNumber),
       focusInterests = _prepareFocusInterests(focusInterests),
       activities = _prepareActivities(activities);

  static int _validateDayNumber(int value) {
    if (value < 1) {
      throw ArgumentError.value(value, 'dayNumber', 'Must be positive.');
    }

    return value;
  }

  static List<TripInterest> _prepareFocusInterests(List<TripInterest> values) {
    if (values.isEmpty) {
      throw ArgumentError.value(values, 'focusInterests', 'Must not be empty.');
    }

    return List<TripInterest>.unmodifiable(values);
  }

  static List<TripActivity> _prepareActivities(List<TripActivity> values) {
    if (values.isEmpty) {
      throw ArgumentError.value(values, 'activities', 'Must not be empty.');
    }

    return List<TripActivity>.unmodifiable(values);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TripDay &&
            dayNumber == other.dayNumber &&
            _listEquals(focusInterests, other.focusInterests) &&
            _listEquals(activities, other.activities) &&
            pace == other.pace;
  }

  @override
  int get hashCode => Object.hash(
    dayNumber,
    Object.hashAll(focusInterests),
    Object.hashAll(activities),
    pace,
  );
}

class TripPlan {
  final String destinationId;
  final int durationDays;
  final List<TripDay> days;
  final List<TripInterest> suggestedExperiences;
  final List<PreparationNoteKey> preparationNotes;

  TripPlan({
    required String destinationId,
    required int durationDays,
    required List<TripDay> days,
    required List<TripInterest> suggestedExperiences,
    required List<PreparationNoteKey> preparationNotes,
  }) : destinationId = _validateDestinationId(destinationId),
       durationDays = _validateDuration(durationDays),
       days = _prepareDays(durationDays, days),
       suggestedExperiences = List<TripInterest>.unmodifiable(
         suggestedExperiences,
       ),
       preparationNotes = List<PreparationNoteKey>.unmodifiable(
         preparationNotes,
       );

  static String _validateDestinationId(String value) {
    final String destinationId = value.trim();

    if (destinationId.isEmpty) {
      throw ArgumentError.value(value, 'destinationId', 'Must not be blank.');
    }

    return destinationId;
  }

  static int _validateDuration(int value) {
    if (!TripPreference.supportedDurations.contains(value)) {
      throw ArgumentError.value(
        value,
        'durationDays',
        'Must be one of 1, 2, 3, 5, or 7.',
      );
    }

    return value;
  }

  static List<TripDay> _prepareDays(int durationDays, List<TripDay> values) {
    if (values.length != durationDays) {
      throw ArgumentError.value(
        values,
        'days',
        'Length must equal durationDays.',
      );
    }

    for (int index = 0; index < values.length; index += 1) {
      if (values[index].dayNumber != index + 1) {
        throw ArgumentError.value(
          values,
          'days',
          'Day numbers must start at 1 and be sequential.',
        );
      }
    }

    return List<TripDay>.unmodifiable(values);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TripPlan &&
            destinationId == other.destinationId &&
            durationDays == other.durationDays &&
            _listEquals(days, other.days) &&
            _listEquals(suggestedExperiences, other.suggestedExperiences) &&
            _listEquals(preparationNotes, other.preparationNotes);
  }

  @override
  int get hashCode => Object.hash(
    destinationId,
    durationDays,
    Object.hashAll(days),
    Object.hashAll(suggestedExperiences),
    Object.hashAll(preparationNotes),
  );
}

bool _listEquals<T>(List<T> left, List<T> right) {
  if (identical(left, right)) {
    return true;
  }

  if (left.length != right.length) {
    return false;
  }

  for (int index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) {
      return false;
    }
  }

  return true;
}
