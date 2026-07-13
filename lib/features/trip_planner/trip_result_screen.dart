import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/destination.dart';
import '../../data/models/trip_plan.dart';
import '../../data/models/trip_preference.dart';
import 'trip_planner_localization.dart';

class TripResultScreen extends StatelessWidget {
  final Destination destination;
  final TripPreference preference;
  final TripPlan plan;

  TripResultScreen({
    required this.destination,
    required this.preference,
    required this.plan,
    super.key,
  }) : assert(destination.id == preference.destinationId),
       assert(destination.id == plan.destinationId);

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.tripResultTitle)),
      body: SafeArea(
        child: ListView(
          key: const Key('tripResultList'),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xxxl,
          ),
          children: <Widget>[
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      destination.name(locale),
                      key: const Key('tripResultDestination'),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: <Widget>[
                        _SummaryValue(
                          key: const Key('tripResultDuration'),
                          icon: Icons.calendar_today_outlined,
                          label: context.l10n.tripDurationDays(
                            plan.durationDays,
                          ),
                        ),
                        _SummaryValue(
                          key: const Key('tripResultStyle'),
                          icon: Icons.speed_rounded,
                          label: context.l10n.travelStyleLabel(
                            preference.travelStyle,
                          ),
                        ),
                        _SummaryValue(
                          key: const Key('tripResultGroup'),
                          icon: Icons.group_outlined,
                          label: context.l10n.tripGroupTypeLabel(
                            preference.groupType,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    _SectionHeading(context.l10n.itinerary),
                    const SizedBox(height: AppSpacing.md),
                    ...plan.days.map(
                      (TripDay day) => Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                        child: _TripDayPanel(day: day),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _SectionHeading(context.l10n.suggestedExperiences),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      key: const Key('tripSuggestedExperiences'),
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: plan.suggestedExperiences
                          .map(
                            (TripInterest interest) => Chip(
                              label: Text(
                                context.l10n.tripInterestLabel(interest),
                              ),
                            ),
                          )
                          .toList(growable: false),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    _SectionHeading(context.l10n.preparationNotes),
                    const SizedBox(height: AppSpacing.md),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceHeritage,
                        borderRadius: BorderRadius.circular(AppRadius.small),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          key: const Key('tripPreparationNotes'),
                          children: plan.preparationNotes
                              .map(
                                (PreparationNoteKey note) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.xs,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.check_circle_outline_rounded,
                                        size: 20,
                                        color: AppColors.oasisGreen,
                                      ),
                                      const SizedBox(width: AppSpacing.sm),
                                      Expanded(
                                        child: Text(
                                          context.l10n.preparationNoteLabel(
                                            note,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(growable: false),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    OutlinedButton.icon(
                      key: const Key('tripResultEditButton'),
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(context.l10n.editPreferences),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TripDayPanel extends StatelessWidget {
  final TripDay day;

  const _TripDayPanel({required this.day});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: Key('tripDay-${day.dayNumber}'),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.l10n.tripDayTitle(day.dayNumber),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.dayFocus,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: day.focusInterests
                  .map(
                    (TripInterest interest) => Chip(
                      label: Text(context.l10n.tripInterestLabel(interest)),
                    ),
                  )
                  .toList(growable: false),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              context.l10n.dailyActivities,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: AppSpacing.sm),
            ...day.activities.indexed.map(
              ((int, TripActivity) entry) => _ActivityRow(
                key: Key('tripActivity-${day.dayNumber}-${entry.$1}'),
                activity: entry.$2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final TripActivity activity;

  const _ActivityRow({required this.activity, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.schedule_rounded,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.tripActivitySlotLabel(activity.slot),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                Text(context.l10n.tripInterestLabel(activity.interest)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  final IconData icon;
  final String label;

  const _SummaryValue({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 18),
            const SizedBox(width: AppSpacing.sm),
            Text(label),
          ],
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  final String text;

  const _SectionHeading(this.text);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(text, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}
