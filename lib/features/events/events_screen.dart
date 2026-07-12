import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/tourism_event.dart';
import '../../data/repositories/event_repository.dart';
import 'event_detail_screen.dart';
import 'widgets/event_card.dart';

class EventsScreen extends StatefulWidget {
  final EventRepository repository;

  const EventsScreen({this.repository = const EventRepository(), super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  late Future<List<TourismEvent>> _eventsFuture;

  @override
  void initState() {
    super.initState();
    _eventsFuture = widget.repository.loadEvents();
  }

  void _retry() {
    setState(() {
      _eventsFuture = widget.repository.loadEvents();
    });
  }

  void _openEvent(TourismEvent event) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => EventDetailScreen(event: event)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.eventsAndHighlights)),
      body: FutureBuilder<List<TourismEvent>>(
        future: _eventsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<TourismEvent>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return _EventsError(onRetry: _retry);
              }

              return _EventsContent(
                events: snapshot.requireData,
                onTap: _openEvent,
              );
            },
      ),
    );
  }
}

class _EventsContent extends StatelessWidget {
  final List<TourismEvent> events;
  final ValueChanged<TourismEvent> onTap;

  const _EventsContent({required this.events, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double contentWidth = constraints.maxWidth > 1120
            ? 1120
            : constraints.maxWidth;
        final double availableWidth = contentWidth - (AppSpacing.xl * 2);
        final int columns = availableWidth >= 720 ? 2 : 1;
        final double cardWidth = columns == 2
            ? (availableWidth - AppSpacing.lg) / 2
            : availableWidth;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                children: events
                    .map(
                      (TourismEvent event) => SizedBox(
                        key: ValueKey<String>('eventCard-${event.id}'),
                        width: cardWidth,
                        child: EventCard(
                          event: event,
                          onTap: () => onTap(event),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _EventsError extends StatelessWidget {
  final VoidCallback onRetry;

  const _EventsError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.unableToLoadContent,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              key: const Key('eventsRetryButton'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
