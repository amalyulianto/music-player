import 'package:equatable/equatable.dart';

class AudioTrack extends Equatable {
  final int id;

  final String audioUrl;

  final String arabicText;

  final int trackIndex;

  const AudioTrack({
    required this.id,
    required this.audioUrl,
    required this.arabicText,
    required this.trackIndex,
  });

  @override
  List<Object?> get props => [id, audioUrl, arabicText, trackIndex];
}
