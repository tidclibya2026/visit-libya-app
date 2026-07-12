import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/tourism_event.dart';
import '../../../data/repositories/event_repository.dart';
import '../../events/event_detail_screen.dart';
import '../../events/events_screen.dart';
import '../../events/widgets/event_date_label.dart';
import '../../events/widgets/event_status_badge.dart';
import '../../events/widgets/official_verification_notice.dart';

class EventsHighlightsSection extends StatefulWidget {
  final EventRepository repository;

  const EventsHighlightsSection({
    this.repository = const EventRepository(),
    super.key,
  });

  @override
  State<EventsHighlightsSection> createState() =>
      _EventsHighlightsSectionState();
}

class _EventsHighlightsSectionState extends State<EventsHighlightsSection> {
  static const int _maximumEventCount = 2;

  late Future<List<TourismEvent>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  void _loadEvents() {
    _eventsFuture = widget.repository.loadEvents();
  }

  void _retry() {
    setState(_loadEvents);
  }

  void _openEvent(TourismEvent event) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => EventDetailScreen(event: event)),
    );
  }

  void _openAllEvents() {
    Navigator.of(
      context,
    ).push<void>(MaterialPageRoute<void>(builder: (_) => const EventsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('homeEventsHighlightsSection'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  context.l10n.majorEventsAndHighlights,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            TextButton.icon(
              key: const Key('homeEventsViewAllButton'),
              onPressed: _openAllEvents,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(context.l10n.viewAll),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        FutureBuilder<List<TourismEvent>>(
          future: _eventsFuture,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<List<TourismEvent>> snapshot,
              ) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return _EventsHighlightsError(onRetry: _retry);
                }

                final List<TourismEvent> featured =
                    (snapshot.data ?? const <TourismEvent>[])
                        .where((TourismEvent event) => event.featured)
                        .take(_maximumEventCount)
                        .toList(growable: false);

                if (featured.isEmpty) {
                  return Center(child: Text(context.l10n.noResults));
                }

                return _EventsHighlightsLayout(
                  events: featured,
                  onTap: _openEvent,
                );
              },
        ),
      ],
    );
  }
}

class _EventsHighlightsLayout extends StatelessWidget {
  final List<TourismEvent> events;
  final ValueChanged<TourismEvent> onTap;

  const _EventsHighlightsLayout({required this.events, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 720) {
          final double cardWidth = constraints.maxWidth < 320
              ? constraints.maxWidth
              : 320;

          return SizedBox(
            height: 440,
            child: ListView.separated(
              key: const Key('homeEventsHorizontalList'),
              scrollDirection: Axis.horizontal,
              itemCount: events.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (BuildContext context, int index) {
                final TourismEvent event = events[index];

                return SizedBox(
                  width: cardWidth,
                  child: _CompactEventCard(
                    event: event,
                    onTap: () => onTap(event),
                  ),
                );
              },
            ),
          );
        }

        final double cardWidth = (constraints.maxWidth - AppSpacing.lg) / 2;

        return Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: events
              .map(
                (TourismEvent event) => SizedBox(
                  width: cardWidth,
                  child: _CompactEventCard(
                    event: event,
                    onTap: () => onTap(event),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _CompactEventCard extends StatelessWidget {
  final TourismEvent event;
  final VoidCallback onTap;

  const _CompactEventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    final String title = event.title(locale);

    return Semantics(
      button: true,
      label: title,
      child: Card(
        key: ValueKey<String>('homeEventCard-${event.id}'),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _EventThumbnail(imagePath: event.image),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
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
                  event.summary(locale),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                _EventLocation(label: event.location(locale)),
                const SizedBox(height: AppSpacing.sm),
                EventDateLabel(event: event),
                if (event.requiresOfficialVerification) ...<Widget>[
                  const SizedBox(height: AppSpacing.md),
                  OfficialVerificationNotice(
                    key: ValueKey<String>('homeEventVerification-${event.id}'),
                    compact: true,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EventThumbnail extends StatelessWidget {
  final String imagePath;

  const _EventThumbnail({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final Widget placeholder = ColoredBox(
      color: AppColors.surfaceHeritage,
      child: Center(
        child: Icon(
          Icons.event_available_rounded,
          color: AppColors.mediterraneanBlue,
          semanticLabel: context.l10n.imageUnavailable,
        ),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: SizedBox.square(
        dimension: 64,
        child: imagePath.isEmpty
            ? placeholder
            : Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => placeholder,
              ),
      ),
    );
  }
}

class _EventLocation extends StatelessWidget {
  final String label;

  const _EventLocation({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(
          Icons.location_on_outlined,
          size: 18,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}

class _EventsHighlightsError extends StatelessWidget {
  final VoidCallback onRetry;

  const _EventsHighlightsError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(context.l10n.unableToLoadContent),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              key: const Key('homeEventsRetryButton'),
              onPressed: onRetry,
              child: Text(context.l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
