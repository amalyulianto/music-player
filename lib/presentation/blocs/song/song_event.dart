/// Abstract class for all song list events.
abstract class SongEvent {
  /// Const constructor.
  const SongEvent();
}

/// Event triggered to load the initial list of songs.
class SongListRequested extends SongEvent {}

/// Event triggered when the user types in the search query field.
class SongSearchQueryChanged extends SongEvent {
  /// The current text search query.
  final String query;

  /// Creates a [SongSearchQueryChanged] event.
  SongSearchQueryChanged(this.query);
}

