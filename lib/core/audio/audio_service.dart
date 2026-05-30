import 'package:just_audio/just_audio.dart';
import '../../domain/entities/song_detail.dart';

/// Service class interfacing with [AudioPlayer] from just_audio.
class AudioService {
  final AudioPlayer _player = AudioPlayer();

  /// Creates an [AudioService] instance.
  AudioService();

  /// Exposes the playing status stream.
  Stream<bool> get isPlayingStream => _player.playingStream;

  /// Exposes the current playback position stream.
  Stream<Duration> get positionStream => _player.positionStream;

  /// Exposes the total duration stream.
  Stream<Duration?> get durationStream => _player.durationStream;

  /// Returns whether the player is currently playing.
  bool get isPlaying => _player.playing;

  /// Returns the current playback position of the player.
  Duration get currentPosition => _player.position;

  /// Returns the total duration of the current audio source.
  Duration? get currentDuration => _player.duration;

  /// Loads and plays a song consisting of multiple audio tracks.
  ///
  /// Concatentates all tracks inside [song] as one seamless stream.
  Future<void> playSong(SongDetail song) async {
    final source = ConcatenatingAudioSource(
      children: song.audioTracks
          .map((t) => AudioSource.uri(Uri.parse(t.audioUrl)))
          .toList(),
    );
    await _player.setAudioSource(source);
    await _player.play();
  }

  /// Pauses the audio playback.
  Future<void> pause() => _player.pause();

  /// Resumes the audio playback.
  Future<void> resume() => _player.play();

  /// Seeks to a specific [position] in the playback.
  Future<void> seek(Duration position) => _player.seek(position);

  /// Disposes and cleans up the audio player resources.
  Future<void> dispose() => _player.dispose();
}
