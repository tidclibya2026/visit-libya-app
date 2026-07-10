import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/destination.dart';

void main() {
  Map<String, dynamic> validDestination() {
    return <String, dynamic>{
      'id': 'tripoli',
      'nameAr': 'طرابلس',
      'nameEn': 'Tripoli',
      'locationAr': 'شمال غرب ليبيا',
      'locationEn': 'Northwestern Libya',
      'categoryId': 'cities',
      'categoryAr': 'المدن',
      'categoryEn': 'Cities',
      'shortDescriptionAr': 'مدينة متوسطية',
      'shortDescriptionEn': 'A Mediterranean city',
      'descriptionAr': 'وصف عربي',
      'descriptionEn': 'English description',
      'whyVisitAr': 'سبب الزيارة',
      'whyVisitEn': 'Reason to visit',
      'image': '',
      'highlightsAr': <String>['المدينة القديمة'],
      'highlightsEn': <String>['Old City'],
    };
  }

  test('parses bilingual destination values', () {
    final Destination destination = Destination.fromJson(validDestination());

    expect(destination.id, 'tripoli');
    expect(destination.name(const Locale('ar')), 'طرابلس');
    expect(destination.name(const Locale('en')), 'Tripoli');
    expect(destination.highlights(const Locale('ar')), <String>[
      'المدينة القديمة',
    ]);
    expect(destination.highlights(const Locale('en')), <String>['Old City']);
  });

  test('matches Arabic and English search queries', () {
    final Destination destination = Destination.fromJson(validDestination());

    expect(destination.matchesQuery('طرابلس', const Locale('ar')), isTrue);
    expect(destination.matchesQuery('tripoli', const Locale('en')), isTrue);
    expect(destination.matchesQuery('desert', const Locale('en')), isFalse);
  });

  test('rejects empty required string fields', () {
    final Map<String, dynamic> json = validDestination()..['nameEn'] = '';

    expect(() => Destination.fromJson(json), throwsA(isA<FormatException>()));
  });

  test('rejects invalid highlight lists', () {
    final Map<String, dynamic> json = validDestination()
      ..['highlightsEn'] = <String>[];

    expect(() => Destination.fromJson(json), throwsA(isA<FormatException>()));
  });
}
