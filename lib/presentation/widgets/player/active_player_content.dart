import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/utils/duration_formatter.dart';
import '../../../core/utils/song_color_generator.dart';
import '../../../domain/entities/song.dart';
import '../../blocs/favorites/favorites_bloc.dart';
import '../../blocs/favorites/favorites_event.dart';
import '../../blocs/favorites/favorites_state.dart';
import '../../blocs/player/player_bloc.dart';
import '../../blocs/player/player_event.dart';
import 'playback_controls.dart';
import 'progress_bar_widget.dart';

/// Renders the layout and controls when a song is active.
class ActivePlayerContent extends StatefulWidget {
  /// The song currently playing.
  final Song song;

  /// The current elapsed playback position.
  final Duration position;

  /// The total duration of the song.
  final Duration totalDuration;

  /// Whether audio is playing.
  final bool isPlaying;

  /// Creates an [ActivePlayerContent] instance.
  const ActivePlayerContent({
    super.key,
    required this.song,
    required this.position,
    required this.totalDuration,
    required this.isPlaying,
  });

  @override
  State<ActivePlayerContent> createState() => _ActivePlayerContentState();
}

class _ActivePlayerContentState extends State<ActivePlayerContent> {
  bool _isShuffle = false;
  bool _isRepeat = false;

  @override
  Widget build(BuildContext context) {
    final colors = SongColorGenerator.forId(widget.song.id);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLg,
          vertical: AppDimensions.paddingMd,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppDimensions.paddingSm),

            // Album Art
            Center(
              child: Container(
                width: AppDimensions.albumArtSize,
                height: AppDimensions.albumArtSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusLg),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: colors,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.first.withAlpha(51),
                      blurRadius: 24.0,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    size: 80.0,
                    color: AppColors.white.withAlpha(204),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLg),

            // Song/Favorite Icon row below art
            SizedBox(
              width: AppDimensions.albumArtSize,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44.0,
                    height: 44.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.surfaceLight,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.music_note,
                        color: AppColors.accent,
                        size: AppDimensions.iconMd,
                      ),
                    ),
                  ),
                  BlocBuilder<FavoritesBloc, FavoritesState>(
                    builder: (context, favoritesState) {
                      final isFavorite = favoritesState is FavoritesReady &&
                          favoritesState.favoriteSongIds.contains(widget.song.id);
                      return GestureDetector(
                        onTap: () {
                          context.read<FavoritesBloc>().add(FavoriteToggled(widget.song.id));
                        },
                        child: Container(
                          width: 44.0,
                          height: 44.0,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.surfaceLight,
                          ),
                          child: Center(
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: AppColors.favoriteRed,
                              size: AppDimensions.iconMd,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.paddingLg),

            // Song title and details
            Text(
              widget.song.title,
              style: AppTextStyles.songTitle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingXs),
            Text(
              widget.song.subtitle,
              style: AppTextStyles.songArtist,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.paddingXl),

            // Progress Slider
            ProgressBarWidget(
              value: widget.position.inMilliseconds.toDouble(),
              maxValue: widget.totalDuration.inMilliseconds == 0
                  ? 1.0
                  : widget.totalDuration.inMilliseconds.toDouble(),
              currentTime: DurationFormatter.format(widget.position),
              totalTime: DurationFormatter.format(widget.totalDuration),
              onSeek: (value) {
                context.read<PlayerBloc>().add(
                      PlayerSeekRequested(Duration(milliseconds: value.toInt())),
                    );
              },
            ),
            const SizedBox(height: AppDimensions.paddingXl),

            // Control Buttons
            PlaybackControls(
              isPlaying: widget.isPlaying,
              isShuffle: _isShuffle,
              isRepeat: _isRepeat,
              onPlayPause: () {
                if (widget.isPlaying) {
                  context.read<PlayerBloc>().add(const PlayerPauseRequested());
                } else {
                  context.read<PlayerBloc>().add(const PlayerResumeRequested());
                }
              },
              onNext: () {
                context.read<PlayerBloc>().add(const PlayerNextRequested());
              },
              onPrevious: () {
                context.read<PlayerBloc>().add(const PlayerPreviousRequested());
              },
              onShuffle: () {
                setState(() {
                  _isShuffle = !_isShuffle;
                });
              },
              onRepeat: () {
                setState(() {
                  _isRepeat = !_isRepeat;
                });
              },
            ),
            const SizedBox(height: AppDimensions.paddingMd),
          ],
        ),
      ),
    );
  }
}
