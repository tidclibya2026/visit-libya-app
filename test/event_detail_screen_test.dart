import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/data/models/tourism_event.dart';
import 'package:visit_libya_app/features/events/event_detail_screen.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('detail renders localized description and verification notice', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_detailApp(locale: 'ar'));
    await tester.pumpAndSettle();

    expect(find.text('الوصف الكامل للفعالية'), findsOneWidget);
    expect(
      find.text(
        'هذه المعلومات أولية. تحقق من الجهات الرسمية المختصة قبل الاعتماد عليها أو التخطيط للسفر.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('empty officialUrl does not render an external-link action', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_detailApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('eventOfficialLinkButton')), findsNothing);
    expect(find.byIcon(Icons.open_in_new_rounded), findsNothing);
  });
}

Widget _detailApp({String locale = 'en'}) {
  return MaterialApp(
    locale: Locale(locale),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: EventDetailScreen(event: _event()),
  );
}

TourismEvent _event() {
  return TourismEvent.fromJson(<String, dynamic>{
    'id': 'approved-event',
    'category': 'international',
    'status': 'provisional',
    'titleAr': 'فعالية معتمدة',
    'titleEn': 'Approved Event',
    'summaryAr': 'ملخص الفعالية',
    'summaryEn': 'Event summary',
    'descriptionAr': 'الوصف الكامل للفعالية',
    'descriptionEn': 'Full event description',
    'locationAr': 'طرابلس، ليبيا',
    'locationEn': 'Tripoli, Libya',
    'startDate': null,
    'endDate': null,
    'featured': true,
    'image': '',
    'officialUrl': '',
    'requiresOfficialVerification': true,
  });
}
