import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../blocs/player/player_bloc.dart';
import '../../blocs/player/player_state.dart';
import '../../widgets/player/active_player_content.dart';

/// The screen showing details of the song currently playing.
class NowPlayingScreen extends StatelessWidget {
  /// Creates the [NowPlayingScreen] widget.
  const NowPlayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primaryText,
            size: AppDimensions.iconLg,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Now Playing',
          style: AppTextStyles.sectionHeader.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SafeArea(
        child: BlocBuilder<PlayerBloc, PlayerState>(
          builder: (context, state) {
            if (state is PlayerInitial) {
              return Center(
                child: Text(
                  'Select a song to play',
                  style: AppTextStyles.songArtist,
                ),
              );
            } else if (state is PlayerLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.accent,
                ),
              );
            } else if (state is PlayerError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppDimensions.paddingLg),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: AppTextStyles.songArtist.copyWith(
                          color: AppColors.favoriteRed,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.paddingMd),
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryText,
                          size: AppDimensions.iconMd,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is PlayerActive) {
              return ActivePlayerContent(
                song: state.song,
                position: state.position,
                totalDuration: state.totalDuration,
                isPlaying: state.isPlaying,
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
