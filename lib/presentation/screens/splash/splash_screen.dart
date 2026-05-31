import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _animationController.forward();

    // Automatically navigate to home screen after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        context.goNamed('home');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: AppColors.surface,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 3),
                Container(
                  // width: 120.0,
                  // height: 120.0,
                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   gradient: LinearGradient(
                  //     begin: Alignment.topLeft,
                  //     end: Alignment.bottomRight,
                  //     colors: [
                  //       AppColors.surfaceLight.withValues(alpha: 0.8),
                  //       AppColors.surface.withValues(alpha: 0.3),
                  //     ],
                  //   ),
                  //   border: Border.all(
                  //     color: AppColors.white.withValues(alpha: 0.15),
                  //     width: 1.5,
                  //   ),
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: AppColors.accent.withValues(alpha: 0.25),
                  //       blurRadius: 30.0,
                  //       spreadRadius: 2.0,
                  //     ),
                  // ],
                  // ),
                  child: Center(
                    child: Image.asset(
                      'assets/music_player_logo.png',
                      width: 64,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXl),

                Text(
                  'Music Player',
                  style: AppTextStyles.songTitle.copyWith(
                    fontSize: 26.0,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 3.5,
                    color: AppColors.primaryText,
                    shadows: [
                      Shadow(
                        color: AppColors.accent.withValues(alpha: 0.3),
                        blurRadius: 15.0,
                        offset: const Offset(0.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSm),

                // Premium Typography Subtitle
                const Spacer(flex: 2),
                // Custom thin loader
                const SizedBox(
                  width: 24.0,
                  height: 24.0,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.0,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingXl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
