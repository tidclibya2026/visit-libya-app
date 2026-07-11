import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/experience.dart';

class ExperienceRepository {
  final AssetBundle? assetBundle;
  final String assetPath;

  const ExperienceRepository({
    this.assetBundle,
    this.assetPath = 'assets/data/experiences.json',
  });

  Future<List<Experience>> loadExperiences() async {
    final String jsonString = await (assetBundle ?? rootBundle).loadString(
      assetPath,
    );
    final Object? decoded = jsonDecode(jsonString);

    if (decoded is! List<dynamic>) {
      throw const FormatException('Experiences JSON root must be an array.');
    }

    if (decoded.isEmpty) {
      throw const FormatException('Experiences dataset must not be empty.');
    }

    final Set<String> ids = <String>{};
    final List<Experience> experiences = <Experience>[];

    for (final Object? item in decoded) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'Every experience record must be an object.',
        );
      }

      final Experience experience = Experience.fromJson(item);

      if (!ids.add(experience.id)) {
        throw FormatException('Duplicate experience ID: ${experience.id}');
      }

      experiences.add(experience);
    }

    return List<Experience>.unmodifiable(experiences);
  }
}
