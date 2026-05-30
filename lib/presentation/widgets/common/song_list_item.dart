import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// A single row representing a song item in a list.
///
/// Features a leading number or play icon, title and subtitle details,
/// and a favorite heart icon at the end.
class SongListItem extends StatelessWidget {
  /// The song title.
  final String title;

  /// The song subtitle/artist.
  final String subtitle;

  /// Whether this song is favorited.
  final bool isFavorite;

  /// The optional index number of the song in the list.
  final int? number;

  /// Callback when the item or play action is tapped.
  final VoidCallback onPlayTap;

  /// Callback when the favorite button is tapped.
  final VoidCallback onFavoriteTap;

  /// Creates the [SongListItem] widget.
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
        padding: const EdgeInsets.symmetric(
          vertical: AppDimensions.paddingSm,
        ),
        color: AppColors.transparent, // Ensures the whole row area is interactive
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
                color: isFavorite ? AppColors.favoriteRed : AppColors.primaryText,
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
