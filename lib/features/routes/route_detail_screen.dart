import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/destination.dart';
import '../../data/models/tourist_route.dart';
import 'widgets/field_verification_notice.dart';
import 'widgets/route_card.dart';
import 'widgets/route_status_badge.dart';
import 'widgets/route_stops_list.dart';

class RouteDetailScreen extends StatelessWidget {
  final TouristRoute route;
  final List<Destination> stops;

  RouteDetailScreen({
    required this.route,
    required List<Destination> stops,
    super.key,
  }) : stops = List<Destination>.unmodifiable(stops);

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.routeDetails)),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: <Widget>[
          RouteVisual(imagePath: route.image),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RouteStatusBadge(status: route.status),
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      route.title(locale),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      route.summary(locale),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    RouteStopsList(
                      routeId: route.id,
                      stops: stops,
                      showHeading: true,
                    ),
                    if (route.requiresFieldVerification) ...<Widget>[
                      const SizedBox(height: AppSpacing.xl),
                      const FieldVerificationNotice(
                        key: Key('routeFieldVerificationNotice'),
                      ),
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
