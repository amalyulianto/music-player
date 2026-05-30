import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

/// A reusable progress bar widget for the media player.
///
/// Displays a slider representing current progress and timer labels
/// for the current elapsed and total time.
class ProgressBarWidget extends StatelessWidget {
  /// The current elapsed value (usually in seconds or as a fraction).
  final double value;

  /// The maximum value representing the total duration.
  final double maxValue;

  /// Human-readable representation of the current elapsed time (e.g. '1:46').
  final String currentTime;

  /// Human-readable representation of the total song duration (e.g. '3:40').
  final String totalTime;

  /// Callback fired when the user seeks to a new position on the progress bar.
  final ValueChanged<double> onSeek;

  /// Creates the [ProgressBarWidget].
  const ProgressBarWidget({
    super.key,
    required this.value,
    required this.maxValue,
    required this.currentTime,
    required this.totalTime,
    required this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4.0,
            activeTrackColor: AppColors.accent,
            inactiveTrackColor: AppColors.progressTrack,
            thumbColor: AppColors.accent,
            overlayColor: AppColors.accent.withAlpha(30),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 6.0,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 16.0,
            ),
            // Reduce default horizontal padding around slider tracks
            trackShape: const RectangularSliderTrackShape(),
          ),
          child: Slider(
            value: value.clamp(0.0, maxValue),
            min: 0.0,
            max: maxValue,
            onChanged: onSeek,
          ),
        ),
        const SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentTime,
                style: AppTextStyles.timerText,
              ),
              Text(
                totalTime,
                style: AppTextStyles.timerText,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
