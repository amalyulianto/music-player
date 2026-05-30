import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';

/// A loading placeholder widget featuring 8 shimmer rows to mock [SongListItem].
class LoadingShimmer extends StatelessWidget {
  /// Creates the [LoadingShimmer] widget.
  const LoadingShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMd,
      ),
      itemCount: 8,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.paddingSm,
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.surfaceLight,
            highlightColor: const Color(0xFF3A3A3A),
            child: Row(
              children: [
                // Leading square/circle placeholder (mocking index/play)
                Container(
                  width: AppDimensions.iconXl,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingSm),
                // Title + Subtitle placeholder
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingXs),
                      Container(
                        width: 150.0,
                        height: 12.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppDimensions.paddingMd),
                // Trailing favorite button placeholder
                Container(
                  width: AppDimensions.iconMd,
                  height: AppDimensions.iconMd,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
