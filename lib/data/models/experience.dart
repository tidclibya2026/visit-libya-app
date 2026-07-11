import 'package:flutter/widgets.dart';

class Experience {
  final String id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final String icon;
  final String image;

  const Experience({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.icon,
    required this.image,
  });

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      id: _requiredString(json, 'id'),
      titleAr: _requiredString(json, 'titleAr'),
      titleEn: _requiredString(json, 'titleEn'),
      descriptionAr: _requiredString(json, 'descriptionAr'),
      descriptionEn: _requiredString(json, 'descriptionEn'),
      icon: _requiredString(json, 'icon'),
      image: _optionalString(json, 'image'),
    );
  }

  String title(Locale locale) => _isArabic(locale) ? titleAr : titleEn;

  String description(Locale locale) =>
      _isArabic(locale) ? descriptionAr : descriptionEn;

  bool matchesQuery(String query, Locale locale) {
    final String normalizedQuery = _normalize(query);

    if (normalizedQuery.isEmpty) {
      return true;
    }

    final String searchable = _normalize(
      <String>[id, title(locale), description(locale), icon].join(' '),
    );

    return searchable.contains(normalizedQuery);
  }

  static bool _isArabic(Locale locale) => locale.languageCode == 'ar';

  static String _requiredString(Map<String, dynamic> json, String key) {
    final Object? value = json[key];

    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Experience field "$key" must be a non-empty string.',
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
      throw FormatException('Experience field "$key" must be a string.');
    }

    return value.trim();
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي');
  }
}
