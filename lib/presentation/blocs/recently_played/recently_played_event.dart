import '../../../domain/entities/song.dart';

/// Abstract class for all recently played events.
abstract class RecentlyPlayedEvent {
  /// Const constructor.
  const RecentlyPlayedEvent();
}

/// Event to restore the recently played list from storage.
class RecentlyPlayedRestored extends RecentlyPlayedEvent {
  /// Const constructor.
  const RecentlyPlayedRestored();
}

/// Event to add a song to the recently played list.
class RecentlyPlayedSongAdded extends RecentlyPlayedEvent {
  /// The song that was recently played.
  final Song song;

  /// Creates a [RecentlyPlayedSongAdded] event.
  const RecentlyPlayedSongAdded(this.song);
}

