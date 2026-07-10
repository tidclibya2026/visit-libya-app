import 'package:flutter/material.dart';

import '../core/localization/locale_controller.dart';
import '../core/theme/app_theme.dart';
import '../l10n/generated/app_localizations.dart';
import 'app_shell.dart';

class VisitLibyaApp extends StatefulWidget {
  final LocaleController? localeController;

  const VisitLibyaApp({this.localeController, super.key});

  @override
  State<VisitLibyaApp> createState() => _VisitLibyaAppState();
}

class _VisitLibyaAppState extends State<VisitLibyaApp> {
  late final LocaleController _localeController;
  late final bool _ownsLocaleController;

  @override
  void initState() {
    super.initState();
    _ownsLocaleController = widget.localeController == null;
    _localeController = widget.localeController ?? LocaleController();
  }

  @override
  void dispose() {
    if (_ownsLocaleController) {
      _localeController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _localeController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          title: 'Visit Libya',
          debugShowCheckedModeBanner: false,
          locale: _localeController.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          theme: AppTheme.light(isArabic: _localeController.isArabic),
          builder: (BuildContext context, Widget? child) {
            return Directionality(
              textDirection: _localeController.textDirection,
              child: child ?? const SizedBox.shrink(),
            );
          },
          home: AppShell(localeController: _localeController),
        );
      },
    );
  }
}
