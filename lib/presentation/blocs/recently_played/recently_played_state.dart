import 'package:equatable/equatable.dart';
import '../../../domain/entities/song.dart';

/// Abstract class for all recently played states.
abstract class RecentlyPlayedState extends Equatable {
  const RecentlyPlayedState();

  @override
  List<Object?> get props => [];
}

/// Initial state of recently played.
class RecentlyPlayedInitial extends RecentlyPlayedState {
  const RecentlyPlayedInitial();
}

/// Ready state containing the list of recently played songs.
class RecentlyPlayedReady extends RecentlyPlayedState {
  final List<Song> songs;
  const RecentlyPlayedReady(this.songs);

  @override
  List<Object> get props => [songs];
}
