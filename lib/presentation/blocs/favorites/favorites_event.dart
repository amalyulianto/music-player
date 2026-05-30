/// Abstract class for all favorites events.
abstract class FavoritesEvent {
  /// Const constructor.
  const FavoritesEvent();
}

/// Event triggered when favorites are loaded from storage.
class FavoritesLoaded extends FavoritesEvent {
  /// Const constructor.
  const FavoritesLoaded();
}

/// Event triggered when a song's favorite status is toggled.
class FavoriteToggled extends FavoritesEvent {
  /// The ID of the song being toggled.
  final int songId;

  /// Creates a [FavoriteToggled] event.
  const FavoriteToggled(this.songId);
}
