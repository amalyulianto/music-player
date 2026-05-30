import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

/// A premium, user-friendly widget shown when network/API requests fail.
///
/// Prompts the user to check their internet connection with a glowing offline icon
/// and provides an elegant "Retry Connection" button.
class NetworkErrorWidget extends StatelessWidget {
  /// The failure message to evaluate.
  final String message;

  /// Callback when the "Retry Connection" button is tapped.
  final VoidCallback onRetry;

  /// Creates the [NetworkErrorWidget] widget.
  const NetworkErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isNoInternet = message.toLowerCase().contains('network') ||
        message.toLowerCase().contains('internet') ||
        message.toLowerCase().contains('connection') ||
        message.toLowerCase().contains('socket');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Glowing round background wrapper for offline icon
            Container(
              padding: const EdgeInsets.all(AppDimensions.paddingLg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.favoriteRed.withAlpha(38),
                    blurRadius: 24.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Icon(
                isNoInternet ? Icons.wifi_off_rounded : Icons.error_outline_rounded,
                size: 64.0,
                color: AppColors.favoriteRed,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLg),
            Text(
              isNoInternet ? 'No Internet Connection' : 'Error Occurred',
              style: AppTextStyles.songTitle.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingSm),
            Text(
              isNoInternet
                  ? 'Please turn on your internet connection or check your network status and try again.'
                  : message,
              style: AppTextStyles.listSubtitle.copyWith(
                color: AppColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingLg),
            // Premium, interactive Retry Button
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh_rounded,
                color: AppColors.background,
                size: AppDimensions.iconSm,
              ),
              label: Text(
                'Retry Connection',
                style: AppTextStyles.actionButton.copyWith(
                  color: AppColors.background,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingLg,
                  vertical: AppDimensions.paddingMd,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                ),
                elevation: 4.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
