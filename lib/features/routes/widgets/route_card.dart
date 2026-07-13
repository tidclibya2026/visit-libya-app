import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/destination.dart';
import '../../../data/models/tourist_route.dart';
import 'field_verification_notice.dart';
import 'route_status_badge.dart';
import 'route_stops_list.dart';

class RouteCard extends StatelessWidget {
  final TouristRoute route;
  final List<Destination> stops;
  final VoidCallback onTap;

  const RouteCard({
    required this.route,
    required this.stops,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);
    final String title = route.title(locale);

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
              RouteVisual(imagePath: route.image),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RouteStatusBadge(status: route.status),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      route.summary(locale),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    RouteStopsList(
                      routeId: route.id,
                      stops: stops,
                      showHeading: false,
                    ),
                    if (route.requiresFieldVerification) ...<Widget>[
                      const SizedBox(height: AppSpacing.md),
                      FieldVerificationNotice(
                        key: ValueKey<String>('routeVerification-${route.id}'),
                        compact: true,
                      ),
                    ],
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          context.l10n.viewDetails,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: AppColors.mediterraneanBlue,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: AppColors.mediterraneanBlue,
                        ),
                      ],
                    ),
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

class RouteVisual extends StatelessWidget {
  final String imagePath;

  const RouteVisual({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty) {
      return const _RouteImagePlaceholder();
    }

    return AspectRatio(
      aspectRatio: 16 / 7,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        semanticLabel: context.l10n.touristRoutes,
        errorBuilder: (_, _, _) => const _RouteImagePlaceholder(),
      ),
    );
  }
}

class _RouteImagePlaceholder extends StatelessWidget {
  const _RouteImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: context.l10n.imageUnavailable,
      child: ExcludeSemantics(
        child: AspectRatio(
          key: const Key('routeImagePlaceholder'),
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
                  Icons.route_rounded,
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
