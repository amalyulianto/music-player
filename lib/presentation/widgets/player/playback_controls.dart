import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// A premium controls row widget for playback actions.
///
/// Features shuffle, skip previous, play/pause (large white circle),
/// skip next, and repeat buttons with proper touch targets and visually rich styling.
class PlaybackControls extends StatelessWidget {
  /// Whether the player is currently playing audio.
  final bool isPlaying;

  /// Whether the shuffle mode is enabled.
  final bool isShuffle;

  /// Whether the repeat mode is enabled.
  final bool isRepeat;

  /// Callback when play/pause button is tapped.
  final VoidCallback onPlayPause;

  /// Callback when next button is tapped.
  final VoidCallback onNext;

  /// Callback when previous button is tapped.
  final VoidCallback onPrevious;

  /// Callback when shuffle button is tapped.
  final VoidCallback onShuffle;

  /// Callback when repeat button is tapped.
  final VoidCallback onRepeat;

  /// Creates the [PlaybackControls].
  const PlaybackControls({
    super.key,
    required this.isPlaying,
    required this.isShuffle,
    required this.isRepeat,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onShuffle,
    required this.onRepeat,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Shuffle button
        IconButton(
          onPressed: onShuffle,
          icon: Icon(
            Icons.shuffle,
            size: AppDimensions.iconSm,
            color: isShuffle ? AppColors.accent : AppColors.secondaryText,
          ),
          splashRadius: 20.0,
        ),
        const SizedBox(width: AppDimensions.paddingMd),

        // Skip Previous in 48px dark circle
        GestureDetector(
          onTap: onPrevious,
          child: Container(
            width: 48.0,
            height: 48.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight,
            ),
            child: const Center(
              child: Icon(
                Icons.skip_previous,
                size: AppDimensions.iconMd,
                color: AppColors.primaryText,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingLg),

        // Play / Pause in 64px white circle
        GestureDetector(
          onTap: onPlayPause,
          child: Container(
            width: 64.0,
            height: 64.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white,
            ),
            child: Center(
              child: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: AppDimensions.iconLg,
                color: AppColors.background,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingLg),

        // Skip Next in 48px dark circle
        GestureDetector(
          onTap: onNext,
          child: Container(
            width: 48.0,
            height: 48.0,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surfaceLight,
            ),
            child: const Center(
              child: Icon(
                Icons.skip_next,
                size: AppDimensions.iconMd,
                color: AppColors.primaryText,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingMd),

        // Repeat button
        IconButton(
          onPressed: onRepeat,
          icon: Icon(
            Icons.repeat,
            size: AppDimensions.iconSm,
            color: isRepeat ? AppColors.accent : AppColors.secondaryText,
          ),
          splashRadius: 20.0,
        ),
      ],
    );
  }
}
