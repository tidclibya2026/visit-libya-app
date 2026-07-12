import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/tourism_event.dart';

String tourismEventDateLabel(BuildContext context, TourismEvent event) {
  final DateTime? startDate = event.startDate;
  final DateTime? endDate = event.endDate;

  if (startDate == null || endDate == null) {
    return context.l10n.eventDateToBeConfirmed;
  }

  final MaterialLocalizations localizations = MaterialLocalizations.of(context);
  final String start = localizations.formatFullDate(startDate);

  if (startDate == endDate) {
    return start;
  }

  return '$start - ${localizations.formatFullDate(endDate)}';
}

class EventDateLabel extends StatelessWidget {
  final TourismEvent event;

  const EventDateLabel({required this.event, super.key});

  @override
  Widget build(BuildContext context) {
    final String label = tourismEventDateLabel(context, event);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(
          Icons.calendar_month_outlined,
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
