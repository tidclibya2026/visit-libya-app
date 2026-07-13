import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/repositories/guide_repository.dart';
import '../before_travel/before_travel_screen.dart';
import '../events/events_screen.dart';
import '../routes/routes_screen.dart';
import '../smart_guide/smart_guide_screen.dart';

class MoreScreen extends StatelessWidget {
  final LocaleController localeController;
  final GuideRepository smartGuideRepository;
  final ValueChanged<int>? onSelectTab;

  const MoreScreen({
    required this.localeController,
    this.smartGuideRepository = const GuideRepository(),
    this.onSelectTab,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.more)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: <Widget>[
          Card(
            child: ListTile(
              key: const Key('moreEventsTile'),
              leading: const Icon(Icons.event_available_rounded),
              title: Text(context.l10n.eventsAndHighlights),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (_) => const EventsScreen()),
                );
              },
            ),
          ),
          Card(
            child: SwitchListTile(
              value: localeController.isEnglish,
              onChanged: (_) => localeController.toggle(),
              title: Text(context.l10n.language),
              subtitle: Text(
                localeController.isArabic
                    ? context.l10n.arabic
                    : context.l10n.english,
              ),
              secondary: const Icon(Icons.language_rounded),
            ),
          ),
          Card(
            child: ListTile(
              key: const Key('moreRoutesTile'),
              leading: const Icon(Icons.route_rounded),
              title: Text(context.l10n.touristRoutes),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (_) => const RoutesScreen()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              key: const Key('moreSmartGuideTile'),
              leading: const Icon(Icons.assistant_outlined),
              title: Text(context.l10n.smartGuide),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => SmartGuideScreen(
                      repository: smartGuideRepository,
                      onSelectTab: (int index) {
                        Navigator.of(context).pop();
                        onSelectTab?.call(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              key: const Key('moreBeforeTravelTile'),
              leading: const Icon(Icons.fact_check_outlined),
              title: Text(context.l10n.beforeTravel),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => const BeforeTravelScreen(),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: Text(context.l10n.about),
              subtitle: Text(context.l10n.expertReviewBuild),
            ),
          ),
        ],
      ),
    );
  }
}
