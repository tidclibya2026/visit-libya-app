import 'package:flutter/widgets.dart';

enum BeforeTravelCategory {
  entryDocuments('entryDocuments'),
  health('health'),
  safety('safety'),
  money('money'),
  connectivity('connectivity'),
  transport('transport'),
  culture('culture'),
  weatherAndPacking('weatherAndPacking');

  final String id;

  const BeforeTravelCategory(this.id);

  static BeforeTravelCategory fromId(String id) {
    return switch (id) {
      'entryDocuments' => BeforeTravelCategory.entryDocuments,
      'health' => BeforeTravelCategory.health,
      'safety' => BeforeTravelCategory.safety,
      'money' => BeforeTravelCategory.money,
      'connectivity' => BeforeTravelCategory.connectivity,
      'transport' => BeforeTravelCategory.transport,
      'culture' => BeforeTravelCategory.culture,
      'weatherAndPacking' => BeforeTravelCategory.weatherAndPacking,
      _ => throw FormatException('Unknown before-travel category: $id'),
    };
  }
}

class BeforeTravelItem {
  final String id;
  final BeforeTravelCategory category;
  final String titleAr;
  final String titleEn;
  final String summaryAr;
  final String summaryEn;
  final List<String> checklistAr;
  final List<String> checklistEn;
  final bool requiresOfficialVerification;
  final bool enabled;

  BeforeTravelItem({
    required String id,
    required this.category,
    required String titleAr,
    required String titleEn,
    required String summaryAr,
    required String summaryEn,
    required List<String> checklistAr,
    required List<String> checklistEn,
    required this.requiresOfficialVerification,
    required this.enabled,
  }) : id = _validatedString(id, 'id'),
       titleAr = _validatedString(titleAr, 'titleAr'),
       titleEn = _validatedString(titleEn, 'titleEn'),
       summaryAr = _validatedString(summaryAr, 'summaryAr'),
       summaryEn = _validatedString(summaryEn, 'summaryEn'),
       checklistAr = _validatedChecklist(checklistAr, 'checklistAr'),
       checklistEn = _validatedChecklist(checklistEn, 'checklistEn');

  factory BeforeTravelItem.fromJson(Map<String, dynamic> json) {
    return BeforeTravelItem(
      id: _requiredString(json, 'id'),
      category: BeforeTravelCategory.fromId(_requiredString(json, 'category')),
      titleAr: _requiredString(json, 'titleAr'),
      titleEn: _requiredString(json, 'titleEn'),
      summaryAr: _requiredString(json, 'summaryAr'),
      summaryEn: _requiredString(json, 'summaryEn'),
      checklistAr: _requiredChecklist(json, 'checklistAr'),
      checklistEn: _requiredChecklist(json, 'checklistEn'),
      requiresOfficialVerification: _requiredBool(
        json,
        'requiresOfficialVerification',
      ),
      enabled: _requiredBool(json, 'enabled'),
    );
  }

  String title(Locale locale) => _isArabic(locale) ? titleAr : titleEn;

  String summary(Locale locale) => _isArabic(locale) ? summaryAr : summaryEn;

  List<String> checklist(Locale locale) =>
      _isArabic(locale) ? checklistAr : checklistEn;

  static bool _isArabic(Locale locale) => locale.languageCode == 'ar';

  static String _requiredString(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Before-travel field "$key" must be a non-empty string.',
      );
    }
    return value.trim();
  }

  static bool _requiredBool(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is! bool) {
      throw FormatException('Before-travel field "$key" must be a boolean.');
    }
    return value;
  }

  static List<String> _requiredChecklist(
    Map<String, dynamic> json,
    String key,
  ) {
    final Object? value = json[key];
    if (value is! List<dynamic> || value.isEmpty) {
      throw FormatException(
        'Before-travel field "$key" must be a non-empty string list.',
      );
    }

    return value
        .map((Object? entry) {
          if (entry is! String || entry.trim().isEmpty) {
            throw FormatException(
              'Before-travel field "$key" must contain non-empty strings.',
            );
          }
          return entry.trim();
        })
        .toList(growable: false);
  }

  static String _validatedString(String value, String name) {
    final String normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(value, name, 'Must not be blank.');
    }
    return normalized;
  }

  static List<String> _validatedChecklist(List<String> values, String name) {
    if (values.isEmpty) {
      throw ArgumentError.value(values, name, 'Must not be empty.');
    }

    final Set<String> identities = <String>{};
    final List<String> result = <String>[];
    for (final String value in values) {
      final String entry = value.trim();
      if (entry.isEmpty) {
        throw ArgumentError.value(values, name, 'Must not contain blanks.');
      }
      if (identities.add(_checklistIdentity(entry))) {
        result.add(entry);
      }
    }
    return List<String>.unmodifiable(result);
  }

  static String _checklistIdentity(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp('[أإآ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
