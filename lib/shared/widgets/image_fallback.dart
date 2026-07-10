import 'package:flutter/material.dart';

import '../../core/localization/l10n_extension.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

class ImageFallback extends StatelessWidget {
  final IconData icon;

  const ImageFallback({this.icon = Icons.landscape_rounded, super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surfaceHeritage,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Icon(
            icon,
            color: AppColors.mediterraneanBlue,
            size: 48,
            semanticLabel: context.l10n.imageUnavailable,
          ),
        ),
      ),
    );
  }
}
