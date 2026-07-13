import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/destination.dart';
import '../../data/models/tourist_route.dart';
import '../../data/repositories/destination_repository.dart';
import '../../data/repositories/route_repository.dart';
import 'route_detail_screen.dart';
import 'widgets/route_card.dart';

class RoutesScreen extends StatefulWidget {
  final RouteRepository routeRepository;
  final DestinationRepository destinationRepository;

  const RoutesScreen({
    this.routeRepository = const RouteRepository(),
    this.destinationRepository = const DestinationRepository(),
    super.key,
  });

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  late Future<_ResolvedRoutes> _routesFuture;

  @override
  void initState() {
    super.initState();
    _routesFuture = _loadRoutes();
  }

  Future<_ResolvedRoutes> _loadRoutes() async {
    final List<TouristRoute> routes = await widget.routeRepository.loadRoutes();
    final List<Destination> destinations = await widget.destinationRepository
        .loadDestinations();
    final Map<String, Destination> destinationsById = <String, Destination>{
      for (final Destination destination in destinations)
        destination.id: destination,
    };
    final List<_ResolvedRoute> resolvedRoutes = routes
        .map(
          (TouristRoute route) => _ResolvedRoute(
            route: route,
            stops: route.destinationIds
                .map((String destinationId) {
                  final Destination? destination =
                      destinationsById[destinationId];
                  if (destination == null) {
                    throw StateError(
                      'Route ${route.id} has an unresolved destination.',
                    );
                  }
                  return destination;
                })
                .toList(growable: false),
          ),
        )
        .toList(growable: false);

    return _ResolvedRoutes(resolvedRoutes);
  }

  void _retry() {
    setState(() {
      _routesFuture = _loadRoutes();
    });
  }

  void _openRoute(_ResolvedRoute resolvedRoute) {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RouteDetailScreen(
          route: resolvedRoute.route,
          stops: resolvedRoute.stops,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.touristRoutes)),
      body: FutureBuilder<_ResolvedRoutes>(
        future: _routesFuture,
        builder:
            (BuildContext context, AsyncSnapshot<_ResolvedRoutes> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(
                    key: Key('routesLoadingIndicator'),
                  ),
                );
              }

              if (snapshot.hasError) {
                return _RoutesError(onRetry: _retry);
              }

              return _RoutesContent(
                routes: snapshot.requireData.routes,
                onTap: _openRoute,
              );
            },
      ),
    );
  }
}

class _RoutesContent extends StatelessWidget {
  final List<_ResolvedRoute> routes;
  final ValueChanged<_ResolvedRoute> onTap;

  const _RoutesContent({required this.routes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double horizontalPadding = constraints.maxWidth < 400
            ? AppSpacing.md
            : AppSpacing.xl;
        final double contentWidth = constraints.maxWidth > 1120
            ? 1120
            : constraints.maxWidth;
        final double availableWidth = contentWidth - (horizontalPadding * 2);
        final int columns = availableWidth >= 720 ? 2 : 1;
        final double cardWidth = columns == 2
            ? (availableWidth - AppSpacing.lg) / 2
            : availableWidth;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSpacing.xl,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Wrap(
                spacing: AppSpacing.lg,
                runSpacing: AppSpacing.lg,
                children: routes
                    .map(
                      (_ResolvedRoute resolvedRoute) => SizedBox(
                        key: ValueKey<String>(
                          'routeCard-${resolvedRoute.route.id}',
                        ),
                        width: cardWidth,
                        child: RouteCard(
                          route: resolvedRoute.route,
                          stops: resolvedRoute.stops,
                          onTap: () => onTap(resolvedRoute),
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

class _RoutesError extends StatelessWidget {
  final VoidCallback onRetry;

  const _RoutesError({required this.onRetry});

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
              key: const Key('routesRetryButton'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResolvedRoutes {
  final List<_ResolvedRoute> routes;

  _ResolvedRoutes(List<_ResolvedRoute> routes)
    : routes = List<_ResolvedRoute>.unmodifiable(routes);
}

class _ResolvedRoute {
  final TouristRoute route;
  final List<Destination> stops;

  _ResolvedRoute({required this.route, required List<Destination> stops})
    : stops = List<Destination>.unmodifiable(stops);
}
