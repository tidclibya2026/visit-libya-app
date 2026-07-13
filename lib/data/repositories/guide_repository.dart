import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/guide_intent.dart';

class GuideRepository {
  final AssetBundle? assetBundle;
  final String assetPath;

  const GuideRepository({
    this.assetBundle,
    this.assetPath = 'assets/data/guide_intents.json',
  });

  Future<List<GuideIntent>> loadIntents() async {
    final String jsonString = await (assetBundle ?? rootBundle).loadString(
      assetPath,
    );
    final Object? decoded = jsonDecode(jsonString);

    if (decoded is! List<dynamic>) {
      throw const FormatException('Guide intents JSON root must be an array.');
    }
    if (decoded.isEmpty) {
      throw const FormatException('Guide intents dataset must not be empty.');
    }

    final Set<String> ids = <String>{};
    final List<GuideIntent> intents = <GuideIntent>[];
    for (final Object? item in decoded) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'Every guide intent record must be an object.',
        );
      }

      final GuideIntent intent = GuideIntent.fromJson(item);
      if (!ids.add(intent.id)) {
        throw FormatException('Duplicate guide intent ID: ${intent.id}');
      }
      intents.add(intent);
    }

    return List<GuideIntent>.unmodifiable(intents);
  }
}
