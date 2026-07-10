import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/destination.dart';
import '../../data/repositories/destination_repository.dart';
import '../../shared/widgets/image_fallback.dart';
import 'destination_detail_screen.dart';

class DestinationsScreen extends StatefulWidget {
  final DestinationRepository repository;
  final VoidCallback onPlanTrip;

  const DestinationsScreen({
    required this.onPlanTrip,
    this.repository = const DestinationRepository(),
    super.key,
  });

  @override
  State<DestinationsScreen> createState() => _DestinationsScreenState();
}

class _DestinationsScreenState extends State<DestinationsScreen> {
  late Future<List<Destination>> _destinationsFuture;
  final TextEditingController _searchController = TextEditingController();

  String _query = '';
  String? _categoryId;

  @override
  void initState() {
    super.initState();
    _loadDestinations();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadDestinations() {
    _destinationsFuture = widget.repository.loadDestinations();
  }

  void _retry() {
    setState(_loadDestinations);
  }

  List<Destination> _filterDestinations(
    List<Destination> destinations,
    Locale locale,
  ) {
    return destinations
        .where((Destination destination) {
          final bool categoryMatches =
              _categoryId == null || destination.categoryId == _categoryId;
          final bool queryMatches = destination.matchesQuery(_query, locale);

          return categoryMatches && queryMatches;
        })
        .toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.destinations)),
      body: FutureBuilder<List<Destination>>(
        future: _destinationsFuture,
        builder:
            (BuildContext context, AsyncSnapshot<List<Destination>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return _DestinationErrorState(onRetry: _retry);
              }

              final List<Destination> destinations =
                  snapshot.data ?? const <Destination>[];
              final List<Destination> filtered = _filterDestinations(
                destinations,
                locale,
              );
              final List<_CategoryFilter> categories = _buildCategories(
                destinations,
                locale,
              );

              return CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.lg,
                        AppSpacing.xl,
                        AppSpacing.sm,
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (String value) {
                          setState(() {
                            _query = value;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search_rounded),
                          labelText: context.l10n.searchDestinations,
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                                  tooltip: context.l10n.search,
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _query = '';
                                    });
                                  },
                                  icon: const Icon(Icons.close_rounded),
                                ),
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 56,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(width: AppSpacing.sm),
                        itemBuilder: (BuildContext context, int index) {
                          final _CategoryFilter category = categories[index];
                          final bool selected = category.id == _categoryId;

                          return ChoiceChip(
                            selected: selected,
                            label: Text(category.label),
                            onSelected: (_) {
                              setState(() {
                                _categoryId = category.id;
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  if (filtered.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: _DestinationEmptyState(query: _query),
                    )
                  else
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xl,
                        AppSpacing.sm,
                        AppSpacing.xl,
                        AppSpacing.xl,
                      ),
                      sliver: SliverList.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.md),
                        itemBuilder: (BuildContext context, int index) {
                          return _DestinationCard(
                            destination: filtered[index],
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) {
                                    return DestinationDetailScreen(
                                      destination: filtered[index],
                                      onPlanTrip: widget.onPlanTrip,
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                ],
              );
            },
      ),
    );
  }

  List<_CategoryFilter> _buildCategories(
    List<Destination> destinations,
    Locale locale,
  ) {
    final Map<String, String> categoryLabels = <String, String>{};

    for (final Destination destination in destinations) {
      categoryLabels[destination.categoryId] = destination.category(locale);
    }

    return <_CategoryFilter>[
      _CategoryFilter(id: null, label: context.l10n.all),
      ...categoryLabels.entries.map(
        (MapEntry<String, String> entry) =>
            _CategoryFilter(id: entry.key, label: entry.value),
      ),
    ];
  }
}

class _DestinationCard extends StatelessWidget {
  final Destination destination;
  final VoidCallback onTap;

  const _DestinationCard({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 16 / 9,
              child: destination.image.isEmpty
                  ? const ImageFallback()
                  : Image.asset(
                      destination.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const ImageFallback(),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    destination.name(locale),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    destination.location(locale),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.mediterraneanBlue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(destination.shortDescription(locale)),
                  const SizedBox(height: AppSpacing.sm),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.softSand,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      child: Text(destination.category(locale)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationErrorState extends StatelessWidget {
  final VoidCallback onRetry;

  const _DestinationErrorState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(context.l10n.unableToLoadContent),
            const SizedBox(height: AppSpacing.md),
            ElevatedButton(
              onPressed: onRetry,
              child: Text(context.l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationEmptyState extends StatelessWidget {
  final String query;

  const _DestinationEmptyState({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Text(
          query.isEmpty ? context.l10n.noResults : context.l10n.noResults,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _CategoryFilter {
  final String? id;
  final String label;

  const _CategoryFilter({required this.id, required this.label});
}
