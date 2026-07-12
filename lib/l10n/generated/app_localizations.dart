import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Official application name
  ///
  /// In en, this message translates to:
  /// **'Visit Libya'**
  String get appName;

  /// Visit Libya brand tagline
  ///
  /// In en, this message translates to:
  /// **'A Journey Through Time'**
  String get tagline;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @destinations.
  ///
  /// In en, this message translates to:
  /// **'Destinations'**
  String get destinations;

  /// No description provided for @searchDestinations.
  ///
  /// In en, this message translates to:
  /// **'Search destinations'**
  String get searchDestinations;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @whyVisit.
  ///
  /// In en, this message translates to:
  /// **'Why visit'**
  String get whyVisit;

  /// No description provided for @topExperiences.
  ///
  /// In en, this message translates to:
  /// **'Top experiences'**
  String get topExperiences;

  /// No description provided for @imageUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Image unavailable'**
  String get imageUnavailable;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @discoverLibya.
  ///
  /// In en, this message translates to:
  /// **'Discover Libya'**
  String get discoverLibya;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ancient civilizations, diverse landscapes, and unforgettable experiences.'**
  String get heroSubtitle;

  /// No description provided for @exploreDestinations.
  ///
  /// In en, this message translates to:
  /// **'Explore Destinations'**
  String get exploreDestinations;

  /// No description provided for @planYourTrip.
  ///
  /// In en, this message translates to:
  /// **'Plan Your Trip'**
  String get planYourTrip;

  /// No description provided for @featuredDestinations.
  ///
  /// In en, this message translates to:
  /// **'Featured Destinations'**
  String get featuredDestinations;

  /// No description provided for @exploreByExperience.
  ///
  /// In en, this message translates to:
  /// **'Explore by Experience'**
  String get exploreByExperience;

  /// No description provided for @eventsAndHighlights.
  ///
  /// In en, this message translates to:
  /// **'Events & Highlights'**
  String get eventsAndHighlights;

  /// No description provided for @majorEventsAndHighlights.
  ///
  /// In en, this message translates to:
  /// **'Major Events & Highlights'**
  String get majorEventsAndHighlights;

  /// No description provided for @eventCategoryInternational.
  ///
  /// In en, this message translates to:
  /// **'International'**
  String get eventCategoryInternational;

  /// No description provided for @eventCategoryNational.
  ///
  /// In en, this message translates to:
  /// **'National'**
  String get eventCategoryNational;

  /// No description provided for @eventCategoryFestival.
  ///
  /// In en, this message translates to:
  /// **'Festival'**
  String get eventCategoryFestival;

  /// No description provided for @eventCategorySeasonal.
  ///
  /// In en, this message translates to:
  /// **'Seasonal'**
  String get eventCategorySeasonal;

  /// No description provided for @eventCategoryNominationAward.
  ///
  /// In en, this message translates to:
  /// **'Nomination or Award'**
  String get eventCategoryNominationAward;

  /// No description provided for @eventStatusProvisional.
  ///
  /// In en, this message translates to:
  /// **'Provisional'**
  String get eventStatusProvisional;

  /// No description provided for @eventStatusAnnounced.
  ///
  /// In en, this message translates to:
  /// **'Announced'**
  String get eventStatusAnnounced;

  /// No description provided for @eventStatusOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get eventStatusOngoing;

  /// No description provided for @eventStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get eventStatusCompleted;

  /// No description provided for @eventStatusUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Under Review'**
  String get eventStatusUnderReview;

  /// No description provided for @eventStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get eventStatusCancelled;

  /// No description provided for @eventDateToBeConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Date to be confirmed'**
  String get eventDateToBeConfirmed;

  /// No description provided for @eventOfficialVerificationRequired.
  ///
  /// In en, this message translates to:
  /// **'Official verification required'**
  String get eventOfficialVerificationRequired;

  /// No description provided for @eventOfficialVerificationNotice.
  ///
  /// In en, this message translates to:
  /// **'This information is provisional. Verify it with the relevant official authorities before relying on it or planning travel.'**
  String get eventOfficialVerificationNotice;

  /// No description provided for @visualGallery.
  ///
  /// In en, this message translates to:
  /// **'Visual Gallery'**
  String get visualGallery;

  /// No description provided for @smartGuide.
  ///
  /// In en, this message translates to:
  /// **'Smart Guide'**
  String get smartGuide;

  /// No description provided for @smartGuideBeta.
  ///
  /// In en, this message translates to:
  /// **'Smart Guide — Beta'**
  String get smartGuideBeta;

  /// No description provided for @touristRoutes.
  ///
  /// In en, this message translates to:
  /// **'Tourist Routes'**
  String get touristRoutes;

  /// No description provided for @beforeTravel.
  ///
  /// In en, this message translates to:
  /// **'Before Travel'**
  String get beforeTravel;

  /// No description provided for @heritageAndCivilizations.
  ///
  /// In en, this message translates to:
  /// **'Heritage & Civilizations'**
  String get heritageAndCivilizations;

  /// No description provided for @desertAndAdventure.
  ///
  /// In en, this message translates to:
  /// **'Desert & Adventure'**
  String get desertAndAdventure;

  /// No description provided for @coastAndSea.
  ///
  /// In en, this message translates to:
  /// **'Coast & Sea'**
  String get coastAndSea;

  /// No description provided for @natureAndMountains.
  ///
  /// In en, this message translates to:
  /// **'Nature & Mountains'**
  String get natureAndMountains;

  /// No description provided for @cultureAndCommunity.
  ///
  /// In en, this message translates to:
  /// **'Culture & Community'**
  String get cultureAndCommunity;

  /// No description provided for @foodAndLocalTaste.
  ///
  /// In en, this message translates to:
  /// **'Food & Local Taste'**
  String get foodAndLocalTaste;

  /// No description provided for @festivalsAndEvents.
  ///
  /// In en, this message translates to:
  /// **'Festivals & Events'**
  String get festivalsAndEvents;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @routes.
  ///
  /// In en, this message translates to:
  /// **'Routes'**
  String get routes;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About Visit Libya'**
  String get about;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get arabic;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @tripDuration.
  ///
  /// In en, this message translates to:
  /// **'Trip Duration'**
  String get tripDuration;

  /// No description provided for @interests.
  ///
  /// In en, this message translates to:
  /// **'Interests'**
  String get interests;

  /// No description provided for @travelStyle.
  ///
  /// In en, this message translates to:
  /// **'Travel Style'**
  String get travelStyle;

  /// No description provided for @groupType.
  ///
  /// In en, this message translates to:
  /// **'Group Type'**
  String get groupType;

  /// No description provided for @generateTrip.
  ///
  /// In en, this message translates to:
  /// **'Generate Trip'**
  String get generateTrip;

  /// No description provided for @suggestedTrip.
  ///
  /// In en, this message translates to:
  /// **'Suggested Trip'**
  String get suggestedTrip;

  /// No description provided for @heritage.
  ///
  /// In en, this message translates to:
  /// **'Heritage'**
  String get heritage;

  /// No description provided for @archaeology.
  ///
  /// In en, this message translates to:
  /// **'Archaeology'**
  String get archaeology;

  /// No description provided for @nature.
  ///
  /// In en, this message translates to:
  /// **'Nature'**
  String get nature;

  /// No description provided for @desert.
  ///
  /// In en, this message translates to:
  /// **'Desert'**
  String get desert;

  /// No description provided for @coast.
  ///
  /// In en, this message translates to:
  /// **'Coast'**
  String get coast;

  /// No description provided for @culture.
  ///
  /// In en, this message translates to:
  /// **'Culture'**
  String get culture;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @adventure.
  ///
  /// In en, this message translates to:
  /// **'Adventure'**
  String get adventure;

  /// No description provided for @photography.
  ///
  /// In en, this message translates to:
  /// **'Photography'**
  String get photography;

  /// No description provided for @relaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get relaxed;

  /// No description provided for @balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get balanced;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @solo.
  ///
  /// In en, this message translates to:
  /// **'Solo'**
  String get solo;

  /// No description provided for @couple.
  ///
  /// In en, this message translates to:
  /// **'Couple'**
  String get couple;

  /// No description provided for @family.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get family;

  /// No description provided for @friends.
  ///
  /// In en, this message translates to:
  /// **'Friends'**
  String get friends;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @unableToLoadContent.
  ///
  /// In en, this message translates to:
  /// **'Unable to load content'**
  String get unableToLoadContent;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @verifyOfficialAuthorities.
  ///
  /// In en, this message translates to:
  /// **'Verify current requirements with the relevant official authorities before travel.'**
  String get verifyOfficialAuthorities;

  /// No description provided for @expertReviewBuild.
  ///
  /// In en, this message translates to:
  /// **'Expert Review Build'**
  String get expertReviewBuild;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
