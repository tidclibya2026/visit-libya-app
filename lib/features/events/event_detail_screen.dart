import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';
import '../../data/models/tourism_event.dart';
import 'widgets/event_card.dart';
import 'widgets/event_date_label.dart';
import 'widgets/event_status_badge.dart';
import 'widgets/official_verification_notice.dart';

class EventDetailScreen extends StatelessWidget {
  final TourismEvent event;

  const EventDetailScreen({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(event.title(locale))),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: <Widget>[
          EventVisual(imagePath: event.image),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: <Widget>[
                        EventCategoryBadge(category: event.category),
                        EventStatusBadge(status: event.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      event.title(locale),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _DetailLocation(label: event.location(locale)),
                    const SizedBox(height: AppSpacing.sm),
                    EventDateLabel(event: event),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      event.summary(locale),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      event.description(locale),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    if (event.requiresOfficialVerification) ...<Widget>[
                      const SizedBox(height: AppSpacing.xl),
                      const OfficialVerificationNotice(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailLocation extends StatelessWidget {
  final String label;

  const _DetailLocation({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(Icons.location_on_outlined, size: 20),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
