import '../../domain/entities/song.dart';

/// Model representing a song from the network response.
class SongModel {
  /// The unique identifier of the song.
  final int id;

  /// The total number of audio tracks in this song.
  final int trackCount;

  /// The English title of the song.
  final String title;

  /// The English translation/subtitle of the song.
  final String subtitle;

  /// The native Arabic name of the song.
  final String arabicName;

  /// The category or origin classification of the song.
  final String category;

  /// Creates a [SongModel] instance.
  const SongModel({
    required this.id,
    required this.trackCount,
    required this.title,
    required this.subtitle,
    required this.arabicName,
    required this.category,
  });

  /// Factory constructor to parse a [SongModel] from API JSON.
  /// API key strings appear ONLY inside fromJson().
  factory SongModel.fromJson(Map<String, dynamic> json) {
    return SongModel(
      id: json['number'] as int,
      title: json['englishName'] as String,
      subtitle: json['englishNameTranslation'] as String,
      arabicName: json['name'] as String,
      trackCount: json['numberOfAyahs'] as int,
      category: json['revelationType'] as String,
    );
  }

  /// Converts this [SongModel] to a domain [Song] entity.
  Song toEntity() {
    return Song(
      id: id,
      title: title,
      subtitle: subtitle,
      arabicName: arabicName,
      trackCount: trackCount,
      category: category,
    );
  }
}
