import '../../domain/entities/song.dart';

class SongModel {
  final int id;

  final int trackCount;

  final String title;

  final String subtitle;

  final String arabicName;

  final String category;

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
