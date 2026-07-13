import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/models/before_travel_item.dart';
import '../../data/repositories/before_travel_repository.dart';
import 'widgets/before_travel_card.dart';
import 'widgets/official_verification_notice.dart';

class BeforeTravelScreen extends StatefulWidget {
  final BeforeTravelRepository repository;

  const BeforeTravelScreen({
    this.repository = const BeforeTravelRepository(),
    super.key,
  });

  @override
  State<BeforeTravelScreen> createState() => _BeforeTravelScreenState();
}

class _BeforeTravelScreenState extends State<BeforeTravelScreen> {
  late Future<List<BeforeTravelItem>> _itemsFuture;

  @override
  void initState() {
    super.initState();
    _itemsFuture = _loadEnabledItems();
  }

  Future<List<BeforeTravelItem>> _loadEnabledItems() async {
    final List<BeforeTravelItem> items = await widget.repository.loadItems();
    return List<BeforeTravelItem>.unmodifiable(
      items.where((BeforeTravelItem item) => item.enabled),
    );
  }

  void _retry() {
    setState(() {
      _itemsFuture = _loadEnabledItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.beforeTravel)),
      body: FutureBuilder<List<BeforeTravelItem>>(
        future: _itemsFuture,
        builder:
            (
              BuildContext context,
              AsyncSnapshot<List<BeforeTravelItem>> snapshot,
            ) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(
                    key: Key('beforeTravelLoadingIndicator'),
                  ),
                );
              }

              if (snapshot.hasError) {
                return _BeforeTravelError(onRetry: _retry);
              }

              return _BeforeTravelContent(items: snapshot.requireData);
            },
      ),
    );
  }
}

class _BeforeTravelContent extends StatelessWidget {
  final List<BeforeTravelItem> items;

  const _BeforeTravelContent({required this.items});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double horizontalPadding = constraints.maxWidth < 400
            ? AppSpacing.md
            : AppSpacing.xl;

        return ListView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: AppSpacing.xl,
          ),
          children: <Widget>[
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      context.l10n.beforeTravelIntroduction,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const OfficialVerificationNotice(
                      key: Key('beforeTravelOfficialNotice'),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ...items.map(
                      (BeforeTravelItem item) => Padding(
                        key: ValueKey<String>('beforeTravelCard-${item.id}'),
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: BeforeTravelCard(item: item),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BeforeTravelError extends StatelessWidget {
  final VoidCallback onRetry;

  const _BeforeTravelError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(Icons.error_outline_rounded, size: 40),
            const SizedBox(height: AppSpacing.md),
            Text(
              context.l10n.unableToLoadContent,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton.icon(
              key: const Key('beforeTravelRetryButton'),
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(context.l10n.retry),
            ),
          ],
        ),
      ),
    );
  }
}
