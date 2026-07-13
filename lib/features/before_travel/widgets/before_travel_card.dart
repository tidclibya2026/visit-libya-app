import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/before_travel_item.dart';
import 'official_verification_notice.dart';

class BeforeTravelCard extends StatelessWidget {
  final BeforeTravelItem item;

  const BeforeTravelCard({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        key: ValueKey<String>('beforeTravelExpansion-${item.id}'),
        leading: Icon(
          beforeTravelCategoryIcon(item.category),
          color: AppColors.mediterraneanBlue,
        ),
        title: Text(item.title(locale)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: AppSpacing.xs),
          child: Text(item.summary(locale)),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          0,
          AppSpacing.lg,
          AppSpacing.lg,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Divider(),
          Text(
            context.l10n.beforeTravelChecklist,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: AppSpacing.sm),
          ...item
              .checklist(locale)
              .asMap()
              .entries
              .map(
                (MapEntry<int, String> entry) => Padding(
                  key: ValueKey<String>(
                    'beforeTravelChecklist-${item.id}-${entry.key}',
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        size: 20,
                        color: AppColors.mediterraneanBlue,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(child: Text(entry.value)),
                    ],
                  ),
                ),
              ),
          if (item.requiresOfficialVerification) ...<Widget>[
            const SizedBox(height: AppSpacing.md),
            OfficialVerificationNotice(
              key: ValueKey<String>('beforeTravelVerification-${item.id}'),
              compact: true,
            ),
          ],
        ],
      ),
    );
  }
}

IconData beforeTravelCategoryIcon(BeforeTravelCategory category) {
  return switch (category) {
    BeforeTravelCategory.entryDocuments => Icons.badge_outlined,
    BeforeTravelCategory.health => Icons.medical_services_outlined,
    BeforeTravelCategory.safety => Icons.health_and_safety_outlined,
    BeforeTravelCategory.money => Icons.account_balance_wallet_outlined,
    BeforeTravelCategory.connectivity => Icons.wifi_outlined,
    BeforeTravelCategory.transport => Icons.directions_transit_outlined,
    BeforeTravelCategory.culture => Icons.diversity_3_outlined,
    BeforeTravelCategory.weatherAndPacking => Icons.luggage_outlined,
  };
}
