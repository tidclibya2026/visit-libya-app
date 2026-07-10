import 'package:flutter/widgets.dart';

class Destination {
  final String id;
  final String nameAr;
  final String nameEn;
  final String locationAr;
  final String locationEn;
  final String categoryId;
  final String categoryAr;
  final String categoryEn;
  final String shortDescriptionAr;
  final String shortDescriptionEn;
  final String descriptionAr;
  final String descriptionEn;
  final String whyVisitAr;
  final String whyVisitEn;
  final String image;
  final List<String> highlightsAr;
  final List<String> highlightsEn;

  const Destination({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.locationAr,
    required this.locationEn,
    required this.categoryId,
    required this.categoryAr,
    required this.categoryEn,
    required this.shortDescriptionAr,
    required this.shortDescriptionEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.whyVisitAr,
    required this.whyVisitEn,
    required this.image,
    required this.highlightsAr,
    required this.highlightsEn,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    final String id = _requiredString(json, 'id');

    return Destination(
      id: id,
      nameAr: _requiredString(json, 'nameAr'),
      nameEn: _requiredString(json, 'nameEn'),
      locationAr: _requiredString(json, 'locationAr'),
      locationEn: _requiredString(json, 'locationEn'),
      categoryId: _requiredString(json, 'categoryId'),
      categoryAr: _requiredString(json, 'categoryAr'),
      categoryEn: _requiredString(json, 'categoryEn'),
      shortDescriptionAr: _requiredString(json, 'shortDescriptionAr'),
      shortDescriptionEn: _requiredString(json, 'shortDescriptionEn'),
      descriptionAr: _requiredString(json, 'descriptionAr'),
      descriptionEn: _requiredString(json, 'descriptionEn'),
      whyVisitAr: _requiredString(json, 'whyVisitAr'),
      whyVisitEn: _requiredString(json, 'whyVisitEn'),
      image: _optionalString(json, 'image'),
      highlightsAr: _requiredStringList(json, 'highlightsAr'),
      highlightsEn: _requiredStringList(json, 'highlightsEn'),
    );
  }

  String name(Locale locale) => _isArabic(locale) ? nameAr : nameEn;

  String location(Locale locale) => _isArabic(locale) ? locationAr : locationEn;

  String category(Locale locale) => _isArabic(locale) ? categoryAr : categoryEn;

  String shortDescription(Locale locale) =>
      _isArabic(locale) ? shortDescriptionAr : shortDescriptionEn;

  String description(Locale locale) =>
      _isArabic(locale) ? descriptionAr : descriptionEn;

  String whyVisit(Locale locale) => _isArabic(locale) ? whyVisitAr : whyVisitEn;

  List<String> highlights(Locale locale) =>
      _isArabic(locale) ? highlightsAr : highlightsEn;

  bool matchesQuery(String query, Locale locale) {
    final String normalizedQuery = _normalize(query);

    if (normalizedQuery.isEmpty) {
      return true;
    }

    final String searchable = _normalize(
      <String>[
        id,
        categoryId,
        name(locale),
        location(locale),
        category(locale),
        shortDescription(locale),
        description(locale),
        whyVisit(locale),
        ...highlights(locale),
      ].join(' '),
    );

    return searchable.contains(normalizedQuery);
  }

  static bool _isArabic(Locale locale) => locale.languageCode == 'ar';

  static String _requiredString(Map<String, dynamic> json, String key) {
    final Object? value = json[key];

    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Destination field "$key" must be a non-empty string.',
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
      throw FormatException('Destination field "$key" must be a string.');
    }

    return value.trim();
  }

  static List<String> _requiredStringList(
    Map<String, dynamic> json,
    String key,
  ) {
    final Object? value = json[key];

    if (value is! List<dynamic> || value.isEmpty) {
      throw FormatException(
        'Destination field "$key" must be a non-empty string list.',
      );
    }

    final List<String> items = value
        .map((dynamic item) {
          if (item is! String || item.trim().isEmpty) {
            throw FormatException(
              'Destination field "$key" must contain only non-empty strings.',
            );
          }

          return item.trim();
        })
        .toList(growable: false);

    return List<String>.unmodifiable(items);
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
