import 'package:equatable/equatable.dart';
import '../../../domain/entities/song.dart';

/// Abstract class for all recently played states.
abstract class RecentlyPlayedState extends Equatable {
  /// Const constructor.
  const RecentlyPlayedState();

  @override
  List<Object?> get props => [];
}

/// Initial state of recently played.
class RecentlyPlayedInitial extends RecentlyPlayedState {
  /// Const constructor.
  const RecentlyPlayedInitial();
}

/// Ready state containing the list of recently played songs.
class RecentlyPlayedReady extends RecentlyPlayedState {
  /// The list of recently played songs.
  final List<Song> songs;

  /// Creates a [RecentlyPlayedReady] state.
  const RecentlyPlayedReady(this.songs);

  @override
  List<Object> get props => [songs];
}

