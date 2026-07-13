import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class FieldVerificationNotice extends StatelessWidget {
  final bool compact;

  const FieldVerificationNotice({this.compact = false, super.key});

  @override
  Widget build(BuildContext context) {
    final String label = compact
        ? context.l10n.routeFieldVerificationRequired
        : context.l10n.routeFieldVerificationNotice;

    return Semantics(
      label: label,
      child: Container(
        padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.small),
          border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Icon(
              Icons.fact_check_outlined,
              size: 20,
              color: AppColors.warning,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: compact ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
