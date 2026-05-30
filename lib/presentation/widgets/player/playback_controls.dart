import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

class PlaybackControls extends StatelessWidget {
  final bool isPlaying;

  final bool isShuffle;

  final bool isRepeat;

  final VoidCallback onPlayPause;

  final VoidCallback onNext;

  final VoidCallback onPrevious;

  final VoidCallback onShuffle;

  final VoidCallback onRepeat;

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
