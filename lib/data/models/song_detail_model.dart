import '../../domain/entities/song_detail.dart';
import 'audio_track_model.dart';

/// Model representing a detailed song including tracks from the network response.
class SongDetailModel {
  final int id;

  final String title;

  final String subtitle;

  final List<AudioTrackModel> audioTracks;

  const SongDetailModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.audioTracks,
  });

  /// Factory constructor to parse a [SongDetailModel] from API JSON.
  /// API key strings appear ONLY inside fromJson().
  factory SongDetailModel.fromJson(Map<String, dynamic> json) {
    return SongDetailModel(
      id: json['number'] as int,
      title: json['englishName'] as String,
      subtitle: json['englishNameTranslation'] as String,
      audioTracks: (json['ayahs'] as List)
          .map((e) => AudioTrackModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts this [SongDetailModel] to a domain [SongDetail] entity.
  SongDetail toEntity() {
    return SongDetail(
      id: id,
      title: title,
      subtitle: subtitle,
      audioTracks: audioTracks.map((t) => t.toEntity()).toList(),
    );
  }
}
