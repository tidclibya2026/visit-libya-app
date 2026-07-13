import 'package:flutter/widgets.dart';

enum TouristRouteStatus {
  draft('draft'),
  reviewed('reviewed'),
  approved('approved'),
  archived('archived');

  final String id;

  const TouristRouteStatus(this.id);

  static TouristRouteStatus fromId(String id) {
    return switch (id) {
      'draft' => TouristRouteStatus.draft,
      'reviewed' => TouristRouteStatus.reviewed,
      'approved' => TouristRouteStatus.approved,
      'archived' => TouristRouteStatus.archived,
      _ => throw FormatException('Unknown tourist route status: $id'),
    };
  }
}

class TouristRoute {
  final String id;
  final String titleAr;
  final String titleEn;
  final String summaryAr;
  final String summaryEn;
  final List<String> destinationIds;
  final TouristRouteStatus status;
  final bool featured;
  final String image;
  final bool requiresFieldVerification;

  TouristRoute({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.summaryAr,
    required this.summaryEn,
    required List<String> destinationIds,
    required this.status,
    required this.featured,
    required this.image,
    required this.requiresFieldVerification,
  }) : destinationIds = _validatedDestinationIds(destinationIds);

  factory TouristRoute.fromJson(Map<String, dynamic> json) {
    final List<String> destinationIds = _requiredDestinationIds(json);

    return TouristRoute(
      id: _requiredString(json, 'id'),
      titleAr: _requiredString(json, 'titleAr'),
      titleEn: _requiredString(json, 'titleEn'),
      summaryAr: _requiredString(json, 'summaryAr'),
      summaryEn: _requiredString(json, 'summaryEn'),
      destinationIds: destinationIds,
      status: TouristRouteStatus.fromId(_requiredString(json, 'status')),
      featured: _requiredBool(json, 'featured'),
      image: _requiredImage(json),
      requiresFieldVerification: _requiredBool(
        json,
        'requiresFieldVerification',
      ),
    );
  }

  String title(Locale locale) => _isArabic(locale) ? titleAr : titleEn;

  String summary(Locale locale) => _isArabic(locale) ? summaryAr : summaryEn;

  static bool _isArabic(Locale locale) => locale.languageCode == 'ar';

  static String _requiredString(Map<String, dynamic> json, String key) {
    final Object? value = json[key];

    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Tourist route field "$key" must be a non-empty string.',
      );
    }

    return value.trim();
  }

  static bool _requiredBool(Map<String, dynamic> json, String key) {
    final Object? value = json[key];

    if (value is! bool) {
      throw FormatException('Tourist route field "$key" must be a boolean.');
    }

    return value;
  }

  static String _requiredImage(Map<String, dynamic> json) {
    final Object? value = json['image'];

    if (value is! String) {
      throw const FormatException(
        'Tourist route field "image" must be a string.',
      );
    }

    return value.trim();
  }

  static List<String> _requiredDestinationIds(Map<String, dynamic> json) {
    final Object? value = json['destinationIds'];

    if (value is! List<dynamic> || value.isEmpty) {
      throw const FormatException(
        'Tourist route field "destinationIds" must be a non-empty list.',
      );
    }

    final List<String> ids = <String>[];
    final Set<String> uniqueIds = <String>{};

    for (final Object? item in value) {
      if (item is! String || item.trim().isEmpty) {
        throw const FormatException(
          'Tourist route destination IDs must be non-empty strings.',
        );
      }

      final String id = item.trim();
      if (!uniqueIds.add(id)) {
        throw FormatException('Duplicate tourist route destination ID: $id');
      }
      ids.add(id);
    }

    return ids;
  }

  static List<String> _validatedDestinationIds(List<String> destinationIds) {
    if (destinationIds.isEmpty) {
      throw ArgumentError.value(
        destinationIds,
        'destinationIds',
        'Must contain at least one destination ID.',
      );
    }

    final List<String> ids = <String>[];
    final Set<String> uniqueIds = <String>{};

    for (final String value in destinationIds) {
      final String id = value.trim();
      if (id.isEmpty) {
        throw ArgumentError.value(
          destinationIds,
          'destinationIds',
          'Must not contain blank destination IDs.',
        );
      }
      if (!uniqueIds.add(id)) {
        throw ArgumentError.value(
          destinationIds,
          'destinationIds',
          'Must not contain duplicate destination IDs.',
        );
      }
      ids.add(id);
    }

    return List<String>.unmodifiable(ids);
  }
}
