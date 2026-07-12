import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/tourism_event.dart';
import 'event_date_label.dart';
import 'event_status_badge.dart';
import 'official_verification_notice.dart';

class EventCard extends StatelessWidget {
  final TourismEvent event;
  final VoidCallback onTap;

  const EventCard({required this.event, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    final String title = event.title(locale);

    return Semantics(
      button: true,
      label: title,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              EventVisual(imagePath: event.image),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
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
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      event.summary(locale),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _LocationLabel(label: event.location(locale)),
                    const SizedBox(height: AppSpacing.sm),
                    EventDateLabel(event: event),
                    if (event.requiresOfficialVerification) ...<Widget>[
                      const SizedBox(height: AppSpacing.md),
                      OfficialVerificationNotice(
                        key: ValueKey<String>('eventVerification-${event.id}'),
                        compact: true,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventVisual extends StatelessWidget {
  final String imagePath;

  const EventVisual({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return const _EventImagePlaceholder();
    }

    return AspectRatio(
      aspectRatio: 16 / 7,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        semanticLabel: context.l10n.eventsAndHighlights,
        errorBuilder: (_, _, _) => const _EventImagePlaceholder(),
      ),
    );
  }
}

class _EventImagePlaceholder extends StatelessWidget {
  const _EventImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: context.l10n.imageUnavailable,
      child: ExcludeSemantics(
        child: AspectRatio(
          aspectRatio: 16 / 7,
          child: ColoredBox(
            color: AppColors.surfaceHeritage,
            child: Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: const Icon(
                  Icons.event_available_rounded,
                  size: 34,
                  color: AppColors.mediterraneanBlue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LocationLabel extends StatelessWidget {
  final String label;

  const _LocationLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.location_on_outlined,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(label, style: Theme.of(context).textTheme.bodySmall),
        ),
      ],
    );
  }
}
