import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/destination.dart';

class RouteStopsList extends StatelessWidget {
  final String routeId;
  final List<Destination> stops;
  final bool showHeading;

  const RouteStopsList({
    required this.routeId,
    required this.stops,
    required this.showHeading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showHeading) ...<Widget>[
          Text(
            context.l10n.routeStops,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.xs),
        ],
        Text(
          context.l10n.routeStopCount(stops.length),
          key: ValueKey<String>('routeStopCount-$routeId'),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        ...List<Widget>.generate(stops.length, (int index) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == stops.length - 1 ? 0 : AppSpacing.sm,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.mediterraneanBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.mediterraneanBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    stops[index].name(locale),
                    key: ValueKey<String>('routeStop-$routeId-$index'),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
