import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// A card displaying a recently played song with option to continue playing.
///
/// Features a prominent artwork thumbnail, song details, and a play action.
class RecentlyPlayingCard extends StatelessWidget {
  /// The song title.
  final String title;

  /// The song subtitle/artist.
  final String subtitle;

  /// Callback when the card or play button is tapped.
  final VoidCallback onContinueTap;

  /// Creates the [RecentlyPlayingCard] widget.
  const RecentlyPlayingCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onContinueTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onContinueTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingSm),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Row(
          children: [
            // 60x60 teal rounded square
            Container(
              width: AppDimensions.recentlyPlayingCardSize,
              height: AppDimensions.recentlyPlayingCardSize,
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: const Icon(
                Icons.music_note,
                color: AppColors.background,
                size: AppDimensions.iconLg,
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMd),
            // Title + subtitle + "Continue playing"
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  const SizedBox(height: AppDimensions.paddingXs),
                  Text(
                    'Continue playing',
                    style: AppTextStyles.timerText.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppDimensions.paddingMd),
            // Play arrow icon
            const Icon(
              Icons.play_arrow_rounded,
              color: AppColors.primaryText,
              size: AppDimensions.iconLg,
            ),
          ],
        ),
      ),
    );
  }
}
