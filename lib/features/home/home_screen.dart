import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/destination.dart';
import '../../data/repositories/destination_repository.dart';
import '../../shared/widgets/image_fallback.dart';
import '../destinations/destination_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final DestinationRepository repository;
  final VoidCallback onExploreDestinations;
  final VoidCallback onPlanTrip;

  const HomeScreen({
    required this.onExploreDestinations,
    required this.onPlanTrip,
    this.repository = const DestinationRepository(),
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int _featuredDestinationCount = 4;

  late Future<List<Destination>> _destinationsFuture;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  void _loadDestinations() {
    _destinationsFuture = widget.repository.loadDestinations();
  }

  void _retry() {
    setState(_loadDestinations);
  }

  void _openDestination(Destination destination) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => DestinationDetailScreen(
          destination: destination,
          onPlanTrip: widget.onPlanTrip,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
          children: <Widget>[
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: _HeroSection(
                    onExploreDestinations: widget.onExploreDestinations,
                    onPlanTrip: widget.onPlanTrip,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1120),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xl,
                  ),
                  child: _FeaturedDestinationsSection(
                    destinationsFuture: _destinationsFuture,
                    maximumCount: _featuredDestinationCount,
                    onDestinationTap: _openDestination,
                    onRetry: _retry,
                    onViewAll: widget.onExploreDestinations,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  final VoidCallback onExploreDestinations;
  final VoidCallback onPlanTrip;

  const _HeroSection({
    required this.onExploreDestinations,
    required this.onPlanTrip,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(AppRadius.premium),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isWide = constraints.maxWidth >= 680;
            final Widget content = _HeroContent(
              onExploreDestinations: onExploreDestinations,
              onPlanTrip: onPlanTrip,
            );
            const Widget logo = _HeroLogo();

            if (isWide) {
              return Row(
                children: <Widget>[
                  Expanded(child: content),
                  const SizedBox(width: AppSpacing.xxxl),
                  logo,
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: logo,
                ),
                const SizedBox(height: AppSpacing.xl),
                content,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  final VoidCallback onExploreDestinations;
  final VoidCallback onPlanTrip;

  const _HeroContent({
    required this.onExploreDestinations,
    required this.onPlanTrip,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Semantics(
          header: true,
          child: Text(
            context.l10n.discoverLibya,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          context.l10n.heroSubtitle,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.white),
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: <Widget>[
            ElevatedButton.icon(
              key: const Key('homeHeroExploreButton'),
              onPressed: onExploreDestinations,
              icon: const Icon(Icons.place_rounded),
              label: Text(context.l10n.exploreDestinations),
            ),
            OutlinedButton.icon(
              key: const Key('homeHeroPlanButton'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.white,
                side: const BorderSide(color: AppColors.white),
              ),
              onPressed: onPlanTrip,
              icon: const Icon(Icons.route_rounded),
              label: Text(context.l10n.planYourTrip),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroLogo extends StatelessWidget {
  const _HeroLogo();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.large),
      child: Image.asset(
        'assets/branding/visit-libya-logo.jpg',
        width: 144,
        height: 144,
        fit: BoxFit.cover,
        semanticLabel: context.l10n.appName,
      ),
    );
  }
}

class _FeaturedDestinationsSection extends StatelessWidget {
  final Future<List<Destination>> destinationsFuture;
  final int maximumCount;
  final ValueChanged<Destination> onDestinationTap;
  final VoidCallback onRetry;
  final VoidCallback onViewAll;

  const _FeaturedDestinationsSection({
    required this.destinationsFuture,
    required this.maximumCount,
    required this.onDestinationTap,
    required this.onRetry,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  context.l10n.featuredDestinations,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
            ),
            TextButton.icon(
              key: const Key('homeFeaturedViewAllButton'),
              onPressed: onViewAll,
              iconAlignment: IconAlignment.end,
              icon: const Icon(Icons.arrow_forward_rounded),
              label: Text(context.l10n.viewAll),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        FutureBuilder<List<Destination>>(
          future: destinationsFuture,
          builder:
              (
                BuildContext context,
                AsyncSnapshot<List<Destination>> snapshot,
              ) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 160,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return _FeaturedErrorState(onRetry: onRetry);
                }

                final List<Destination> featured =
                    (snapshot.data ?? const <Destination>[])
                        .take(maximumCount)
                        .toList(growable: false);

                if (featured.isEmpty) {
                  return Center(child: Text(context.l10n.noResults));
                }

                return LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool useTwoColumns = constraints.maxWidth >= 760;
                    final double cardWidth = useTwoColumns
                        ? (constraints.maxWidth - AppSpacing.lg) / 2
                        : constraints.maxWidth;

                    return Wrap(
                      spacing: AppSpacing.lg,
                      runSpacing: AppSpacing.lg,
                      children: featured
                          .map(
                            (Destination destination) => SizedBox(
                              width: cardWidth,
                              child: _FeaturedDestinationCard(
                                destination: destination,
                                onTap: () => onDestinationTap(destination),
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

class _FeaturedDestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;

  const _FeaturedDestinationCard({
    required this.destination,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Card(
      key: ValueKey<String>('featuredDestination-${destination.id}'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.medium),
                child: SizedBox.square(
                  dimension: 112,
                  child: destination.image.isEmpty
                      ? const ImageFallback()
                      : Image.asset(
                          destination.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => const ImageFallback(),
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      destination.name(locale),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      destination.location(locale),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mediterraneanBlue,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      destination.shortDescription(locale),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
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

class _FeaturedErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _FeaturedErrorState({required this.onRetry});

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
              key: const Key('homeFeaturedRetryButton'),
              onPressed: onRetry,
              child: Text(context.l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}
