import 'package:flutter/material.dart';

/// Controls the active Visit Libya application locale.
///
/// Sprint 1 supports:
/// - Arabic (RTL)
/// - English (LTR)
///
/// Arabic is the initial application locale.
final class LocaleController extends ChangeNotifier {
  LocaleController({Locale initialLocale = const Locale('ar')})
    : _locale = _normalize(initialLocale);

  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');

  static const List<Locale> supportedLocales = <Locale>[arabic, english];

  Locale _locale;

  Locale get locale => _locale;

  bool get isArabic => _locale.languageCode == arabic.languageCode;

  bool get isEnglish => _locale.languageCode == english.languageCode;

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  void setLocale(Locale value) {
    final Locale normalized = _normalize(value);

    if (_locale == normalized) {
      return;
    }

    _locale = normalized;
    notifyListeners();
  }

  void useArabic() {
    setLocale(arabic);
  }

  void useEnglish() {
    setLocale(english);
  }

  void toggle() {
    setLocale(isArabic ? english : arabic);
  }

  static Locale _normalize(Locale value) {
    return value.languageCode == english.languageCode ? english : arabic;
  }
}
