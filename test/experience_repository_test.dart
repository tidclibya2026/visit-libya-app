import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/experience.dart';
import 'package:visit_libya_app/data/repositories/experience_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const Set<String> approvedIds = <String>{
    'heritage',
    'desert',
    'coast',
    'nature',
    'culture',
    'food',
    'festivals',
    'routes',
  };

  test('loads exactly the approved experience dataset', () async {
    const ExperienceRepository repository = ExperienceRepository();
    final List<Experience> experiences = await repository.loadExperiences();
    final Set<String> ids = experiences
        .map((Experience experience) => experience.id)
        .toSet();

    expect(experiences, hasLength(8));
    expect(ids, hasLength(8));
    expect(ids, approvedIds);
    expect(
      experiences.every((Experience experience) => experience.image.isEmpty),
      isTrue,
    );
  });

  test('rejects an empty experience dataset', () async {
    final ExperienceRepository repository = ExperienceRepository(
      assetBundle: _JsonAssetBundle('[]'),
    );

    await expectLater(
      repository.loadExperiences(),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects duplicate experience IDs', () async {
    final ExperienceRepository repository = ExperienceRepository(
      assetBundle: _JsonAssetBundle(
        jsonEncode(<Map<String, dynamic>>[
          _validExperienceJson(id: 'heritage'),
          _validExperienceJson(id: 'heritage'),
        ]),
      ),
    );

    await expectLater(
      repository.loadExperiences(),
      throwsA(isA<FormatException>()),
    );
  });

  test('rejects a non-array JSON root', () async {
    final ExperienceRepository repository = ExperienceRepository(
      assetBundle: _JsonAssetBundle('{}'),
    );

    await expectLater(
      repository.loadExperiences(),
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

Map<String, dynamic> _validExperienceJson({required String id}) {
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
