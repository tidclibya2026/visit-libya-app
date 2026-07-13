import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';

class PlanYourTripSection extends StatelessWidget {
  final VoidCallback onStartPlanning;

  const PlanYourTripSection({required this.onStartPlanning, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: const Key('homePlanTripSection'),
      decoration: BoxDecoration(
        color: AppColors.surfaceHeritage,
        borderRadius: BorderRadius.circular(AppRadius.small),
        border: Border.all(color: AppColors.heritageSand),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool isWide = constraints.maxWidth >= 680;
            final Widget content = _PlanTripContent(
              onStartPlanning: onStartPlanning,
              showButton: !isWide,
            );

            if (!isWide) {
              return content;
            }

            return Row(
              children: <Widget>[
                const _PlanTripIcon(),
                const SizedBox(width: AppSpacing.xl),
                Expanded(child: content),
                const SizedBox(width: AppSpacing.xl),
                _StartPlanningButton(onPressed: onStartPlanning),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PlanTripContent extends StatelessWidget {
  final VoidCallback onStartPlanning;
  final bool showButton;

  const _PlanTripContent({
    required this.onStartPlanning,
    required this.showButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (showButton) ...<Widget>[
          const _PlanTripIcon(),
          const SizedBox(height: AppSpacing.lg),
        ],
        Semantics(
          header: true,
          child: Text(
            context.l10n.planYourTrip,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          context.l10n.planYourTripHomeDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (showButton) ...<Widget>[
          const SizedBox(height: AppSpacing.xl),
          SizedBox(
            width: double.infinity,
            child: _StartPlanningButton(onPressed: onStartPlanning),
          ),
        ],
      ],
    );
  }
}

class _PlanTripIcon extends StatelessWidget {
  const _PlanTripIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
      child: const Icon(
        Icons.route_rounded,
        color: AppColors.mediterraneanBlue,
        size: 30,
      ),
    );
  }
}

class _StartPlanningButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _StartPlanningButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      key: const Key('homePlanTripButton'),
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_forward_rounded),
      label: Text(context.l10n.startPlanning),
    );
  }
}
