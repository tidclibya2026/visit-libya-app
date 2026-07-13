// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Visit Libya';

  @override
  String get tagline => 'A Journey Through Time';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get destinations => 'Destinations';

  @override
  String get searchDestinations => 'Search destinations';

  @override
  String get all => 'All';

  @override
  String get whyVisit => 'Why visit';

  @override
  String get topExperiences => 'Top experiences';

  @override
  String get imageUnavailable => 'Image unavailable';

  @override
  String get plan => 'Plan';

  @override
  String get more => 'More';

  @override
  String get discoverLibya => 'Discover Libya';

  @override
  String get heroSubtitle =>
      'Ancient civilizations, diverse landscapes, and unforgettable experiences.';

  @override
  String get exploreDestinations => 'Explore Destinations';

  @override
  String get planYourTrip => 'Plan Your Trip';

  @override
  String get planYourTripHomeDescription =>
      'Create a suggested itinerary based on your trip duration, interests, and travel style.';

  @override
  String get startPlanning => 'Start Planning';

  @override
  String get featuredDestinations => 'Featured Destinations';

  @override
  String get exploreByExperience => 'Explore by Experience';

  @override
  String get eventsAndHighlights => 'Events & Highlights';

  @override
  String get majorEventsAndHighlights => 'Major Events & Highlights';

  @override
  String get eventCategoryInternational => 'International';

  @override
  String get eventCategoryNational => 'National';

  @override
  String get eventCategoryFestival => 'Festival';

  @override
  String get eventCategorySeasonal => 'Seasonal';

  @override
  String get eventCategoryNominationAward => 'Nomination or Award';

  @override
  String get eventStatusProvisional => 'Provisional';

  @override
  String get eventStatusAnnounced => 'Announced';

  @override
  String get eventStatusOngoing => 'Ongoing';

  @override
  String get eventStatusCompleted => 'Completed';

  @override
  String get eventStatusUnderReview => 'Under Review';

  @override
  String get eventStatusCancelled => 'Cancelled';

  @override
  String get eventDateToBeConfirmed => 'Date to be confirmed';

  @override
  String get eventOfficialVerificationRequired =>
      'Official verification required';

  @override
  String get eventOfficialVerificationNotice =>
      'This information is provisional. Verify it with the relevant official authorities before relying on it or planning travel.';

  @override
  String get visualGallery => 'Visual Gallery';

  @override
  String get smartGuide => 'Smart Guide';

  @override
  String get smartGuideBeta => 'Smart Guide — Beta';

  @override
  String get touristRoutes => 'Tourist Routes';

  @override
  String get beforeTravel => 'Before Travel';

  @override
  String get heritageAndCivilizations => 'Heritage & Civilizations';

  @override
  String get desertAndAdventure => 'Desert & Adventure';

  @override
  String get coastAndSea => 'Coast & Sea';

  @override
  String get natureAndMountains => 'Nature & Mountains';

  @override
  String get cultureAndCommunity => 'Culture & Community';

  @override
  String get foodAndLocalTaste => 'Food & Local Taste';

  @override
  String get festivalsAndEvents => 'Festivals & Events';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get viewAll => 'View All';

  @override
  String get discover => 'Discover';

  @override
  String get learnMore => 'Learn More';

  @override
  String get comingSoon => 'Coming Soon';

  @override
  String get gallery => 'Gallery';

  @override
  String get events => 'Events';

  @override
  String get routes => 'Routes';

  @override
  String get about => 'About Visit Libya';

  @override
  String get language => 'Language';

  @override
  String get arabic => 'Arabic';

  @override
  String get english => 'English';

  @override
  String get tripDuration => 'Trip Duration';

  @override
  String get interests => 'Interests';

  @override
  String get travelStyle => 'Travel Style';

  @override
  String get groupType => 'Group Type';

  @override
  String get generateTrip => 'Generate Trip';

  @override
  String get suggestedTrip => 'Suggested Trip';

  @override
  String get tripPlannerDescription =>
      'Choose your destination, duration, and interests to create a suggested itinerary.';

  @override
  String get createItinerary => 'Create Itinerary';

  @override
  String get destinationFieldLabel => 'Destination';

  @override
  String get selectDestination => 'Select a destination';

  @override
  String get destinationRequired => 'Select a destination to continue.';

  @override
  String get interestsRequired => 'Select at least one interest.';

  @override
  String get tripResultTitle => 'Your Suggested Itinerary';

  @override
  String get itinerary => 'Itinerary';

  @override
  String get dayFocus => 'Day Focus';

  @override
  String get dailyActivities => 'Activities';

  @override
  String get suggestedExperiences => 'Suggested Experiences';

  @override
  String get preparationNotes => 'Preparation Notes';

  @override
  String get editPreferences => 'Edit Preferences';

  @override
  String tripDurationDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String tripDayTitle(int number) {
    return 'Day $number';
  }

  @override
  String get slotMorning => 'Morning';

  @override
  String get slotMidday => 'Midday';

  @override
  String get slotAfternoon => 'Afternoon';

  @override
  String get slotEvening => 'Evening';

  @override
  String get preparationGeneral =>
      'Confirm opening hours, weather, and local guidance before each day.';

  @override
  String get preparationSoloSafety =>
      'Share your daily route and keep reliable local contacts available.';

  @override
  String get preparationCouplePacing =>
      'Keep the schedule flexible enough for shared breaks and preferences.';

  @override
  String get preparationFamilyComfort =>
      'Plan regular breaks and confirm family-friendly access in advance.';

  @override
  String get preparationFriendsCoordination =>
      'Agree on meeting points and daily timing with everyone.';

  @override
  String get preparationGroupLogistics =>
      'Confirm transport capacity, reservations, and group meeting points.';

  @override
  String get heritage => 'Heritage';

  @override
  String get archaeology => 'Archaeology';

  @override
  String get nature => 'Nature';

  @override
  String get desert => 'Desert';

  @override
  String get coast => 'Coast';

  @override
  String get culture => 'Culture';

  @override
  String get food => 'Food';

  @override
  String get adventure => 'Adventure';

  @override
  String get photography => 'Photography';

  @override
  String get relaxed => 'Relaxed';

  @override
  String get balanced => 'Balanced';

  @override
  String get active => 'Active';

  @override
  String get solo => 'Solo';

  @override
  String get couple => 'Couple';

  @override
  String get family => 'Family';

  @override
  String get friends => 'Friends';

  @override
  String get group => 'Group';

  @override
  String get noResults => 'No results found';

  @override
  String get unableToLoadContent => 'Unable to load content';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get verifyOfficialAuthorities =>
      'Verify current requirements with the relevant official authorities before travel.';

  @override
  String get expertReviewBuild => 'Expert Review Build';
}
