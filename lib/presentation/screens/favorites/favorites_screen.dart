import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:music_player/presentation/blocs/player/player_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/di/service_locator.dart';
import '../../blocs/favorites/favorites_bloc.dart';
import '../../blocs/favorites/favorites_event.dart';
import '../../blocs/favorites/favorites_state.dart';
import '../../blocs/player/player_bloc.dart';
import '../../blocs/player/player_event.dart';
import '../../blocs/song/song_bloc.dart';
import '../../blocs/song/song_event.dart';
import '../../blocs/song/song_state.dart';
import '../../widgets/common/loading_shimmer.dart';
import '../../widgets/common/network_error_widget.dart';
import '../../widgets/common/song_list_item.dart';
import '../../widgets/player/mini_player_bar.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SongBloc>()..add(SongListRequested()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: AppColors.primaryText,
                  size: AppDimensions.iconSm,
                ),
                onPressed: () => context.pop(),
              ),
              title: Text(
                'My Favorites',
                style: AppTextStyles.songTitle.copyWith(
                  color: AppColors.primaryText,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              backgroundColor: AppColors.transparent,
              elevation: 0.0,
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocBuilder<SongBloc, SongState>(
                    builder: (context, songState) {
                      if (songState is SongLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(AppDimensions.paddingMd),
                          child: LoadingShimmer(),
                        );
                      } else if (songState is SongError) {
                        return NetworkErrorWidget(
                          message: songState.message,
                          onRetry: () {
                            context.read<SongBloc>().add(SongListRequested());
                          },
                        );
                      } else if (songState is SongLoaded) {
                        return BlocBuilder<FavoritesBloc, FavoritesState>(
                          builder: (context, favState) {
                            final favoriteIds = favState is FavoritesReady
                                ? favState.favoriteSongIds
                                : const <int>{};

                            final favoriteSongs = songState.songs
                                .where((s) => favoriteIds.contains(s.id))
                                .toList();

                            if (favoriteSongs.isEmpty) {
                              return _buildEmptyState(context);
                            }

                            return ListView.separated(
                              padding: const EdgeInsets.all(
                                AppDimensions.paddingMd,
                              ),
                              itemCount: favoriteSongs.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: AppDimensions.paddingSm,
                                  ),
                              itemBuilder: (context, index) {
                                final song = favoriteSongs[index];
                                return SongListItem(
                                  title: song.title,
                                  subtitle: song.subtitle,
                                  isFavorite: true,
                                  number: index + 1,
                                  onPlayTap: () {
                                    final playerState = context
                                        .read<PlayerBloc>()
                                        .state;
                                    final isCurrentlyPlaying =
                                        playerState is PlayerActive &&
                                        playerState.song.id == song.id;
                                    if (!isCurrentlyPlaying) {
                                      context.read<PlayerBloc>().add(
                                        PlayerSongRequested(song.id),
                                      );
                                    }
                                    context.pushNamed('nowPlaying');
                                  },
                                  onFavoriteTap: () {
                                    context.read<FavoritesBloc>().add(
                                      FavoriteToggled(song.id),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
                // Premium floating mini player bar
                const MiniPlayerBar(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingXl,
        ),
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.paddingLg),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: AppColors.surfaceLight.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72.0,
                height: 72.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.favoriteRed.withValues(alpha: 0.12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.favorite_border,
                    size: 36.0,
                    color: AppColors.favoriteRed,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingMd),
              Text(
                'No Favorites Yet',
                style: AppTextStyles.songTitle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSm),
              Text(
                'Explore the library and heart your beloved Surahs to save them here.',
                textAlign: TextAlign.center,
                style: AppTextStyles.songArtist.copyWith(
                  color: AppColors.secondaryText,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingLg),
              ElevatedButton(
                onPressed: () => context.pushNamed('browse'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.primaryText,
                  elevation: 0.0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLg,
                    vertical: AppDimensions.paddingMd,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text('Browse Songs'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
