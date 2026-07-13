import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/before_travel_item.dart';

import 'support/before_travel_test_support.dart';

void main() {
  test('parses a valid bilingual before-travel item', () {
    final BeforeTravelItem item = BeforeTravelItem.fromJson(
      beforeTravelItemJson(),
    );

    expect(item.id, 'entry-documents');
    expect(item.titleAr, 'الدخول والوثائق');
    expect(item.titleEn, 'Entry and Documents');
    expect(item.requiresOfficialVerification, isTrue);
    expect(item.enabled, isTrue);
  });

  test('parses all eight before-travel categories', () {
    for (final BeforeTravelCategory category in BeforeTravelCategory.values) {
      final BeforeTravelItem item = BeforeTravelItem.fromJson(
        beforeTravelItemJson(category: category.id),
      );
      expect(item.category, category);
    }
  });

  test('rejects an unknown before-travel category', () {
    expect(
      () =>
          BeforeTravelItem.fromJson(beforeTravelItemJson(category: 'unknown')),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects a missing required string', () {
    final Map<String, dynamic> json = beforeTravelItemJson()..remove('titleEn');

    expect(
      () => BeforeTravelItem.fromJson(json),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects a non-boolean required flag', () {
    final Map<String, dynamic> json = beforeTravelItemJson()
      ..['enabled'] = 'true';

    expect(
      () => BeforeTravelItem.fromJson(json),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects an empty bilingual checklist', () {
    expect(
      () => BeforeTravelItem.fromJson(
        beforeTravelItemJson(checklistEn: <String>[]),
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects a blank checklist entry', () {
    expect(
      () => BeforeTravelItem.fromJson(
        beforeTravelItemJson(checklistAr: <String>['صالح', '  ']),
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('normalizes duplicate checklist entries in stable order', () {
    final BeforeTravelItem item = BeforeTravelItem.fromJson(
      beforeTravelItemJson(
        checklistEn: <String>['Check this', ' check   this ', 'Keep this'],
      ),
    );

    expect(item.checklistEn, <String>['Check this', 'Keep this']);
  });

  test('input-list mutation cannot affect the model', () {
    final List<String> arabic = <String>['بند عربي'];
    final List<String> english = <String>['English item'];
    final BeforeTravelItem item = BeforeTravelItem(
      id: 'test',
      category: BeforeTravelCategory.health,
      titleAr: 'عنوان',
      titleEn: 'Title',
      summaryAr: 'ملخص',
      summaryEn: 'Summary',
      checklistAr: arabic,
      checklistEn: english,
      requiresOfficialVerification: true,
      enabled: true,
    );

    arabic.add('تغيير');
    english.add('Mutation');

    expect(item.checklistAr, <String>['بند عربي']);
    expect(item.checklistEn, <String>['English item']);
  });

  test('stored checklist lists are unmodifiable', () {
    final BeforeTravelItem item = BeforeTravelItem.fromJson(
      beforeTravelItemJson(),
    );

    expect(() => item.checklistAr.add('تغيير'), throwsUnsupportedError);
    expect(() => item.checklistEn.removeLast(), throwsUnsupportedError);
  });

  test('localized helpers return Arabic and English content', () {
    final BeforeTravelItem item = BeforeTravelItem.fromJson(
      beforeTravelItemJson(),
    );

    expect(item.title(const Locale('ar')), item.titleAr);
    expect(item.title(const Locale('en')), item.titleEn);
    expect(item.summary(const Locale('ar')), item.summaryAr);
    expect(item.summary(const Locale('en')), item.summaryEn);
    expect(item.checklist(const Locale('ar')), item.checklistAr);
    expect(item.checklist(const Locale('en')), item.checklistEn);
  });
}
