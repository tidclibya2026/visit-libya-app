import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/localization/locale_controller.dart';
import '../../core/theme/app_spacing.dart';
import '../events/events_screen.dart';

class MoreScreen extends StatelessWidget {
  final LocaleController localeController;

  const MoreScreen({required this.localeController, super.key});

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
