/// Abstract class for all player events.
abstract class PlayerEvent {
  const PlayerEvent();
}

/// Event to request playing a song by its identifier.
class PlayerSongRequested extends PlayerEvent {
  final int songId;
  const PlayerSongRequested(this.songId);
}

/// Event to request pausing the current song.
class PlayerPauseRequested extends PlayerEvent {
  const PlayerPauseRequested();
}

/// Event to request resuming the current song.
class PlayerResumeRequested extends PlayerEvent {
  /// Creates a [PlayerResumeRequested] event.
  const PlayerResumeRequested();
}

/// Event to seek playback to a specific position.
class PlayerSeekRequested extends PlayerEvent {
  final Duration position;
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
  final Duration position;
  const PlayerPositionUpdated(this.position);
}

/// Internal event fired when the song total duration is loaded/changed.
class PlayerDurationUpdated extends PlayerEvent {
  final Duration duration;
  const PlayerDurationUpdated(this.duration);
}

/// Internal event fired when the playing status is changed.
class PlayerIsPlayingChanged extends PlayerEvent {
  final bool isPlaying;
  const PlayerIsPlayingChanged(this.isPlaying);
}

/// Event to request toggling shuffle mode.
class PlayerShuffleToggled extends PlayerEvent {
  /// Creates a [PlayerShuffleToggled] event.
  const PlayerShuffleToggled();
}

/// Event to request toggling repeat mode.
class PlayerRepeatToggled extends PlayerEvent {
  /// Creates a [PlayerRepeatToggled] event.
  const PlayerRepeatToggled();
}

/// Internal event fired when a song finishes playback completely.
class PlayerPlaybackCompleted extends PlayerEvent {
  /// Creates a [PlayerPlaybackCompleted] event.
  const PlayerPlaybackCompleted();
}
