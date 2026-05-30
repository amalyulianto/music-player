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
import '../../blocs/recently_played/recently_played_bloc.dart';
import '../../blocs/recently_played/recently_played_state.dart';
import '../../blocs/song/song_bloc.dart';
import '../../blocs/song/song_event.dart';
import '../../blocs/song/song_state.dart';
import '../../widgets/common/recently_playing_card.dart';
import '../../widgets/common/section_header.dart';
import '../../widgets/common/song_list_item.dart';
import '../../widgets/player/mini_player_bar.dart';

/// The main dashboard screen of the Music Player application.
///
/// Lays out sections for browsing songs and recently playing songs,
/// with a floating mini-player bar at the bottom.
class HomeScreen extends StatelessWidget {
  /// Creates the [HomeScreen] widget.
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
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppDimensions.paddingMd,
                              ),
                              child: Text(
                                state.message,
                                style: AppTextStyles.listSubtitle.copyWith(
                                  color: AppColors.favoriteRed,
                                ),
                              ),
                            ),
                          );
                        } else if (state is SongLoaded) {
                          final songs = state.songs.take(4).toList();
                          return Column(
                            children: songs.map((song) {
                              return BlocBuilder<FavoritesBloc, FavoritesState>(
                                builder: (context, favoritesState) {
                                  final isFavorite = favoritesState is FavoritesReady &&
                                      favoritesState.favoriteSongIds.contains(song.id);
                                  return SongListItem(
                                    title: song.title,
                                    subtitle: song.subtitle,
                                    isFavorite: isFavorite,
                                    number: song.id,
                                    onPlayTap: () {
                                      context.read<PlayerBloc>().add(PlayerSongRequested(song.id));
                                    },
                                    onFavoriteTap: () {
                                      context.read<FavoritesBloc>().add(FavoriteToggled(song.id));
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
                        if (state is RecentlyPlayedReady && state.songs.isNotEmpty) {
                          final recentSongs = state.songs.take(3).toList();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: AppDimensions.paddingLg),
                              const SectionHeader(
                                title: 'Recently Playing',
                              ),
                              const SizedBox(height: AppDimensions.paddingSm),
                              ...recentSongs.map((song) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: AppDimensions.paddingSm),
                                  child: RecentlyPlayingCard(
                                    title: song.title,
                                    subtitle: song.subtitle,
                                    onContinueTap: () {
                                      context.read<PlayerBloc>().add(PlayerSongRequested(song.id));
                                    },
                                  ),
                                );
                              }),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
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

