import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: <Widget>[
            Text(
              context.l10n.discoverLibya,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.deepNavy,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.heroSubtitle,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.warmGray),
            ),
            const SizedBox(height: AppSpacing.xl),
            _FoundationCard(
              icon: Icons.place_rounded,
              title: context.l10n.featuredDestinations,
              subtitle: context.l10n.exploreDestinations,
            ),
            const SizedBox(height: AppSpacing.md),
            _FoundationCard(
              icon: Icons.travel_explore_rounded,
              title: context.l10n.exploreByExperience,
              subtitle: context.l10n.heritageAndCivilizations,
            ),
            const SizedBox(height: AppSpacing.md),
            _FoundationCard(
              icon: Icons.reviews_rounded,
              title: context.l10n.expertReviewBuild,
              subtitle: context.l10n.tagline,
            ),
          ],
        ),
      ),
    );
  }
}

class _FoundationCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FoundationCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: <Widget>[
            Icon(icon, color: AppColors.mediterraneanBlue),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(subtitle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
