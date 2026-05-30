import 'package:equatable/equatable.dart';
import '../../../domain/entities/song.dart';

/// Abstract class for all song list states.
abstract class SongState extends Equatable {
  /// Const constructor.
  const SongState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the song list.
class SongInitial extends SongState {
  /// Const constructor.
  const SongInitial();

  @override
  List<Object?> get props => [];
}

/// State when songs are being loaded from the repository.
class SongLoading extends SongState {
  /// Const constructor.
  const SongLoading();

  @override
  List<Object?> get props => [];
}

/// State when songs are successfully loaded.
class SongLoaded extends SongState {
  /// All available songs.
  final List<Song> songs;

  /// The filtered list of songs based on search criteria.
  final List<Song> filteredSongs;

  /// The active search query.
  final String searchQuery;

  /// Creates a [SongLoaded] state.
  const SongLoaded({
    required this.songs,
    required this.filteredSongs,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [songs, filteredSongs, searchQuery];
}

/// State when song loading has failed.
class SongError extends SongState {
  /// The descriptive error message.
  final String message;

  /// Creates a [SongError] state.
  const SongError(this.message);

  @override
  List<Object?> get props => [message];
}

