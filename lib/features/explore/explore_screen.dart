import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_spacing.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> items = <String>[
      context.l10n.heritageAndCivilizations,
      context.l10n.desertAndAdventure,
      context.l10n.coastAndSea,
      context.l10n.natureAndMountains,
      context.l10n.foodAndLocalTaste,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.explore)),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.xl),
        itemCount: items.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.explore_rounded),
              title: Text(items[index]),
              subtitle: Text(context.l10n.comingSoon),
            ),
          );
        },
      ),
    );
  }
}
