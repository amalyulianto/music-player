import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// A header widget for content sections.
///
/// Displays a bold title and an optional interactive arrow icon for navigation.
class SectionHeader extends StatelessWidget {
  /// The title of the section.
  final String title;

  /// The callback when the arrow icon is tapped.
  ///
  /// If null, the arrow icon is not displayed.
  final VoidCallback? onArrowTap;

  /// Creates the [SectionHeader] widget.
  const SectionHeader({
    super.key,
    required this.title,
    this.onArrowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.sectionHeader,
        ),
        if (onArrowTap != null)
          GestureDetector(
            onTap: onArrowTap,
            child: const Icon(
              Icons.chevron_right,
              color: AppColors.accent,
              size: AppDimensions.iconMd,
            ),
          ),
      ],
    );
  }
}
