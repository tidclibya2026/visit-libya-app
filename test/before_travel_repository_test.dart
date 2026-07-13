import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/before_travel_item.dart';
import 'package:visit_libya_app/data/repositories/before_travel_repository.dart';

import 'support/before_travel_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('repository loads exactly eight before-travel records', () async {
    const BeforeTravelRepository repository = BeforeTravelRepository();

    expect(await repository.loadItems(), hasLength(8));
  });

  test('repository preserves the exact approved IDs and order', () async {
    const BeforeTravelRepository repository = BeforeTravelRepository();

    final List<String> ids = (await repository.loadItems())
        .map((BeforeTravelItem item) => item.id)
        .toList();

    expect(ids, approvedBeforeTravelIds);
  });

  test('repository data contains unique IDs', () async {
    const BeforeTravelRepository repository = BeforeTravelRepository();

    final List<BeforeTravelItem> items = await repository.loadItems();

    expect(items.map((BeforeTravelItem item) => item.id).toSet(), hasLength(8));
  });

  test('every record requires official verification', () async {
    const BeforeTravelRepository repository = BeforeTravelRepository();

    final List<BeforeTravelItem> items = await repository.loadItems();

    expect(
      items.every((BeforeTravelItem item) => item.requiresOfficialVerification),
      isTrue,
    );
  });

  test('every approved record is enabled', () async {
    const BeforeTravelRepository repository = BeforeTravelRepository();

    final List<BeforeTravelItem> items = await repository.loadItems();

    expect(items.every((BeforeTravelItem item) => item.enabled), isTrue);
  });

  test('repository rejects an empty dataset', () async {
    final BeforeTravelRepository repository = BeforeTravelRepository(
      assetBundle: TrackingBeforeTravelAssetBundle('[]'),
    );

    await expectLater(repository.loadItems(), throwsA(isA<FormatException>()));
  });

  test('repository rejects a non-array root', () async {
    final BeforeTravelRepository repository = BeforeTravelRepository(
      assetBundle: TrackingBeforeTravelAssetBundle('{}'),
    );

    await expectLater(repository.loadItems(), throwsA(isA<FormatException>()));
  });

  test('repository rejects a non-object record', () async {
    final BeforeTravelRepository repository = BeforeTravelRepository(
      assetBundle: TrackingBeforeTravelAssetBundle('["invalid"]'),
    );

    await expectLater(repository.loadItems(), throwsA(isA<FormatException>()));
  });

  test('repository rejects duplicate IDs', () async {
    final BeforeTravelRepository repository = BeforeTravelRepository(
      assetBundle: TrackingBeforeTravelAssetBundle(
        jsonEncode(<Map<String, dynamic>>[
          beforeTravelItemJson(),
          beforeTravelItemJson(),
        ]),
      ),
    );

    await expectLater(repository.loadItems(), throwsA(isA<FormatException>()));
  });

  test('repository result is unmodifiable', () async {
    final BeforeTravelRepository repository = BeforeTravelRepository(
      assetBundle: TrackingBeforeTravelAssetBundle(beforeTravelJson()),
    );

    final List<BeforeTravelItem> items = await repository.loadItems();

    expect(() => items.removeLast(), throwsUnsupportedError);
  });
}
