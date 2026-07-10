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
}
