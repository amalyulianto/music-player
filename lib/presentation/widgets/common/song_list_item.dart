import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class SongListItem extends StatelessWidget {
  final String title;

  final String subtitle;

  final bool isFavorite;

  final int? number;

  final VoidCallback onPlayTap;

  final VoidCallback onFavoriteTap;

  const SongListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isFavorite,
    this.number,
    required this.onPlayTap,
    required this.onFavoriteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPlayTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingSm),
        color:
            AppColors.transparent, // Ensures the whole row area is interactive
        child: Row(
          children: [
            // Leading number or play icon
            SizedBox(
              width: AppDimensions.iconXl,
              child: Center(
                child: number != null
                    ? Text(
                        number.toString().padLeft(2, '0'),
                        style: AppTextStyles.listSubtitle.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : const Icon(
                        Icons.play_arrow,
                        color: AppColors.accent,
                        size: AppDimensions.iconMd,
                      ),
              ),
            ),
            const SizedBox(width: AppDimensions.paddingSm),
            // Title + subtitle column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.listTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.paddingXs),
                  Text(
                    subtitle,
                    style: AppTextStyles.listSubtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMd),
            // Heart icon
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite
                    ? AppColors.favoriteRed
                    : AppColors.primaryText,
                size: AppDimensions.iconMd,
              ),
              onPressed: onFavoriteTap,
            ),
          ],
        ),
      ),
    );
  }
}
