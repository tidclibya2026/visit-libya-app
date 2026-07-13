import 'package:flutter/material.dart';

import '../../../core/localization/l10n_extension.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../data/models/guide_intent.dart';

class GuideResultCard extends StatelessWidget {
  final GuideIntent intent;
  final bool showAction;
  final VoidCallback onAction;

  const GuideResultCard({
    required this.intent,
    required this.showAction,
    required this.onAction,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Locale locale = Localizations.localeOf(context);

    return Card(
      key: const Key('smartGuideResultCard'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Icon(Icons.assistant_outlined),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    intent.answer(locale),
                    key: const Key('smartGuideAnswer'),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
            if (showAction) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.tonalIcon(
                key: const Key('smartGuideActionButton'),
                onPressed: onAction,
                icon: const Icon(Icons.arrow_forward_rounded),
                label: Text(context.l10n.smartGuideOpenResult),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
