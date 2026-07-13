import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/before_travel_item.dart';

class BeforeTravelRepository {
  final AssetBundle? assetBundle;
  final String assetPath;

  const BeforeTravelRepository({
    this.assetBundle,
    this.assetPath = 'assets/data/before_travel.json',
  });

  Future<List<BeforeTravelItem>> loadItems() async {
    final String jsonString = await (assetBundle ?? rootBundle).loadString(
      assetPath,
    );
    final Object? decoded = jsonDecode(jsonString);

    if (decoded is! List<dynamic>) {
      throw const FormatException('Before-travel JSON root must be an array.');
    }
    if (decoded.isEmpty) {
      throw const FormatException('Before-travel dataset must not be empty.');
    }

    final Set<String> ids = <String>{};
    final List<BeforeTravelItem> items = <BeforeTravelItem>[];
    for (final Object? record in decoded) {
      if (record is! Map<String, dynamic>) {
        throw const FormatException(
          'Every before-travel record must be an object.',
        );
      }

      final BeforeTravelItem item = BeforeTravelItem.fromJson(record);
      if (!ids.add(item.id)) {
        throw FormatException('Duplicate before-travel ID: ${item.id}');
      }
      items.add(item);
    }

    return List<BeforeTravelItem>.unmodifiable(items);
  }
}
