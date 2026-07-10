import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/destination.dart';
import '../../shared/widgets/image_fallback.dart';

class DestinationDetailScreen extends StatelessWidget {
  final Destination destination;
  final VoidCallback onPlanTrip;

  const DestinationDetailScreen({
    required this.destination,
    required this.onPlanTrip,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(destination.name(locale))),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: destination.image.isEmpty
                  ? const ImageFallback()
                  : Image.asset(
                      destination.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ImageFallback(),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            destination.name(locale),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: AppColors.deepNavy,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            destination.location(locale),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.mediterraneanBlue,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(destination.description(locale)),
          const SizedBox(height: AppSpacing.xl),
          Text(
            context.l10n.whyVisit,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(destination.whyVisit(locale)),
          const SizedBox(height: AppSpacing.xl),
          Text(
            context.l10n.topExperiences,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          ...destination
              .highlights(locale)
              .map(
                (String highlight) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.oasisGreen,
                        size: 20,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(highlight)),
                    ],
                  ),
                ),
              ),
          const SizedBox(height: AppSpacing.xl),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              onPlanTrip();
            },
            icon: const Icon(Icons.route_rounded),
            label: Text(context.l10n.planYourTrip),
          ),
        ],
      ),
    );
  }
}
