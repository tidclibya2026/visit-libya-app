import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/destination.dart';

class DestinationRepository {
  final AssetBundle? assetBundle;
  final String assetPath;

  const DestinationRepository({
    this.assetBundle,
    this.assetPath = 'assets/data/destinations.json',
  });

  Future<List<Destination>> loadDestinations() async {
    final String jsonString = await (assetBundle ?? rootBundle).loadString(
      assetPath,
    );
    final Object? decoded = jsonDecode(jsonString);

    if (decoded is! List<dynamic>) {
      throw const FormatException('Destinations JSON root must be an array.');
    }

    if (decoded.isEmpty) {
      throw const FormatException('Destinations dataset must not be empty.');
    }

    final Set<String> ids = <String>{};
    final List<Destination> destinations = <Destination>[];

    for (final Object? item in decoded) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException(
          'Every destination record must be an object.',
        );
      }

      final Destination destination = Destination.fromJson(item);

      if (!ids.add(destination.id)) {
        throw FormatException('Duplicate destination ID: ${destination.id}');
      }

      destinations.add(destination);
    }

    return List<Destination>.unmodifiable(destinations);
  }
}
