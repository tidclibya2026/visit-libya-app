import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/tourism_event.dart';

class EventRepository {
  final AssetBundle? assetBundle;
  final String assetPath;

  const EventRepository({
    this.assetBundle,
    this.assetPath = 'assets/data/events.json',
  });

  Future<List<TourismEvent>> loadEvents() async {
    final String jsonString = await (assetBundle ?? rootBundle).loadString(
      assetPath,
    );
    final Object? decoded = jsonDecode(jsonString);

    if (decoded is! List<dynamic>) {
      throw const FormatException('Events JSON root must be an array.');
    }

    if (decoded.isEmpty) {
      throw const FormatException('Events dataset must not be empty.');
    }

    final Set<String> ids = <String>{};
    final List<TourismEvent> events = <TourismEvent>[];

    for (final Object? item in decoded) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Every event record must be an object.');
      }

      final TourismEvent event = TourismEvent.fromJson(item);

      if (!ids.add(event.id)) {
        throw FormatException('Duplicate event ID: ${event.id}');
      }

      events.add(event);
    }

    return List<TourismEvent>.unmodifiable(events);
  }
}
