import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

abstract class AppTextStyles {
  static final TextStyle songTitle = GoogleFonts.inter(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  /// Medium regular style used for now playing song artist details.
  static final TextStyle songArtist = GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
  );

  /// Bold section header style used for page/section headings.
  static final TextStyle sectionHeader = GoogleFonts.inter(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryText,
  );

  /// Semibold list title style used for main items in lists.
  static final TextStyle listTitle = GoogleFonts.inter(
    fontSize: 18.0,
    fontWeight: FontWeight.w600, // semibold
    color: AppColors.primaryText,
  );

  /// Regular subtitle style used for secondary items in lists.
  static final TextStyle listSubtitle = GoogleFonts.inter(
    fontSize: 13.0,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
  );

  /// Tiny timer text style used for duration countdowns/elapsed times.
  static final TextStyle timerText = GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
  );

  /// Semibold title style used for the mini player title display.
  static final TextStyle miniPlayerTitle = GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.w600, // semibold
    color: AppColors.primaryText,
  );

  /// Regular subtitle style used for the mini player subtitle display.
  static final TextStyle miniPlayerSubtitle = GoogleFonts.inter(
    fontSize: 12.0,
    fontWeight: FontWeight.normal,
    color: AppColors.secondaryText,
  );

  /// Bold button text style used for actions like retry.
  static final TextStyle actionButton = GoogleFonts.inter(
    fontSize: 14.0,
    fontWeight: FontWeight.bold,
    color: AppColors.accent,
  );
}
