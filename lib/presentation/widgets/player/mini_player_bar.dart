import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/song_color_generator.dart';
import '../../blocs/player/player_bloc.dart';
import '../../blocs/player/player_event.dart';
import '../../blocs/player/player_state.dart';

class MiniPlayerBar extends StatelessWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is PlayerActive) {
          final song = state.song;
          final isPlaying = state.isPlaying;
          final colors = SongColorGenerator.forId(song.id);

          return GestureDetector(
            onTap: () => context.pushNamed('nowPlaying'),
            child: Container(
              margin: const EdgeInsets.all(AppDimensions.paddingMd),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingMd,
                vertical: AppDimensions.paddingSm,
              ),
              height: AppDimensions.miniPlayerHeight,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Row(
                children: [
                  // Small album art square
                  Container(
                    width: AppDimensions.iconXl,
                    height: AppDimensions.iconXl,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: colors,
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSm,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.music_note,
                        color: AppColors.white.withAlpha(204),
                        size: AppDimensions.iconMd,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMd),
                  // Song details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          song.title,
                          style: AppTextStyles.miniPlayerTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppDimensions.paddingXs),
                        Text(
                          song.subtitle,
                          style: AppTextStyles.miniPlayerSubtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppDimensions.paddingMd),
                  // Play/Pause circle button
                  GestureDetector(
                    onTap: () {
                      if (isPlaying) {
                        context.read<PlayerBloc>().add(
                          const PlayerPauseRequested(),
                        );
                      } else {
                        context.read<PlayerBloc>().add(
                          const PlayerResumeRequested(),
                        );
                      }
                    },
                    child: Container(
                      width: AppDimensions.iconXl,
                      height: AppDimensions.iconXl,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow,
                        color: AppColors.background,
                        size: AppDimensions.iconMd,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
