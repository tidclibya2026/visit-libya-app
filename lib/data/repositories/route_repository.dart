import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/destination.dart';
import '../models/tourist_route.dart';
import 'destination_repository.dart';

class RouteRepository {
  final AssetBundle? assetBundle;
  final String assetPath;
  final DestinationRepository destinationRepository;

  const RouteRepository({
    this.assetBundle,
    this.assetPath = 'assets/data/routes.json',
    this.destinationRepository = const DestinationRepository(),
  });

  Future<List<TouristRoute>> loadRoutes() async {
    final String jsonString = await (assetBundle ?? rootBundle).loadString(
      assetPath,
    );
    final Object? decoded = jsonDecode(jsonString);

    if (decoded is! List<dynamic>) {
      throw const FormatException('Routes JSON root must be an array.');
    }

    if (decoded.isEmpty) {
      throw const FormatException('Routes dataset must not be empty.');
    }

    final Set<String> routeIds = <String>{};
    final List<TouristRoute> routes = <TouristRoute>[];

    for (final Object? item in decoded) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('Every route record must be an object.');
      }

      final TouristRoute route = TouristRoute.fromJson(item);
      if (!routeIds.add(route.id)) {
        throw FormatException('Duplicate tourist route ID: ${route.id}');
      }
      routes.add(route);
    }

    final List<Destination> destinations = await destinationRepository
        .loadDestinations();
    final Set<String> destinationIds = destinations
        .map((Destination destination) => destination.id)
        .toSet();

    for (final TouristRoute route in routes) {
      for (final String destinationId in route.destinationIds) {
        if (!destinationIds.contains(destinationId)) {
          throw FormatException(
            'Unresolved destination ID "$destinationId" in route '
            '"${route.id}".',
          );
        }
      }
    }

    return List<TouristRoute>.unmodifiable(routes);
  }
}
