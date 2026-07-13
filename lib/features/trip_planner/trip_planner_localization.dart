import '../../data/models/trip_preference.dart';
import '../../l10n/generated/app_localizations.dart';

extension TripPlannerLocalization on AppLocalizations {
  String tripInterestLabel(TripInterest interest) {
    return switch (interest) {
      TripInterest.heritage => heritage,
      TripInterest.archaeology => archaeology,
      TripInterest.nature => nature,
      TripInterest.desert => desert,
      TripInterest.coast => coast,
      TripInterest.culture => culture,
      TripInterest.food => food,
      TripInterest.adventure => adventure,
      TripInterest.photography => photography,
    };
  }

  String travelStyleLabel(TravelStyle style) {
    return switch (style) {
      TravelStyle.relaxed => relaxed,
      TravelStyle.balanced => balanced,
      TravelStyle.active => active,
    };
  }

  String tripGroupTypeLabel(TripGroupType groupType) {
    return switch (groupType) {
      TripGroupType.solo => solo,
      TripGroupType.couple => couple,
      TripGroupType.family => family,
      TripGroupType.friends => friends,
      TripGroupType.group => group,
    };
  }

  String tripActivitySlotLabel(TripActivitySlot slot) {
    return switch (slot) {
      TripActivitySlot.morning => slotMorning,
      TripActivitySlot.midday => slotMidday,
      TripActivitySlot.afternoon => slotAfternoon,
      TripActivitySlot.evening => slotEvening,
    };
  }

  String preparationNoteLabel(PreparationNoteKey note) {
    return switch (note) {
      PreparationNoteKey.generalPreparation => preparationGeneral,
      PreparationNoteKey.soloSafety => preparationSoloSafety,
      PreparationNoteKey.couplePacing => preparationCouplePacing,
      PreparationNoteKey.familyComfort => preparationFamilyComfort,
      PreparationNoteKey.friendsCoordination => preparationFriendsCoordination,
      PreparationNoteKey.groupLogistics => preparationGroupLogistics,
    };
  }
}
