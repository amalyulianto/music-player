import 'package:equatable/equatable.dart';
import 'audio_track.dart';

class SongDetail extends Equatable {
  final int id;

  final String title;

  final String subtitle;

  final List<AudioTrack> audioTracks;

  const SongDetail({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.audioTracks,
  });

  @override
  List<Object?> get props => [id, title, subtitle, audioTracks];
}
