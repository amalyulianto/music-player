/// Abstract class for all player events.
abstract class PlayerEvent {
  /// Const constructor.
  const PlayerEvent();
}

/// Event to request playing a song by its identifier.
class PlayerSongRequested extends PlayerEvent {
  /// The unique identifier of the song to play.
  final int songId;

  /// Creates a [PlayerSongRequested] event with [songId].
  const PlayerSongRequested(this.songId);
}

/// Event to request pausing the current song.
class PlayerPauseRequested extends PlayerEvent {
  /// Creates a [PlayerPauseRequested] event.
  const PlayerPauseRequested();
}

/// Event to request resuming the current song.
class PlayerResumeRequested extends PlayerEvent {
  /// Creates a [PlayerResumeRequested] event.
  const PlayerResumeRequested();
}

/// Event to seek playback to a specific position.
class PlayerSeekRequested extends PlayerEvent {
  /// The position to seek to.
  final Duration position;

  /// Creates a [PlayerSeekRequested] event with [position].
  const PlayerSeekRequested(this.position);
}

/// Event to request playing the next song/track.
class PlayerNextRequested extends PlayerEvent {
  /// Creates a [PlayerNextRequested] event.
  const PlayerNextRequested();
}

/// Event to request playing the previous song/track.
class PlayerPreviousRequested extends PlayerEvent {
  /// Creates a [PlayerPreviousRequested] event.
  const PlayerPreviousRequested();
}

/// Internal event fired when the playback position is updated.
class PlayerPositionUpdated extends PlayerEvent {
  /// The new playback position.
  final Duration position;

  /// Creates a [PlayerPositionUpdated] event with [position].
  const PlayerPositionUpdated(this.position);
}

/// Internal event fired when the song total duration is loaded/changed.
class PlayerDurationUpdated extends PlayerEvent {
  /// The new total duration.
  final Duration duration;

  /// Creates a [PlayerDurationUpdated] event with [duration].
  const PlayerDurationUpdated(this.duration);
}

/// Internal event fired when the playing status is changed.
class PlayerIsPlayingChanged extends PlayerEvent {
  /// Whether the player is playing.
  final bool isPlaying;

  /// Creates a [PlayerIsPlayingChanged] event with [isPlaying].
  const PlayerIsPlayingChanged(this.isPlaying);
}
