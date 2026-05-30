import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class SectionHeader extends StatelessWidget {
  final String title;

  final VoidCallback? onArrowTap;

  const SectionHeader({super.key, required this.title, this.onArrowTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.sectionHeader),
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
