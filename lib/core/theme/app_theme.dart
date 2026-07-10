import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_radius.dart';
import 'app_text_styles.dart';

/// Official light-first theme for Visit Libya V2.
///
/// Visual identity:
/// Modern Heritage Journey.
abstract final class AppTheme {
  static ThemeData light({required bool isArabic}) {
    final ColorScheme colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.mediterraneanBlue,
          brightness: Brightness.light,
        ).copyWith(
          primary: AppColors.mediterraneanBlue,
          onPrimary: AppColors.white,
          secondary: AppColors.heritageSand,
          onSecondary: AppColors.deepNavy,
          tertiary: AppColors.journeyRed,
          onTertiary: AppColors.white,
          surface: AppColors.white,
          onSurface: AppColors.deepNavy,
          error: AppColors.error,
          onError: AppColors.white,
          outline: AppColors.borderGray,
        );

    final TextTheme textTheme = AppTextStyles.textTheme(isArabic: isArabic);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.softBackground,
      textTheme: textTheme,
      dividerColor: AppColors.borderGray,

      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: AppColors.softBackground,
        foregroundColor: AppColors.deepNavy,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),

      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: AppColors.white,
        indicatorColor: AppColors.softSand,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
          Set<WidgetState> states,
        ) {
          final bool isSelected = states.contains(WidgetState.selected);

          return textTheme.labelMedium?.copyWith(
            color: isSelected
                ? AppColors.mediterraneanBlue
                : AppColors.warmGray,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>((
          Set<WidgetState> states,
        ) {
          final bool isSelected = states.contains(WidgetState.selected);

          return IconThemeData(
            color: isSelected
                ? AppColors.mediterraneanBlue
                : AppColors.warmGray,
          );
        }),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(48, 52),
          elevation: 0,
          backgroundColor: AppColors.mediterraneanBlue,
          foregroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(48, 52),
          foregroundColor: AppColors.mediterraneanBlue,
          side: const BorderSide(color: AppColors.mediterraneanBlue),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.large),
          ),
          textStyle: textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.mediterraneanBlue,
          textStyle: textTheme.labelLarge,
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          borderSide: const BorderSide(color: AppColors.borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          borderSide: const BorderSide(color: AppColors.borderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          borderSide: const BorderSide(
            color: AppColors.mediterraneanBlue,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.large),
          borderSide: const BorderSide(color: AppColors.error),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.deepNavy,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.white,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
      ),

      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.mediterraneanBlue,
      ),
    );
  }
}
