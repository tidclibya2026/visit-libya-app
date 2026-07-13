import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/tourist_route.dart';

void main() {
  test('parses a valid bilingual tourist route', () {
    final TouristRoute route = TouristRoute.fromJson(_validRouteJson());

    expect(route.id, 'civilizations');
    expect(route.titleAr, 'مسار الحضارات');
    expect(route.titleEn, 'Civilizations Route');
    expect(route.destinationIds, <String>[
      'tripoli',
      'leptis-magna',
      'sabratha',
    ]);
    expect(route.status, TouristRouteStatus.draft);
    expect(route.featured, isTrue);
    expect(route.image, isEmpty);
    expect(route.requiresFieldVerification, isTrue);
  });

  test('provides Arabic and English localized helpers', () {
    final TouristRoute route = TouristRoute.fromJson(_validRouteJson());

    expect(route.title(const Locale('ar')), 'مسار الحضارات');
    expect(
      route.summary(const Locale('ar')),
      'يربط طرابلس ولبدة الكبرى وصبراتة.',
    );
    expect(route.title(const Locale('en')), 'Civilizations Route');
    expect(
      route.summary(const Locale('en')),
      'Connects Tripoli, Leptis Magna, and Sabratha.',
    );
  });

  test('parses all tourist route statuses', () {
    const Map<String, TouristRouteStatus> statuses =
        <String, TouristRouteStatus>{
          'draft': TouristRouteStatus.draft,
          'reviewed': TouristRouteStatus.reviewed,
          'approved': TouristRouteStatus.approved,
          'archived': TouristRouteStatus.archived,
        };

    for (final MapEntry<String, TouristRouteStatus> entry in statuses.entries) {
      final TouristRoute route = TouristRoute.fromJson(
        _validRouteJson(status: entry.key),
      );

      expect(route.status, entry.value, reason: entry.key);
    }
  });

  test('rejects an unknown tourist route status', () {
    expect(
      () => TouristRoute.fromJson(_validRouteJson(status: 'unknown')),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects missing required fields', () {
    const List<String> requiredFields = <String>[
      'id',
      'titleAr',
      'titleEn',
      'summaryAr',
      'summaryEn',
      'status',
      'image',
    ];

    for (final String field in requiredFields) {
      final Map<String, dynamic> json = _validRouteJson()..remove(field);

      expect(
        () => TouristRoute.fromJson(json),
        throwsA(isA<FormatException>()),
        reason: '$field must be required',
      );
    }
  });

  test('rejects non-boolean boolean fields', () {
    const List<String> booleanFields = <String>[
      'featured',
      'requiresFieldVerification',
    ];

    for (final String field in booleanFields) {
      final Map<String, dynamic> json = _validRouteJson()..[field] = 'true';

      expect(
        () => TouristRoute.fromJson(json),
        throwsA(isA<FormatException>()),
        reason: '$field must be a bool',
      );
    }
  });

  test('rejects an empty destination list', () {
    final Map<String, dynamic> json = _validRouteJson()
      ..['destinationIds'] = <String>[];

    expect(() => TouristRoute.fromJson(json), throwsA(isA<FormatException>()));
  });

  test('rejects a blank destination ID', () {
    final Map<String, dynamic> json = _validRouteJson()
      ..['destinationIds'] = <String>['tripoli', ' '];

    expect(() => TouristRoute.fromJson(json), throwsA(isA<FormatException>()));
  });

  test('rejects duplicate destination IDs consistently', () {
    final Map<String, dynamic> json = _validRouteJson()
      ..['destinationIds'] = <String>['tripoli', 'tripoli'];

    expect(() => TouristRoute.fromJson(json), throwsA(isA<FormatException>()));
  });

  test('stores destination IDs in an unmodifiable list', () {
    final TouristRoute route = TouristRoute.fromJson(_validRouteJson());

    expect(() => route.destinationIds.add('ubari'), throwsUnsupportedError);
  });

  test('defensively copies an externally supplied destination list', () {
    final List<String> destinationIds = <String>['tripoli', 'sabratha'];
    final TouristRoute route = TouristRoute(
      id: 'civilizations',
      titleAr: 'مسار الحضارات',
      titleEn: 'Civilizations Route',
      summaryAr: 'ملخص عربي.',
      summaryEn: 'English summary.',
      destinationIds: destinationIds,
      status: TouristRouteStatus.draft,
      featured: true,
      image: '',
      requiresFieldVerification: true,
    );

    destinationIds.add('ubari');

    expect(route.destinationIds, <String>['tripoli', 'sabratha']);
  });
}

Map<String, dynamic> _validRouteJson({String status = 'draft'}) {
  return <String, dynamic>{
    'id': 'civilizations',
    'titleAr': 'مسار الحضارات',
    'titleEn': 'Civilizations Route',
    'summaryAr': 'يربط طرابلس ولبدة الكبرى وصبراتة.',
    'summaryEn': 'Connects Tripoli, Leptis Magna, and Sabratha.',
    'destinationIds': <String>['tripoli', 'leptis-magna', 'sabratha'],
    'status': status,
    'featured': true,
    'image': '',
    'requiresFieldVerification': true,
  };
}
