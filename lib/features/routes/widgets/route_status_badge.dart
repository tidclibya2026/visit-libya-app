import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/tourist_route.dart';

String touristRouteStatusLabel(
  BuildContext context,
  TouristRouteStatus status,
) {
  return switch (status) {
    TouristRouteStatus.draft => context.l10n.routeStatusDraft,
    TouristRouteStatus.reviewed => context.l10n.routeStatusReviewed,
    TouristRouteStatus.approved => context.l10n.routeStatusApproved,
    TouristRouteStatus.archived => context.l10n.routeStatusArchived,
  };
}

class RouteStatusBadge extends StatelessWidget {
  final TouristRouteStatus status;

  const RouteStatusBadge({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    final String label = touristRouteStatusLabel(context, status);

    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Container(
          key: ValueKey<String>('routeStatus-${status.name}'),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.warning.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.warning,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
