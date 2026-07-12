import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/tourism_event.dart';

void main() {
  test('parses a valid dated event', () {
    final TourismEvent event = TourismEvent.fromJson(_datedEventJson());

    expect(event.id, 'libya-2027-rcme53');
    expect(event.startDate, DateTime(2027, 1, 7));
    expect(event.endDate, DateTime(2027, 1, 10));
    expect(event.featured, isTrue);
    expect(event.image, isEmpty);
    expect(event.officialUrl, isEmpty);
  });

  test('parses a valid undated candidacy event', () {
    final TourismEvent event = TourismEvent.fromJson(_undatedEventJson());

    expect(event.startDate, isNull);
    expect(event.endDate, isNull);
    expect(event.category, TourismEventCategory.nominationAward);
    expect(event.status, TourismEventStatus.underReview);
  });

  test('provides Arabic and English localized helpers', () {
    final TourismEvent event = TourismEvent.fromJson(_datedEventJson());

    expect(event.title(const Locale('ar')), 'عنوان عربي');
    expect(event.title(const Locale('en')), 'English title');
    expect(event.summary(const Locale('ar')), 'ملخص عربي');
    expect(event.summary(const Locale('en')), 'English summary');
    expect(event.description(const Locale('ar')), 'وصف عربي');
    expect(event.description(const Locale('en')), 'English description');
    expect(event.location(const Locale('ar')), 'طرابلس، ليبيا');
    expect(event.location(const Locale('en')), 'Tripoli, Libya');
  });

  test('parses approved category and status values', () {
    final TourismEvent dated = TourismEvent.fromJson(_datedEventJson());
    final TourismEvent undated = TourismEvent.fromJson(_undatedEventJson());

    expect(dated.category, TourismEventCategory.international);
    expect(dated.status, TourismEventStatus.provisional);
    expect(undated.category, TourismEventCategory.nominationAward);
    expect(undated.status, TourismEventStatus.underReview);
  });

  test('parses all tourism event category values', () {
    const Map<String, TourismEventCategory> categories =
        <String, TourismEventCategory>{
          'international': TourismEventCategory.international,
          'national': TourismEventCategory.national,
          'festival': TourismEventCategory.festival,
          'seasonal': TourismEventCategory.seasonal,
          'nominationAward': TourismEventCategory.nominationAward,
        };

    for (final MapEntry<String, TourismEventCategory> entry
        in categories.entries) {
      final TourismEvent event = TourismEvent.fromJson(
        _datedEventJson()..['category'] = entry.key,
      );

      expect(event.category, entry.value);
    }
  });

  test('parses all tourism event status values', () {
    const Map<String, TourismEventStatus> statuses =
        <String, TourismEventStatus>{
          'provisional': TourismEventStatus.provisional,
          'announced': TourismEventStatus.announced,
          'ongoing': TourismEventStatus.ongoing,
          'completed': TourismEventStatus.completed,
          'underReview': TourismEventStatus.underReview,
          'cancelled': TourismEventStatus.cancelled,
        };

    for (final MapEntry<String, TourismEventStatus> entry in statuses.entries) {
      final TourismEvent event = TourismEvent.fromJson(
        _datedEventJson()..['status'] = entry.key,
      );

      expect(event.status, entry.value);
    }
  });

  test('rejects datetime values', () {
    expect(
      () => TourismEvent.fromJson(
        _datedEventJson()..['startDate'] = '2027-01-07T10:00:00',
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('accepts a same-day date range', () {
    final TourismEvent event = TourismEvent.fromJson(
      _datedEventJson()
        ..['startDate'] = '2027-01-07'
        ..['endDate'] = '2027-01-07',
    );

    expect(event.startDate, DateTime(2027, 1, 7));
    expect(event.endDate, DateTime(2027, 1, 7));
  });

  test('rejects missing required strings and invalid boolean fields', () {
    const List<String> requiredStrings = <String>[
      'id',
      'category',
      'status',
      'titleAr',
      'titleEn',
      'summaryAr',
      'summaryEn',
      'descriptionAr',
      'descriptionEn',
      'locationAr',
      'locationEn',
    ];

    for (final String field in requiredStrings) {
      final Map<String, dynamic> missing = _datedEventJson()..remove(field);
      final Map<String, dynamic> blank = _datedEventJson()..[field] = ' ';

      expect(
        () => TourismEvent.fromJson(missing),
        throwsA(isA<FormatException>()),
        reason: '$field must be required',
      );
      expect(
        () => TourismEvent.fromJson(blank),
        throwsA(isA<FormatException>()),
        reason: '$field must not be blank',
      );
    }

    expect(
      () => TourismEvent.fromJson(_datedEventJson()..['featured'] = 'true'),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => TourismEvent.fromJson(
        _datedEventJson()..['requiresOfficialVerification'] = 1,
      ),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects unknown category and status values', () {
    expect(
      () =>
          TourismEvent.fromJson(_datedEventJson()..['category'] = 'conference'),
      throwsA(isA<FormatException>()),
    );
    expect(
      () => TourismEvent.fromJson(_datedEventJson()..['status'] = 'pending'),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects invalid or incomplete date ranges', () {
    final List<Map<String, dynamic>> invalidEvents = <Map<String, dynamic>>[
      _datedEventJson()..['endDate'] = null,
      _datedEventJson()..['startDate'] = null,
      _datedEventJson()
        ..['startDate'] = '2027-01-10'
        ..['endDate'] = '2027-01-07',
      _datedEventJson()..['startDate'] = '2027-1-07',
      _datedEventJson()..['startDate'] = '2027-02-30',
    ];

    for (final Map<String, dynamic> json in invalidEvents) {
      expect(
        () => TourismEvent.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    }
  });
}

Map<String, dynamic> _datedEventJson({String id = 'libya-2027-rcme53'}) {
  return <String, dynamic>{
    'id': id,
    'category': 'international',
    'status': 'provisional',
    'titleAr': 'عنوان عربي',
    'titleEn': 'English title',
    'summaryAr': 'ملخص عربي',
    'summaryEn': 'English summary',
    'descriptionAr': 'وصف عربي',
    'descriptionEn': 'English description',
    'locationAr': 'طرابلس، ليبيا',
    'locationEn': 'Tripoli, Libya',
    'startDate': '2027-01-07',
    'endDate': '2027-01-10',
    'featured': true,
    'image': '',
    'officialUrl': '',
    'requiresOfficialVerification': true,
  };
}

Map<String, dynamic> _undatedEventJson() {
  return <String, dynamic>{
    ..._datedEventJson(id: 'tripoli-islamic-tourism-capital-candidacy'),
    'category': 'nominationAward',
    'status': 'underReview',
    'startDate': null,
    'endDate': null,
  };
}
