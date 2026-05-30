import 'package:equatable/equatable.dart';
import 'audio_track.dart';

/// Represents the detailed information of a song, including all its audio tracks.
class SongDetail extends Equatable {
  /// The unique identifier of the song.
  final int id;

  /// The English title of the song.
  final String title;

  /// The English translation/subtitle of the song.
  final String subtitle;

  /// The list of audio tracks associated with this song.
  final List<AudioTrack> audioTracks;

  /// Creates a [SongDetail] entity.
  const SongDetail({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.audioTracks,
  });

  @override
  List<Object?> get props => [id, title, subtitle, audioTracks];
}
