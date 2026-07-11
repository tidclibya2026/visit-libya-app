import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/experience.dart';
import '../../../data/repositories/experience_repository.dart';

class ExploreByExperienceSection extends StatefulWidget {
  final ExperienceRepository repository;
  final VoidCallback onExplore;

  const ExploreByExperienceSection({
    required this.onExplore,
    this.repository = const ExperienceRepository(),
    super.key,
  });

  @override
  State<ExploreByExperienceSection> createState() =>
      _ExploreByExperienceSectionState();
}

class _ExploreByExperienceSectionState
    extends State<ExploreByExperienceSection> {
  late Future<List<Experience>> _experiencesFuture;

  @override
  void initState() {
    super.initState();
    _loadExperiences();
  }

  void _loadExperiences() {
    _experiencesFuture = widget.repository.loadExperiences();
  }

  void _retry() {
    setState(_loadExperiences);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('homeExploreExperienceSection'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  context.l10n.exploreByExperience,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            TextButton.icon(
              key: const Key('homeExperienceViewAllButton'),
              onPressed: widget.onExplore,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(context.l10n.viewAll),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        FutureBuilder<List<Experience>>(
          future: _experiencesFuture,
          builder:
              (BuildContext context, AsyncSnapshot<List<Experience>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return _ExperienceErrorState(onRetry: _retry);
                }

                final List<Experience> experiences =
                    snapshot.data ?? const <Experience>[];

                if (experiences.isEmpty) {
                  return Center(child: Text(context.l10n.noResults));
                }

                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    if (constraints.maxWidth < 720) {
                      return SizedBox(
                        height: 244,
                        child: ListView.separated(
                          key: const Key('homeExperienceHorizontalList'),
                          scrollDirection: Axis.horizontal,
                          itemCount: experiences.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: AppSpacing.md),
                          itemBuilder: (BuildContext context, int index) {
                            return SizedBox(
                              width: 280,
                              child: _ExperienceCard(
                                experience: experiences[index],
                                onTap: widget.onExplore,
                              ),
                            );
                          },
                        ),
                      );
                    }

                    final int columnCount = constraints.maxWidth >= 1040
                        ? 4
                        : 2;
                    final double cardWidth =
                        (constraints.maxWidth -
                            (AppSpacing.lg * (columnCount - 1))) /
                        columnCount;

                    return Wrap(
                      spacing: AppSpacing.lg,
                      runSpacing: AppSpacing.lg,
                      children: experiences
                          .map(
                            (Experience experience) => SizedBox(
                              width: cardWidth,
                              child: _ExperienceCard(
                                experience: experience,
                                onTap: widget.onExplore,
                              ),
                            ),
                          )
                          .toList(growable: false),
                    );
                  },
                );
              },
        ),
      ],
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  final Experience experience;
  final VoidCallback onTap;

  const _ExperienceCard({required this.experience, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Semantics(
      button: true,
      container: true,
      child: Card(
        key: ValueKey<String>('experienceCard-${experience.id}'),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.softSand,
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                  ),
                  child: SizedBox.square(
                    dimension: 48,
                    child: Icon(
                      _iconFor(experience.icon),
                      color: AppColors.mediterraneanBlue,
                      semanticLabel: null,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  experience.title(locale),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  experience.description(locale),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(String identifier) {
    return switch (identifier) {
      'museum' => Icons.museum_outlined,
      'landscape' => Icons.landscape_outlined,
      'waves' => Icons.waves_outlined,
      'forest' => Icons.forest_outlined,
      'groups' => Icons.groups_outlined,
      'restaurant' => Icons.restaurant_outlined,
      'celebration' => Icons.celebration_outlined,
      'route' => Icons.route_outlined,
      _ => Icons.explore_outlined,
    };
  }
}

class _ExperienceErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _ExperienceErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.large),
        border: Border.all(color: AppColors.borderGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(context.l10n.unableToLoadContent),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              key: const Key('homeExperienceRetryButton'),
              onPressed: onRetry,
              child: Text(context.l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
