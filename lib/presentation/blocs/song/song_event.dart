/// Abstract class for all song list events.
abstract class SongEvent {
  const SongEvent();
}

/// Event triggered to load the initial list of songs.
class SongListRequested extends SongEvent {}

/// Event triggered when the user types in the search query field.
class SongSearchQueryChanged extends SongEvent {
  final String query;
  SongSearchQueryChanged(this.query);
}
