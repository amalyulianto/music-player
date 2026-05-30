import '../../domain/entities/audio_track.dart';

/// Model representing an audio track from the network response.
class AudioTrackModel {
  final int id;

  final int trackIndex;

  final String audioUrl;

  final String arabicText;

  const AudioTrackModel({
    required this.id,
    required this.trackIndex,
    required this.audioUrl,
    required this.arabicText,
  });

  /// Factory constructor to parse an [AudioTrackModel] from API JSON.
  /// API key strings appear ONLY inside fromJson().
  factory AudioTrackModel.fromJson(Map<String, dynamic> json) {
    return AudioTrackModel(
      id: json['number'] as int,
      audioUrl: json['audio'] as String,
      arabicText: json['text'] as String,
      trackIndex: json['numberInSurah'] as int,
    );
  }

  /// Converts this [AudioTrackModel] to a domain [AudioTrack] entity.
  AudioTrack toEntity() {
    return AudioTrack(
      id: id,
      audioUrl: audioUrl,
      arabicText: arabicText,
      trackIndex: trackIndex,
    );
  }
}
