import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Defines the visual theme configuration for the application.
///
/// Encapsulates dark mode aesthetics including custom color schemes,
/// slider styling, app bars, and default icon themes.
abstract class AppTheme {
  /// The premium dark theme configuration for the Music Player app.
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.accent,
        surface: AppColors.surface,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.transparent,
        elevation: 0.0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.sectionHeader,
        iconTheme: const IconThemeData(
          color: AppColors.primaryText,
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.accent,
        inactiveTrackColor: AppColors.progressTrack,
        thumbColor: AppColors.accent,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.primaryText,
      ),
      useMaterial3: true,
    );
  }
}
