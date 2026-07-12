import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/tourism_event.dart';
import 'package:visit_libya_app/data/repositories/event_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const Set<String> approvedIds = <String>{
    'libya-2027-rcme53',
    'tripoli-islamic-tourism-capital-candidacy',
  };

  test('loads exactly two event records', () async {
    const EventRepository repository = EventRepository();
    final List<TourismEvent> events = await repository.loadEvents();

    expect(events, hasLength(2));
  });

  test('loads both approved unique event IDs', () async {
    const EventRepository repository = EventRepository();
    final List<TourismEvent> events = await repository.loadEvents();
    final Set<String> ids = events
        .map((TourismEvent event) => event.id)
        .toSet();

    expect(ids, hasLength(2));
    expect(ids, approvedIds);
  });

  test('requires official verification for both records', () async {
    const EventRepository repository = EventRepository();
    final List<TourismEvent> events = await repository.loadEvents();

    expect(
      events.every((TourismEvent event) => event.requiresOfficialVerification),
      isTrue,
    );
  });

  test('rejects an empty event dataset', () async {
    final EventRepository repository = EventRepository(
      assetBundle: _JsonAssetBundle('[]'),
    );

    await expectLater(repository.loadEvents(), throwsA(isA<FormatException>()));
  });

  test('rejects duplicate event IDs', () async {
    final EventRepository repository = EventRepository(
      assetBundle: _JsonAssetBundle(
        jsonEncode(<Map<String, dynamic>>[
          _validEventJson(id: 'duplicate'),
          _validEventJson(id: 'duplicate'),
        ]),
      ),
    );

    await expectLater(repository.loadEvents(), throwsA(isA<FormatException>()));
  });

  test('rejects a non-array JSON root', () async {
    final EventRepository repository = EventRepository(
      assetBundle: _JsonAssetBundle('{}'),
    );

    await expectLater(repository.loadEvents(), throwsA(isA<FormatException>()));
  });
}

class _JsonAssetBundle extends AssetBundle {
  final String json;

  _JsonAssetBundle(this.json);

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async => json;
}

Map<String, dynamic> _validEventJson({required String id}) {
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
