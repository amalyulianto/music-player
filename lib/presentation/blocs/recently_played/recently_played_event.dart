import '../../../domain/entities/song.dart';

/// Abstract class for all recently played events.
abstract class RecentlyPlayedEvent {
  const RecentlyPlayedEvent();
}

/// Event to restore the recently played list from storage.
class RecentlyPlayedRestored extends RecentlyPlayedEvent {
  const RecentlyPlayedRestored();
}

/// Event to add a song to the recently played list.
class RecentlyPlayedSongAdded extends RecentlyPlayedEvent {
  final Song song;
  const RecentlyPlayedSongAdded(this.song);
}
