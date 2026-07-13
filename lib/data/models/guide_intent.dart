import 'package:flutter/widgets.dart';

enum GuideActionType {
  openTab('openTab'),
  openScreen('openScreen'),
  none('none');

  final String id;

  const GuideActionType(this.id);

  static GuideActionType fromId(String id) {
    return switch (id) {
      'openTab' => GuideActionType.openTab,
      'openScreen' => GuideActionType.openScreen,
      'none' => GuideActionType.none,
      _ => throw FormatException('Unknown guide action type: $id'),
    };
  }
}

class GuideIntent {
  final String id;
  final String category;
  final String promptAr;
  final String promptEn;
  final List<String> keywordsAr;
  final List<String> keywordsEn;
  final String answerAr;
  final String answerEn;
  final GuideActionType actionType;
  final String actionValue;
  final bool enabled;

  GuideIntent({
    required this.id,
    required this.category,
    required this.promptAr,
    required this.promptEn,
    required List<String> keywordsAr,
    required List<String> keywordsEn,
    required this.answerAr,
    required this.answerEn,
    required this.actionType,
    required this.actionValue,
    required this.enabled,
  }) : keywordsAr = _validatedKeywords(keywordsAr, 'keywordsAr'),
       keywordsEn = _validatedKeywords(keywordsEn, 'keywordsEn');

  factory GuideIntent.fromJson(Map<String, dynamic> json) {
    final GuideActionType actionType = GuideActionType.fromId(
      _requiredString(json, 'actionType'),
    );

    return GuideIntent(
      id: _requiredString(json, 'id'),
      category: _requiredString(json, 'category'),
      promptAr: _requiredString(json, 'promptAr'),
      promptEn: _requiredString(json, 'promptEn'),
      keywordsAr: _requiredKeywordList(json, 'keywordsAr'),
      keywordsEn: _requiredKeywordList(json, 'keywordsEn'),
      answerAr: _requiredString(json, 'answerAr'),
      answerEn: _requiredString(json, 'answerEn'),
      actionType: actionType,
      actionValue: _actionValue(json, actionType),
      enabled: _requiredBool(json, 'enabled'),
    );
  }

  String prompt(Locale locale) => _isArabic(locale) ? promptAr : promptEn;

  String answer(Locale locale) => _isArabic(locale) ? answerAr : answerEn;

  static bool _isArabic(Locale locale) => locale.languageCode == 'ar';

  static String _requiredString(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is! String || value.trim().isEmpty) {
      throw FormatException(
        'Guide intent field "$key" must be a non-empty string.',
      );
    }
    return value.trim();
  }

  static bool _requiredBool(Map<String, dynamic> json, String key) {
    final Object? value = json[key];
    if (value is! bool) {
      throw FormatException('Guide intent field "$key" must be a boolean.');
    }
    return value;
  }

  static String _actionValue(
    Map<String, dynamic> json,
    GuideActionType actionType,
  ) {
    final Object? value = json['actionValue'];
    if (value is! String) {
      throw const FormatException(
        'Guide intent field "actionValue" must be a string.',
      );
    }

    final String normalized = value.trim();
    if (actionType != GuideActionType.none && normalized.isEmpty) {
      throw const FormatException(
        'Guide navigation actions require a non-empty actionValue.',
      );
    }
    return normalized;
  }

  static List<String> _requiredKeywordList(
    Map<String, dynamic> json,
    String key,
  ) {
    final Object? value = json[key];
    if (value is! List<dynamic> || value.isEmpty) {
      throw FormatException(
        'Guide intent field "$key" must be a non-empty string list.',
      );
    }

    return value
        .map((Object? item) {
          if (item is! String || item.trim().isEmpty) {
            throw FormatException(
              'Guide intent field "$key" must contain non-empty strings.',
            );
          }
          return item.trim();
        })
        .toList(growable: false);
  }

  static List<String> _validatedKeywords(List<String> values, String name) {
    if (values.isEmpty) {
      throw ArgumentError.value(values, name, 'Must not be empty.');
    }

    final Set<String> identities = <String>{};
    final List<String> keywords = <String>[];
    for (final String value in values) {
      final String keyword = value.trim();
      if (keyword.isEmpty) {
        throw ArgumentError.value(values, name, 'Must not contain blanks.');
      }
      if (identities.add(_keywordIdentity(keyword))) {
        keywords.add(keyword);
      }
    }

    return List<String>.unmodifiable(keywords);
  }

  static String _keywordIdentity(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp('[أإآ]'), 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll('ى', 'ي')
        .replaceAll(RegExp(r'\s+'), ' ');
  }
}
