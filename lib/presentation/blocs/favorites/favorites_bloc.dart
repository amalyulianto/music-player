import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

/// Manages favorite songs persistence and state.
class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final SharedPreferences _prefs;

  /// Creates a [FavoritesBloc] instance.
  FavoritesBloc({
    required SharedPreferences prefs,
  })  : _prefs = prefs,
        super(const FavoritesInitial()) {
    on<FavoritesLoaded>(_onFavoritesLoaded);
    on<FavoriteToggled>(_onFavoriteToggled);
    add(const FavoritesLoaded());
  }

  /// Handles loading favorited song IDs from [SharedPreferences].
  Future<void> _onFavoritesLoaded(
    FavoritesLoaded event,
    Emitter<FavoritesState> emit,
  ) async {
    final raw = _prefs.getString('favorite_song_ids') ?? '';
    final ids = raw.isEmpty
        ? <int>{}
        : raw.split(',').map(int.parse).toSet();
    emit(FavoritesReady(ids));
  }

  /// Handles toggling a song's favorited state and persisting the updated set.
  Future<void> _onFavoriteToggled(
    FavoriteToggled event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FavoritesReady) return;

    final ids = Set<int>.from(currentState.favoriteSongIds);
    if (ids.contains(event.songId)) {
      ids.remove(event.songId);
    } else {
      ids.add(event.songId);
    }

    await _prefs.setString('favorite_song_ids', ids.join(','));
    emit(FavoritesReady(ids));
  }
}
