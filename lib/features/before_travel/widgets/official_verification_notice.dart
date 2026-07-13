import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class OfficialVerificationNotice extends StatelessWidget {
  final bool compact;

  const OfficialVerificationNotice({this.compact = false, super.key});

  @override
  Widget build(BuildContext context) {
    final String label = compact
        ? context.l10n.beforeTravelOfficialVerificationRequired
        : context.l10n.beforeTravelOfficialNotice;

    return Semantics(
      container: true,
      label: label,
      child: ExcludeSemantics(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceHeritage,
            borderRadius: BorderRadius.circular(AppRadius.small),
            border: Border.all(color: AppColors.border),
          ),
          child: Padding(
            padding: EdgeInsets.all(compact ? AppSpacing.sm : AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(
                  Icons.verified_user_outlined,
                  color: AppColors.mediterraneanBlue,
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    label,
                    style: compact
                        ? Theme.of(context).textTheme.labelMedium
                        : Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
