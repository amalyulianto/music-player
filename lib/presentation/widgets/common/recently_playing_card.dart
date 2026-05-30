import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/song_color_generator.dart';

/// A card displaying a recently played song with option to continue playing.
///
/// Features a prominent artwork thumbnail, song details, and a play action.
class RecentlyPlayingCard extends StatelessWidget {
  /// The song ID.
  final int songId;

  /// The song title.
  final String title;

  /// The song subtitle/artist.
  final String subtitle;

  /// Whether this song is currently active.
  final bool isActive;

  /// Whether this song is actively playing.
  final bool isPlaying;

  /// Callback when the card itself is tapped (navigates to player).
  final VoidCallback onCardTap;

  /// Callback when only the play/pause button is tapped.
  final VoidCallback onPlayPauseTap;

  /// Creates the [RecentlyPlayingCard] widget.
  const RecentlyPlayingCard({
    super.key,
    required this.songId,
    required this.title,
    required this.subtitle,
    this.isActive = false,
    this.isPlaying = false,
    required this.onCardTap,
    required this.onPlayPauseTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = SongColorGenerator.forId(songId);

    return Container(
      padding: const EdgeInsets.all(AppDimensions.paddingSm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Row(
        children: [
          // Clickable card body (Album Art + Song Details)
          Expanded(
            child: GestureDetector(
              onTap: onCardTap,
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  // Dynamic album art with gradient matching now playing
                  Container(
                    width: AppDimensions.recentlyPlayingCardSize,
                    height: AppDimensions.recentlyPlayingCardSize,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: colors,
                      ),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.music_note,
                        color: AppColors.white.withAlpha(204),
                        size: AppDimensions.iconLg,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMd),
                  // Title + subtitle + "Continue playing" / "Currently playing"
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
                          isActive && isPlaying ? 'Currently playing' : 'Continue playing',
                          style: AppTextStyles.timerText.copyWith(
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AppDimensions.paddingMd),
          // Play/pause state icon on the right (isolated gesture)
          GestureDetector(
            onTap: onPlayPauseTap,
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingSm),
              child: Icon(
                isActive && isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: AppColors.primaryText,
                size: AppDimensions.iconLg,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
