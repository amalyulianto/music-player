import 'package:equatable/equatable.dart';
import '../../../domain/entities/song.dart';

/// Abstract class for all player states.
abstract class PlayerState extends Equatable {
  /// Const constructor.
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

  /// Creates a [PlayerActive] state.
  const PlayerActive({
    required this.song,
    required this.position,
    required this.totalDuration,
    required this.isPlaying,
  });

  /// Creates a copy of this state with the given fields replaced.
  PlayerActive copyWith({
    Song? song,
    Duration? position,
    Duration? totalDuration,
    bool? isPlaying,
  }) {
    return PlayerActive(
      song: song ?? this.song,
      position: position ?? this.position,
      totalDuration: totalDuration ?? this.totalDuration,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }

  @override
  List<Object?> get props => [song, position, totalDuration, isPlaying];
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

