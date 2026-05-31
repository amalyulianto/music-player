import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class ProgressBarWidget extends StatelessWidget {
  final double value;
  final double maxValue;

  final String currentTime;

  final String totalTime;
  final ValueChanged<double> onSeek;

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
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
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
        const SizedBox(height: AppDimensions.paddingSm),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(currentTime, style: AppTextStyles.timerText),
              Text(totalTime, style: AppTextStyles.timerText),
            ],
          ),
        ),
      ],
    );
  }
}
