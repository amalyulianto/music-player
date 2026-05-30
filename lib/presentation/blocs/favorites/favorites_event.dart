/// Abstract class for all favorites events.
abstract class FavoritesEvent {
  const FavoritesEvent();
}

/// Event triggered when favorites are loaded from storage.
class FavoritesLoaded extends FavoritesEvent {
  const FavoritesLoaded();
}

/// Event triggered when a song's favorite status is toggled.
class FavoriteToggled extends FavoritesEvent {
  final int songId;
  const FavoriteToggled(this.songId);
}
