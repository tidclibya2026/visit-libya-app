import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visit_libya_app/app/app_shell.dart';
import 'package:visit_libya_app/core/localization/locale_controller.dart';
import 'package:visit_libya_app/data/repositories/experience_repository.dart';
import 'package:visit_libya_app/features/home/home_screen.dart';
import 'package:visit_libya_app/features/home/widgets/explore_by_experience_section.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

void main() {
  const List<String> approvedIds = <String>[
    'heritage',
    'desert',
    'coast',
    'nature',
    'culture',
    'food',
    'festivals',
    'routes',
  ];

  testWidgets('renders all eight repository experiences', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_sectionApp());
    await _pumpData(tester);

    for (final String id in approvedIds) {
      expect(
        find.byKey(ValueKey<String>('experienceCard-$id')),
        findsOneWidget,
      );
    }
  });

  testWidgets('renders Arabic experience titles', (WidgetTester tester) async {
    await tester.pumpWidget(
      _sectionApp(
        locale: const Locale('ar'),
        repository: _controlledRepository(),
      ),
    );
    await _pumpData(tester);

    expect(find.text('استكشف حسب التجربة'), findsOneWidget);
    expect(find.text('التراث والحضارات'), findsOneWidget);
    expect(find.text('المسارات السياحية'), findsOneWidget);
  });

  testWidgets('renders English experience titles', (WidgetTester tester) async {
    await tester.pumpWidget(_sectionApp(repository: _controlledRepository()));
    await _pumpData(tester);

    expect(find.text('Explore by Experience'), findsOneWidget);
    expect(find.text('Heritage & Civilizations'), findsOneWidget);
    expect(find.text('Tourist Routes'), findsOneWidget);
  });

  testWidgets('experience card selects Explore tab index 1', (
    WidgetTester tester,
  ) async {
    final LocaleController localeController = LocaleController(
      initialLocale: const Locale('en'),
    );
    addTearDown(localeController.dispose);

    await tester.pumpWidget(_shellApp(localeController));
    await _pumpData(tester);
    await _scrollHomeToExperiences(tester);
    final Finder section = find.byKey(
      const Key('homeExploreExperienceSection'),
    );
    expect(section, findsOneWidget);
    await tester.ensureVisible(section);
    await tester.pump(const Duration(milliseconds: 300));
    expect(
      find.descendant(
        of: section,
        matching: find.text('Unable to load content'),
      ),
      findsNothing,
    );
    await _pumpUntilFound(
      tester,
      find.byKey(const ValueKey<String>('experienceCard-heritage')),
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('experienceCard-heritage')),
    );
    await tester.pump();

    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );
  });

  testWidgets('View All selects Explore tab index 1', (
    WidgetTester tester,
  ) async {
    final LocaleController localeController = LocaleController(
      initialLocale: const Locale('en'),
    );
    addTearDown(localeController.dispose);

    await tester.pumpWidget(_shellApp(localeController));
    await _pumpData(tester);
    await _scrollHomeToExperiences(tester);

    await tester.tap(find.byKey(const Key('homeExperienceViewAllButton')));
    await tester.pump();

    expect(
      tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
      1,
    );
  });

  testWidgets('localized error state retries and renders content', (
    WidgetTester tester,
  ) async {
    final _RecoveringAssetBundle assetBundle = _RecoveringAssetBundle(
      _testExperienceJson(),
    );

    await tester.pumpWidget(
      _sectionApp(repository: ExperienceRepository(assetBundle: assetBundle)),
    );
    await _pumpData(tester);

    expect(find.text('Unable to load content'), findsOneWidget);
    expect(assetBundle.loadCount, 1);

    await tester.tap(find.byKey(const Key('homeExperienceRetryButton')));
    await _pumpData(tester);

    expect(assetBundle.loadCount, 2);
    expect(
      find.byKey(const ValueKey<String>('experienceCard-heritage')),
      findsOneWidget,
    );
  });

  testWidgets('narrow horizontal layout renders without overflow', (
    WidgetTester tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 640);
    addTearDown(() {
      tester.view.resetDevicePixelRatio();
      tester.view.resetPhysicalSize();
    });

    await tester.pumpWidget(_sectionApp(repository: _controlledRepository()));
    await _pumpData(tester);

    expect(
      find.byKey(const Key('homeExperienceHorizontalList')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.drag(
      find.byKey(const Key('homeExperienceHorizontalList')),
      const Offset(-240, 0),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.takeException(), isNull);
  });
}

Widget _sectionApp({
  Locale locale = const Locale('en'),
  ExperienceRepository repository = const ExperienceRepository(),
}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ExploreByExperienceSection(
            repository: repository,
            onExplore: () {},
          ),
        ),
      ),
    ),
  );
}

Widget _shellApp(LocaleController localeController) {
  return MaterialApp(
    locale: localeController.locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: AppShell(
      localeController: localeController,
      homeExperienceRepository: _controlledRepository(),
    ),
  );
}

Future<void> _scrollHomeToExperiences(WidgetTester tester) async {
  await tester.drag(
    find
        .descendant(
          of: find.byType(HomeScreen),
          matching: find.byType(ListView),
        )
        .first,
    const Offset(0, -850),
  );
  await tester.pump(const Duration(milliseconds: 300));

  final Finder section = find.byKey(const Key('homeExploreExperienceSection'));
  await _pumpUntilFound(tester, section);
  await tester.ensureVisible(section);
  await _pumpData(tester);
}

Future<void> _pumpData(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (int attempt = 0; attempt < 50 && finder.evaluate().isEmpty; attempt++) {
    await tester.pump(const Duration(milliseconds: 100));
  }

  expect(finder, findsOneWidget);
}

ExperienceRepository _controlledRepository() {
  return ExperienceRepository(
    assetBundle: _JsonAssetBundle(_testExperienceJson()),
  );
}

String _testExperienceJson() {
  return jsonEncode(<Map<String, dynamic>>[
    <String, dynamic>{
      'id': 'heritage',
      'titleAr': 'التراث والحضارات',
      'titleEn': 'Heritage & Civilizations',
      'descriptionAr': 'اكتشف تاريخ ليبيا.',
      'descriptionEn': 'Discover Libya history.',
      'icon': 'museum',
      'image': '',
    },
    <String, dynamic>{
      'id': 'routes',
      'titleAr': 'المسارات السياحية',
      'titleEn': 'Tourist Routes',
      'descriptionAr': 'خطط لمسارات سياحية مترابطة.',
      'descriptionEn': 'Plan connected tourist routes.',
      'icon': 'route',
      'image': '',
    },
  ]);
}

class _JsonAssetBundle extends AssetBundle {
  final String contents;

  _JsonAssetBundle(this.contents);

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async => contents;
}

class _RecoveringAssetBundle extends AssetBundle {
  final String contents;
  int loadCount = 0;

  _RecoveringAssetBundle(this.contents);

  @override
  Future<ByteData> load(String key) {
    throw UnimplementedError('Binary loading is not required for this test.');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount += 1;

    if (loadCount == 1) {
      await Future<void>.delayed(Duration.zero);
      throw StateError('Controlled test failure');
    }

    return contents;
  }
}
