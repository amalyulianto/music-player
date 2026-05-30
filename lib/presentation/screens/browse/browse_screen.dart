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
import '../../blocs/song/song_bloc.dart';
import '../../blocs/song/song_event.dart';
import '../../blocs/song/song_state.dart';
import '../../widgets/common/loading_shimmer.dart';
import '../../widgets/common/song_list_item.dart';
import '../../widgets/player/mini_player_bar.dart';

/// A screen that displays a list of songs to browse, integrated with SongBloc.
class BrowseScreen extends StatefulWidget {
  /// Creates the [BrowseScreen] widget.
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
              title: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      style: AppTextStyles.songTitle.copyWith(
                        color: AppColors.primaryText,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search songs...',
                        hintStyle: AppTextStyles.listSubtitle.copyWith(
                          color: AppColors.secondaryText,
                        ),
                        border: InputBorder.none,
                      ),
                      onChanged: (query) {
                        context.read<SongBloc>().add(SongSearchQueryChanged(query));
                      },
                    )
                  : Text(
                      'Browse Songs',
                      style: AppTextStyles.songTitle.copyWith(
                        color: AppColors.primaryText,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
              centerTitle: true,
              backgroundColor: AppColors.transparent,
              elevation: 0.0,
              actions: [
                if (_isSearching)
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.primaryText,
                      size: AppDimensions.iconMd,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                        _searchController.clear();
                      });
                      context.read<SongBloc>().add(SongSearchQueryChanged(''));
                    },
                  )
                else
                  IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.primaryText,
                      size: AppDimensions.iconMd,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
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
                    child: BlocBuilder<SongBloc, SongState>(
                      builder: (context, state) {
                        if (state is SongLoading) {
                          return const LoadingShimmer();
                        } else if (state is SongError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.message,
                                  style: AppTextStyles.listSubtitle.copyWith(
                                    color: AppColors.favoriteRed,
                                  ),
                                ),
                                const SizedBox(height: AppDimensions.paddingMd),
                                TextButton(
                                  onPressed: () {
                                    context.read<SongBloc>().add(SongListRequested());
                                  },
                                  child: Text(
                                    'Retry',
                                    style: AppTextStyles.actionButton,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (state is SongLoaded) {
                          final songs = state.filteredSongs;
                          if (songs.isEmpty) {
                            return Center(
                              child: Text(
                                'No songs found',
                                style: AppTextStyles.listSubtitle,
                              ),
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingMd,
                            ),
                            itemCount: songs.length,
                            itemBuilder: (context, index) {
                              final song = songs[index];
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
                            },
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  const MiniPlayerBar(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

