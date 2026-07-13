import '../../../data/models/trip_plan.dart';
import '../../../data/models/trip_preference.dart';

class TripPlannerEngine {
  const TripPlannerEngine._();

  static TripPlan generate(TripPreference preference) {
    final List<TripActivitySlot> slots = _slotsFor(preference.travelStyle);
    final List<List<TripInterest>> focusByDay = _buildFocusByDay(preference);
    final List<TripDay> days = <TripDay>[];
    int activityIndex = 0;

    for (int dayIndex = 0; dayIndex < preference.durationDays; dayIndex += 1) {
      final List<TripActivity> activities = <TripActivity>[];

      for (final TripActivitySlot slot in slots) {
        final TripInterest interest =
            preference.interests[activityIndex % preference.interests.length];
        activities.add(
          TripActivity(
            slot: slot,
            interest: interest,
            activityKey: 'tripActivity_${interest.id}_${slot.id}',
          ),
        );
        activityIndex += 1;
      }

      final List<TripInterest> focusInterests = <TripInterest>[
        ...focusByDay[dayIndex],
      ];
      for (final TripActivity activity in activities) {
        if (!focusInterests.contains(activity.interest)) {
          focusInterests.add(activity.interest);
        }
      }

      days.add(
        TripDay(
          dayNumber: dayIndex + 1,
          focusInterests: focusInterests,
          activities: activities,
          pace: preference.travelStyle,
        ),
      );
    }

    return TripPlan(
      destinationId: preference.destinationId,
      durationDays: preference.durationDays,
      days: days,
      suggestedExperiences: preference.interests,
      preparationNotes: <PreparationNoteKey>[
        PreparationNoteKey.generalPreparation,
        _groupNoteFor(preference.groupType),
      ],
    );
  }

  static List<TripActivitySlot> _slotsFor(TravelStyle style) {
    return switch (style) {
      TravelStyle.relaxed => const <TripActivitySlot>[
        TripActivitySlot.morning,
        TripActivitySlot.afternoon,
      ],
      TravelStyle.balanced => const <TripActivitySlot>[
        TripActivitySlot.morning,
        TripActivitySlot.afternoon,
        TripActivitySlot.evening,
      ],
      TravelStyle.active => const <TripActivitySlot>[
        TripActivitySlot.morning,
        TripActivitySlot.midday,
        TripActivitySlot.afternoon,
        TripActivitySlot.evening,
      ],
    };
  }

  static List<List<TripInterest>> _buildFocusByDay(TripPreference preference) {
    final List<List<TripInterest>> focusByDay =
        List<List<TripInterest>>.generate(
          preference.durationDays,
          (_) => <TripInterest>[],
        );

    for (int index = 0; index < preference.interests.length; index += 1) {
      focusByDay[index % preference.durationDays].add(
        preference.interests[index],
      );
    }

    for (int dayIndex = 0; dayIndex < focusByDay.length; dayIndex += 1) {
      if (focusByDay[dayIndex].isEmpty) {
        focusByDay[dayIndex].add(
          preference.interests[dayIndex % preference.interests.length],
        );
      }
    }

    return focusByDay;
  }

  static PreparationNoteKey _groupNoteFor(TripGroupType groupType) {
    return switch (groupType) {
      TripGroupType.solo => PreparationNoteKey.soloSafety,
      TripGroupType.couple => PreparationNoteKey.couplePacing,
      TripGroupType.family => PreparationNoteKey.familyComfort,
      TripGroupType.friends => PreparationNoteKey.friendsCoordination,
      TripGroupType.group => PreparationNoteKey.groupLogistics,
    };
  }
}
