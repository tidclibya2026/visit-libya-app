import 'package:flutter/widgets.dart';
import 'package:visit_libya_app/l10n/generated/app_localizations.dart';

/// Convenient access to generated Visit Libya localizations.
extension AppLocalizationsBuildContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
