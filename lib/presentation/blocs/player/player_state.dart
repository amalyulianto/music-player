import 'package:equatable/equatable.dart';
import '../../../domain/entities/song.dart';

/// Abstract class for all player states.
abstract class PlayerState extends Equatable {
  const PlayerState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the player before any song is selected.
class PlayerInitial extends PlayerState {
  /// Creates a [PlayerInitial] state.
  const PlayerInitial();
}

/// State indicating the player is currently loading a song's details/audio.
class PlayerLoading extends PlayerState {
  /// Creates a [PlayerLoading] state.
  const PlayerLoading();
}

/// State indicating a song is active (either playing or paused).
class PlayerActive extends PlayerState {
  /// The song currently loaded in the player.
  final Song song;

  /// The current playback position.
  final Duration position;

  /// The total duration of the song.
  final Duration totalDuration;

  /// Whether the audio is currently playing.
  final bool isPlaying;

  /// Whether the player is in shuffle mode.
  final bool isShuffle;

  /// Whether the player is in repeat mode.
  final bool isRepeat;

  /// Creates a [PlayerActive] state.
  const PlayerActive({
    required this.song,
    required this.position,
    required this.totalDuration,
    required this.isPlaying,
    this.isShuffle = false,
    this.isRepeat = false,
  });

  /// Creates a copy of this state with the given fields replaced.
  PlayerActive copyWith({
    Song? song,
    Duration? position,
    Duration? totalDuration,
    bool? isPlaying,
    bool? isShuffle,
    bool? isRepeat,
  }) {
    return PlayerActive(
      song: song ?? this.song,
      position: position ?? this.position,
      totalDuration: totalDuration ?? this.totalDuration,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffle: isShuffle ?? this.isShuffle,
      isRepeat: isRepeat ?? this.isRepeat,
    );
  }

  @override
  List<Object?> get props => [
    song,
    position,
    totalDuration,
    isPlaying,
    isShuffle,
    isRepeat,
  ];
}

/// State indicating that an error occurred in loading/playing a song.
class PlayerError extends PlayerState {
  /// The descriptive error message.
  final String message;

  /// Creates a [PlayerError] state with the given [message].
  const PlayerError(this.message);

  @override
  List<Object?> get props => [message];
}
