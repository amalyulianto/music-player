import 'package:equatable/equatable.dart';

/// Represents a song in the music player.
class Song extends Equatable {
  /// The unique identifier of the song.
  final int id;

  /// The English title of the song.
  final String title;

  /// The English translation/subtitle of the song.
  final String subtitle;

  /// The native Arabic name of the song.
  final String arabicName;

  /// The total number of audio tracks in this song.
  final int trackCount;

  /// The category or origin classification of the song.
  final String category;

  /// Creates a [Song] entity.
  const Song({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.arabicName,
    required this.trackCount,
    required this.category,
  });

  @override
  List<Object?> get props => [id, title, subtitle, arabicName, trackCount, category];
}
