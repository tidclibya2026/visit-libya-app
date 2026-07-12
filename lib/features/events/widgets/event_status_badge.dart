import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/tourism_event.dart';

String tourismEventCategoryLabel(
  BuildContext context,
  TourismEventCategory category,
) {
  return switch (category) {
    TourismEventCategory.international =>
      context.l10n.eventCategoryInternational,
    TourismEventCategory.national => context.l10n.eventCategoryNational,
    TourismEventCategory.festival => context.l10n.eventCategoryFestival,
    TourismEventCategory.seasonal => context.l10n.eventCategorySeasonal,
    TourismEventCategory.nominationAward =>
      context.l10n.eventCategoryNominationAward,
  };
}

String tourismEventStatusLabel(
  BuildContext context,
  TourismEventStatus status,
) {
  return switch (status) {
    TourismEventStatus.provisional => context.l10n.eventStatusProvisional,
    TourismEventStatus.announced => context.l10n.eventStatusAnnounced,
    TourismEventStatus.ongoing => context.l10n.eventStatusOngoing,
    TourismEventStatus.completed => context.l10n.eventStatusCompleted,
    TourismEventStatus.underReview => context.l10n.eventStatusUnderReview,
    TourismEventStatus.cancelled => context.l10n.eventStatusCancelled,
  };
}

class EventCategoryBadge extends StatelessWidget {
  final TourismEventCategory category;

  const EventCategoryBadge({required this.category, super.key});

  @override
  Widget build(BuildContext context) {
    final String label = tourismEventCategoryLabel(context, category);

    return _EventBadge(
      label: label,
      foregroundColor: AppColors.mediterraneanBlue,
      backgroundColor: AppColors.mediterraneanBlue.withValues(alpha: 0.1),
    );
  }
}

class EventStatusBadge extends StatelessWidget {
  final TourismEventStatus status;

  const EventStatusBadge({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    final String label = tourismEventStatusLabel(context, status);

    return _EventBadge(
      key: ValueKey<String>('eventStatus-${status.name}'),
      label: label,
      foregroundColor: AppColors.warning,
      backgroundColor: AppColors.warning.withValues(alpha: 0.1),
    );
  }
}

class _EventBadge extends StatelessWidget {
  final String label;
  final Color foregroundColor;
  final Color backgroundColor;

  const _EventBadge({
    required this.label,
    required this.foregroundColor,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: ExcludeSemantics(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: foregroundColor),
          ),
        ),
      ),
    );
  }
}
