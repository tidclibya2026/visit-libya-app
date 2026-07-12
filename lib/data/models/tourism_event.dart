import 'package:flutter/widgets.dart';

enum TourismEventCategory {
  international,
  national,
  festival,
  seasonal,
  nominationAward,
}

enum TourismEventStatus {
  provisional,
  announced,
  ongoing,
  completed,
  underReview,
  cancelled,
}

class TourismEvent {
  final String id;
  final TourismEventCategory category;
  final TourismEventStatus status;
  final String titleAr;
  final String titleEn;
  final String summaryAr;
  final String summaryEn;
  final String descriptionAr;
  final String descriptionEn;
  final String locationAr;
  final String locationEn;
  final DateTime? startDate;
  final DateTime? endDate;
  final bool featured;
  final String image;
  final String officialUrl;
  final bool requiresOfficialVerification;

  const TourismEvent({
    required this.id,
    required this.category,
    required this.status,
    required this.titleAr,
    required this.titleEn,
    required this.summaryAr,
    required this.summaryEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.locationAr,
    required this.locationEn,
    required this.startDate,
    required this.endDate,
    required this.featured,
    required this.image,
    required this.officialUrl,
    required this.requiresOfficialVerification,
  });

  factory TourismEvent.fromJson(Map<String, dynamic> json) {
    final DateTime? startDate = _optionalDate(json, 'startDate');
    final DateTime? endDate = _optionalDate(json, 'endDate');

    if ((startDate == null) != (endDate == null)) {
      throw const FormatException(
        'Event startDate and endDate must either both be set or both be null.',
      );
    }

    if (startDate != null && endDate!.isBefore(startDate)) {
      throw const FormatException(
        'Event endDate must not be before startDate.',
      );
    }

    return TourismEvent(
      id: _requiredString(json, 'id'),
      category: _parseCategory(_requiredString(json, 'category')),
      status: _parseStatus(_requiredString(json, 'status')),
      titleAr: _requiredString(json, 'titleAr'),
      titleEn: _requiredString(json, 'titleEn'),
      summaryAr: _requiredString(json, 'summaryAr'),
      summaryEn: _requiredString(json, 'summaryEn'),
      descriptionAr: _requiredString(json, 'descriptionAr'),
      descriptionEn: _requiredString(json, 'descriptionEn'),
      locationAr: _requiredString(json, 'locationAr'),
      locationEn: _requiredString(json, 'locationEn'),
      startDate: startDate,
      endDate: endDate,
      featured: _requiredBool(json, 'featured'),
      image: _optionalString(json, 'image'),
      officialUrl: _optionalString(json, 'officialUrl'),
      requiresOfficialVerification: _requiredBool(
        json,
        'requiresOfficialVerification',
      ),
    );
  }

  String title(Locale locale) => _isArabic(locale) ? titleAr : titleEn;

  String summary(Locale locale) => _isArabic(locale) ? summaryAr : summaryEn;

  String description(Locale locale) =>
      _isArabic(locale) ? descriptionAr : descriptionEn;

  String location(Locale locale) => _isArabic(locale) ? locationAr : locationEn;

  static bool _isArabic(Locale locale) => locale.languageCode == 'ar';

  static TourismEventCategory _parseCategory(String value) {
    return switch (value) {
      'international' => TourismEventCategory.international,
      'national' => TourismEventCategory.national,
      'festival' => TourismEventCategory.festival,
      'seasonal' => TourismEventCategory.seasonal,
      'nominationAward' => TourismEventCategory.nominationAward,
      _ => throw FormatException('Unknown tourism event category: $value'),
    };
  }

  static TourismEventStatus _parseStatus(String value) {
    return switch (value) {
      'provisional' => TourismEventStatus.provisional,
      'announced' => TourismEventStatus.announced,
      'ongoing' => TourismEventStatus.ongoing,
      'completed' => TourismEventStatus.completed,
      'underReview' => TourismEventStatus.underReview,
      'cancelled' => TourismEventStatus.cancelled,
      _ => throw FormatException('Unknown tourism event status: $value'),
    };
  }

  static String _requiredString(Map<String, dynamic> json, String key) {
    final Object? value = json[key];

    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Tourism event field "$key" must be a non-empty string.',
      );
    }

    return value.trim();
  }

  static String _optionalString(Map<String, dynamic> json, String key) {
    final Object? value = json[key];

    if (value == null) {
      return '';
    }

    if (value is! String) {
      throw FormatException('Tourism event field "$key" must be a string.');
    }

    return value.trim();
  }

  static bool _requiredBool(Map<String, dynamic> json, String key) {
    final Object? value = json[key];

    if (value is! bool) {
      throw FormatException('Tourism event field "$key" must be a boolean.');
    }

    return value;
  }

  static DateTime? _optionalDate(Map<String, dynamic> json, String key) {
    final Object? value = json[key];

    if (value == null) {
      return null;
    }

    if (value is! String || !RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
      throw FormatException(
        'Tourism event field "$key" must be a date in YYYY-MM-DD format or null.',
      );
    }

    final List<int> parts = value
        .split('-')
        .map(int.parse)
        .toList(growable: false);
    final int year = parts[0];
    final int month = parts[1];
    final int day = parts[2];

    if (year < 1) {
      throw FormatException('Tourism event field "$key" has an invalid date.');
    }

    final DateTime date = DateTime(year, month, day);

    if (date.year != year || date.month != month || date.day != day) {
      throw FormatException('Tourism event field "$key" has an invalid date.');
    }

    return date;
  }
}
