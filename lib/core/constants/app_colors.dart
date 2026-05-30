import 'package:flutter/material.dart';

/// Defines the color palette for the Music Player application.
///
/// Follows the design system guidelines with curated dark-theme values.
abstract class AppColors {
  /// A fully transparent color.
  static const Color transparent = Colors.transparent;

  /// Pure white color for standard widget styling.
  static const Color white = Colors.white;

  /// The global background color of the application.
  static const Color background = Color(0xFF000000);

  /// The color for primary surfaces like containers and cards.
  static const Color surface = Color(0xFF1C1C1C);

  /// A lighter surface color for highlighted components or sub-containers.
  static const Color surfaceLight = Color(0xFF2A2A2A);

  /// Text color for primary readable items.
  static const Color primaryText = Color(0xFFFFFFFF);

  /// Text color for secondary or lower-priority items.
  static const Color secondaryText = Color(0xFFA0A0A0);

  /// The active accent color used for highlighted/selected states and actions.
  static const Color accent = Color(0xFF4DD9AC);

  /// Color used to denote a favorite state (e.g., liked songs).
  static const Color favoriteRed = Color(0xFFE05C5C);

  /// The track color for progress bars and sliders.
  static const Color progressTrack = Color(0xFF3A3A3A);
}
