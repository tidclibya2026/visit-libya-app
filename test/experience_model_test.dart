import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/experience.dart';

void main() {
  test('parses valid bilingual experience values', () {
    final Experience experience = Experience.fromJson(_validExperienceJson());

    expect(experience.id, 'heritage');
    expect(experience.titleAr, 'التراث والحضارات');
    expect(experience.titleEn, 'Heritage & Civilizations');
    expect(experience.icon, 'museum');
    expect(experience.image, isEmpty);
  });

  test('provides localized helpers and query matching', () {
    final Experience experience = Experience.fromJson(_validExperienceJson());

    expect(experience.title(const Locale('ar')), 'التراث والحضارات');
    expect(experience.description(const Locale('ar')), 'اكتشف تاريخ ليبيا.');
    expect(experience.title(const Locale('en')), 'Heritage & Civilizations');
    expect(
      experience.description(const Locale('en')),
      'Discover Libya history.',
    );
    expect(experience.matchesQuery('حضارات', const Locale('ar')), isTrue);
    expect(experience.matchesQuery('heritage', const Locale('en')), isTrue);
    expect(experience.matchesQuery('desert', const Locale('en')), isFalse);
  });

  test('rejects every invalid required field', () {
    const List<String> requiredFields = <String>[
      'id',
      'titleAr',
      'titleEn',
      'descriptionAr',
      'descriptionEn',
      'icon',
    ];

    for (final String field in requiredFields) {
      final Map<String, dynamic> missing = _validExperienceJson()
        ..remove(field);
      final Map<String, dynamic> empty = _validExperienceJson()..[field] = ' ';

      expect(
        () => Experience.fromJson(missing),
        throwsA(isA<FormatException>()),
        reason: '$field must be required',
      );
      expect(
        () => Experience.fromJson(empty),
        throwsA(isA<FormatException>()),
        reason: '$field must not be empty',
      );
    }
  });
}

Map<String, dynamic> _validExperienceJson({String id = 'heritage'}) {
  return <String, dynamic>{
    'id': id,
    'titleAr': 'التراث والحضارات',
    'titleEn': 'Heritage & Civilizations',
    'descriptionAr': 'اكتشف تاريخ ليبيا.',
    'descriptionEn': 'Discover Libya history.',
    'icon': 'museum',
    'image': '',
  };
}
