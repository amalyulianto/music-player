import 'package:equatable/equatable.dart';

/// Represents a specific audio track within a song.
class AudioTrack extends Equatable {
  /// The unique identifier of the audio track.
  final int id;

  /// The URL of the audio file.
  final String audioUrl;

  /// The Arabic text content of the track.
  final String arabicText;

  /// The track index (position) within the song.
  final int trackIndex;

  /// Creates an [AudioTrack] entity.
  const AudioTrack({
    required this.id,
    required this.audioUrl,
    required this.arabicText,
    required this.trackIndex,
  });

  @override
  List<Object?> get props => [id, audioUrl, arabicText, trackIndex];
}
