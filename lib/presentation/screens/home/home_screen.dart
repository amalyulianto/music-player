import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/di/service_locator.dart';
import '../../blocs/favorites/favorites_bloc.dart';
import '../../blocs/favorites/favorites_event.dart';
import '../../blocs/favorites/favorites_state.dart';
import '../../blocs/player/player_bloc.dart';
import '../../blocs/player/player_event.dart';
import '../../blocs/player/player_state.dart';
import '../../blocs/recently_played/recently_played_bloc.dart';
import '../../blocs/recently_played/recently_played_state.dart';
import '../../blocs/song/song_bloc.dart';
import '../../blocs/song/song_event.dart';
import '../../blocs/song/song_state.dart';
import '../../widgets/common/network_error_widget.dart';
import '../../widgets/common/recently_playing_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/song_list_item.dart';
import '../../widgets/player/mini_player_bar.dart';

/// The main dashboard screen of the Music Player application.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SongBloc>()..add(SongListRequested()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Music Player',
            style: AppTextStyles.songTitle.copyWith(
              color: AppColors.primaryText,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.transparent,
          elevation: 0.0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.favorite_border,
                color: AppColors.primaryText,
                size: AppDimensions.iconMd,
              ),
              onPressed: () {
                context.pushNamed('favorites');
              },
            ),
            const SizedBox(width: AppDimensions.paddingSm),
          ],
        ),
        body: BlocListener<SongBloc, SongState>(
          listener: (context, state) {
            if (state is SongError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.favoriteRed,
                ),
              );
            }
          },
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingMd,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDimensions.paddingSm),
                      SectionHeader(
                        title: 'Browse Songs',
                        onArrowTap: () {
                          context.pushNamed('browse');
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingSm),
                      BlocBuilder<SongBloc, SongState>(
                        builder: (context, state) {
                          if (state is SongLoading) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppDimensions.paddingMd,
                                ),
                                child: CircularProgressIndicator(
                                  color: AppColors.accent,
                                ),
                              ),
                            );
                          } else if (state is SongError) {
                            return NetworkErrorWidget(
                              message: state.message,
                              onRetry: () {
                                context.read<SongBloc>().add(
                                  SongListRequested(),
                                );
                              },
                            );
                          } else if (state is SongLoaded) {
                            final songs = state.songs.take(4).toList();
                            return Column(
                              children: songs.map((song) {
                                return BlocBuilder<
                                  FavoritesBloc,
                                  FavoritesState
                                >(
                                  builder: (context, favoritesState) {
                                    final isFavorite =
                                        favoritesState is FavoritesReady &&
                                        favoritesState.favoriteSongIds.contains(
                                          song.id,
                                        );
                                    return SongListItem(
                                      title: song.title,
                                      subtitle: song.subtitle,
                                      isFavorite: isFavorite,
                                      number: song.id,
                                      onPlayTap: () {
                                        final playerState =
                                            context.read<PlayerBloc>().state;
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
                              }).toList(),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      BlocBuilder<RecentlyPlayedBloc, RecentlyPlayedState>(
                        builder: (context, state) {
                          final songs = state is RecentlyPlayedReady ? state.songs : [];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppDimensions.paddingLg),
                              const SectionHeader(
                                title: 'Recently Playing',
                              ),
                              const SizedBox(height: AppDimensions.paddingSm),
                              if (songs.isNotEmpty) ...[
                                BlocBuilder<PlayerBloc, PlayerState>(
                                  builder: (context, playerState) {
                                    final recentSongs = songs.take(3).toList();
                                    return Column(
                                      children: recentSongs.map((song) {
                                        final bool isActive =
                                            playerState is PlayerActive &&
                                            playerState.song.id == song.id;
                                        final bool isPlaying =
                                            isActive && playerState.isPlaying;

                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: AppDimensions.paddingSm,
                                          ),
                                          child: RecentlyPlayingCard(
                                            songId: song.id,
                                            title: song.title,
                                            subtitle: song.subtitle,
                                            isActive: isActive,
                                            isPlaying: isPlaying,
                                            onCardTap: () {
                                              if (!isActive) {
                                                context.read<PlayerBloc>().add(
                                                  PlayerSongRequested(song.id),
                                                );
                                              }
                                              context.pushNamed('nowPlaying');
                                            },
                                            onPlayPauseTap: () {
                                              if (isActive) {
                                                if (isPlaying) {
                                                  context.read<PlayerBloc>().add(
                                                    const PlayerPauseRequested(),
                                                  );
                                                } else {
                                                  context.read<PlayerBloc>().add(
                                                    const PlayerResumeRequested(),
                                                  );
                                                }
                                              } else {
                                                context.read<PlayerBloc>().add(
                                                  PlayerSongRequested(song.id),
                                                );
                                              }
                                            },
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  },
                                )
                              ] else ...[
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: AppDimensions.paddingMd,
                                    ),
                                    child: Text(
                                      'Play some song!',
                                      style: AppTextStyles.listSubtitle.copyWith(
                                        color: AppColors.secondaryText,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingLg),
                    ],
                  ),
                ),
              ),
              const MiniPlayerBar(),
            ],
          ),
        ),
      ),
    );
  }
}
