import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/destination.dart';
import 'package:visit_libya_app/data/models/tourist_route.dart';
import 'package:visit_libya_app/data/repositories/destination_repository.dart';
import 'package:visit_libya_app/data/repositories/route_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const List<String> approvedRouteIds = <String>[
    'civilizations',
    'green-mountain',
    'desert',
    'oasis',
    'nafusa',
  ];

  test('loads exactly five tourist routes', () async {
    const RouteRepository repository = RouteRepository();

    final List<TouristRoute> routes = await repository.loadRoutes();

    expect(routes, hasLength(5));
  });

  test('loads the exact approved unique route IDs', () async {
    const RouteRepository repository = RouteRepository();

    final List<TouristRoute> routes = await repository.loadRoutes();
    final List<String> ids = routes
        .map((TouristRoute route) => route.id)
        .toList();

    expect(ids, approvedRouteIds);
    expect(ids.toSet(), hasLength(approvedRouteIds.length));
  });

  test('loads every tourist route as draft', () async {
    const RouteRepository repository = RouteRepository();

    final List<TouristRoute> routes = await repository.loadRoutes();

    expect(
      routes.every(
        (TouristRoute route) => route.status == TouristRouteStatus.draft,
      ),
      isTrue,
    );
  });

  test('loads every tourist route as featured', () async {
    const RouteRepository repository = RouteRepository();

    final List<TouristRoute> routes = await repository.loadRoutes();

    expect(routes.every((TouristRoute route) => route.featured), isTrue);
  });

  test('requires field verification for every tourist route', () async {
    const RouteRepository repository = RouteRepository();

    final List<TouristRoute> routes = await repository.loadRoutes();

    expect(
      routes.every((TouristRoute route) => route.requiresFieldVerification),
      isTrue,
    );
  });

  test('keeps every tourist route image empty', () async {
    const RouteRepository repository = RouteRepository();

    final List<TouristRoute> routes = await repository.loadRoutes();

    expect(routes.every((TouristRoute route) => route.image.isEmpty), isTrue);
  });

  test('preserves tourist route and destination order', () async {
    const RouteRepository repository = RouteRepository();

    final List<TouristRoute> routes = await repository.loadRoutes();

    expect(routes.map((TouristRoute route) => route.id), approvedRouteIds);
    expect(routes[0].destinationIds, <String>[
      'tripoli',
      'leptis-magna',
      'sabratha',
    ]);
    expect(routes[1].destinationIds, <String>['benghazi', 'green-mountain']);
    expect(routes[2].destinationIds, <String>['akakus', 'ubari']);
    expect(routes[3].destinationIds, <String>['ghadames', 'ubari']);
    expect(routes[4].destinationIds, <String>['tripoli', 'nafusa-mountains']);
  });

  test(
    'resolves every route destination through DestinationRepository',
    () async {
      const RouteRepository routeRepository = RouteRepository();
      const DestinationRepository destinationRepository =
          DestinationRepository();

      final List<TouristRoute> routes = await routeRepository.loadRoutes();
      final Set<String> destinationIds =
          (await destinationRepository.loadDestinations())
              .map((Destination destination) => destination.id)
              .toSet();

      expect(
        routes
            .expand((TouristRoute route) => route.destinationIds)
            .every(destinationIds.contains),
        isTrue,
      );
    },
  );

  test('rejects an unresolved destination reference', () async {
    final RouteRepository repository = RouteRepository(
      assetBundle: _JsonAssetBundle(
        jsonEncode(<Map<String, dynamic>>[
          _validRouteJson(destinationIds: <String>['unknown-destination']),
        ]),
      ),
    );

    await expectLater(repository.loadRoutes(), throwsA(isA<FormatException>()));
  });

  test('rejects an empty route dataset', () async {
    final RouteRepository repository = RouteRepository(
      assetBundle: _JsonAssetBundle('[]'),
    );

    await expectLater(repository.loadRoutes(), throwsA(isA<FormatException>()));
  });

  test('rejects duplicate route IDs', () async {
    final RouteRepository repository = RouteRepository(
      assetBundle: _JsonAssetBundle(
        jsonEncode(<Map<String, dynamic>>[
          _validRouteJson(),
          _validRouteJson(),
        ]),
      ),
    );

    await expectLater(repository.loadRoutes(), throwsA(isA<FormatException>()));
  });

  test('rejects a non-array JSON root', () async {
    final RouteRepository repository = RouteRepository(
      assetBundle: _JsonAssetBundle('{}'),
    );

    await expectLater(repository.loadRoutes(), throwsA(isA<FormatException>()));
  });

  test('rejects a non-object route record', () async {
    final RouteRepository repository = RouteRepository(
      assetBundle: _JsonAssetBundle('["not-an-object"]'),
    );

    await expectLater(repository.loadRoutes(), throwsA(isA<FormatException>()));
  });

  test('returns an unmodifiable tourist route list', () async {
    const RouteRepository repository = RouteRepository();

    final List<TouristRoute> routes = await repository.loadRoutes();

    expect(() => routes.removeLast(), throwsUnsupportedError);
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

Map<String, dynamic> _validRouteJson({
  List<String> destinationIds = const <String>['tripoli'],
}) {
  return <String, dynamic>{
    'id': 'test-route',
    'titleAr': 'مسار اختباري',
    'titleEn': 'Test Route',
    'summaryAr': 'ملخص عربي موجز.',
    'summaryEn': 'A concise English summary.',
    'destinationIds': destinationIds,
    'status': 'draft',
    'featured': true,
    'image': '',
    'requiresFieldVerification': true,
  };
}
