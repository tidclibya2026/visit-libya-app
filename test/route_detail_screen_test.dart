import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/destination.dart';
import 'package:visit_libya_app/data/models/tourist_route.dart';
import 'package:visit_libya_app/features/routes/route_detail_screen.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('detail renders title summary status and ordered stops', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_detailApp());

    expect(find.text('Route Details'), findsOneWidget);
    expect(find.text('Civilizations Route'), findsOneWidget);
    expect(
      find.text('Connects Tripoli, Leptis Magna, and Sabratha.'),
      findsOneWidget,
    );
    expect(find.text('Draft'), findsOneWidget);
    expect(find.text('Route Stops'), findsOneWidget);
    expect(find.text('Stops: 3'), findsOneWidget);

    final Finder tripoli = find.byKey(const Key('routeStop-civilizations-0'));
    final Finder leptis = find.byKey(const Key('routeStop-civilizations-1'));
    final Finder sabratha = find.byKey(const Key('routeStop-civilizations-2'));
    expect(tester.widget<Text>(tripoli).data, 'Tripoli');
    expect(tester.widget<Text>(leptis).data, 'Leptis Magna');
    expect(tester.widget<Text>(sabratha).data, 'Sabratha');
  });

  testWidgets('detail renders the approved bilingual verification notice', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_detailApp());

    expect(
      find.text(
        'This route is a working draft and requires field verification before approval or travel planning.',
      ),
      findsOneWidget,
    );

    await tester.pumpWidget(_detailApp(locale: 'ar'));

    expect(
      find.text(
        'هذا المسار مسودة عمل ويتطلب التحقق الميداني قبل الاعتماد أو التخطيط للسفر.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('detail contains no unsupported route claims', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_detailApp());

    for (final String claim in <String>[
      'Map',
      'Coordinates',
      'Distance',
      'Duration',
      'Price',
      'Hotel',
      'Transport',
      'Booking',
      'Schedule',
      'Safety guarantee',
      'http',
    ]) {
      expect(find.textContaining(claim, findRichText: true), findsNothing);
    }
  });
}

Widget _detailApp({String locale = 'en'}) {
  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: RouteDetailScreen(route: _route(), stops: _stops()),
  );
}

TouristRoute _route() {
  return TouristRoute.fromJson(<String, dynamic>{
    'id': 'civilizations',
    'titleAr': 'مسار الحضارات',
    'titleEn': 'Civilizations Route',
    'summaryAr': 'يربط طرابلس ولبدة الكبرى وصبراتة.',
    'summaryEn': 'Connects Tripoli, Leptis Magna, and Sabratha.',
    'destinationIds': <String>['tripoli', 'leptis-magna', 'sabratha'],
    'status': 'draft',
    'featured': true,
    'image': '',
    'requiresFieldVerification': true,
  });
}

List<Destination> _stops() {
  return <Destination>[
    _destination('tripoli', 'طرابلس', 'Tripoli'),
    _destination('leptis-magna', 'لبدة الكبرى', 'Leptis Magna'),
    _destination('sabratha', 'صبراتة', 'Sabratha'),
  ];
}

Destination _destination(String id, String nameAr, String nameEn) {
  return Destination.fromJson(<String, dynamic>{
    'id': id,
    'nameAr': nameAr,
    'nameEn': nameEn,
    'locationAr': 'ليبيا',
    'locationEn': 'Libya',
    'categoryId': 'route-stop',
    'categoryAr': 'محطة مسار',
    'categoryEn': 'Route Stop',
    'shortDescriptionAr': 'وصف موجز للمحطة.',
    'shortDescriptionEn': 'A short stop description.',
    'descriptionAr': 'وصف المحطة.',
    'descriptionEn': 'Stop description.',
    'whyVisitAr': 'لزيارة المحطة.',
    'whyVisitEn': 'To visit the stop.',
    'image': '',
    'highlightsAr': <String>['معلم'],
    'highlightsEn': <String>['Landmark'],
  });
}
