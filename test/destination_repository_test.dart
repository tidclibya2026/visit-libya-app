import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/destination.dart';
import 'package:visit_libya_app/data/repositories/destination_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const Set<String> approvedIds = <String>{
    'tripoli',
    'leptis-magna',
    'sabratha',
    'ghadames',
    'akakus',
    'ubari',
    'green-mountain',
    'benghazi',
    'misrata',
    'nafusa-mountains',
  };

  test('loads exactly the approved destination dataset', () async {
    final DestinationRepository repository = DestinationRepository();
    final List<Destination> destinations = await repository.loadDestinations();
    final Set<String> ids = destinations
        .map((Destination item) => item.id)
        .toSet();

    expect(destinations, hasLength(10));
    expect(ids, hasLength(10));
    expect(ids, approvedIds);
    expect(
      destinations.every((Destination item) => item.nameEn.isNotEmpty),
      isTrue,
    );
    expect(
      destinations.every((Destination item) => item.nameAr.isNotEmpty),
      isTrue,
    );
  });

  test('rejects an empty destination dataset', () async {
    final DestinationRepository repository = DestinationRepository(
      assetBundle: _JsonAssetBundle('[]'),
    );

    await expectLater(
      repository.loadDestinations(),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects duplicate destination IDs', () async {
    final DestinationRepository repository = DestinationRepository(
      assetBundle: _JsonAssetBundle(
        jsonEncode(<Map<String, dynamic>>[
          _validDestinationJson(id: 'tripoli'),
          _validDestinationJson(id: 'tripoli'),
        ]),
      ),
    );

    await expectLater(
      repository.loadDestinations(),
      throwsA(isA<FormatException>()),
    );
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

Map<String, dynamic> _validDestinationJson({required String id}) {
  return <String, dynamic>{
    'id': id,
    'nameAr': 'طرابلس',
    'nameEn': 'Tripoli',
    'locationAr': 'شمال غرب ليبيا',
    'locationEn': 'Northwestern Libya',
    'categoryId': 'cities',
    'categoryAr': 'مدن',
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
