import 'dart:async';
import 'package:just_audio/just_audio.dart';
import '../../domain/entities/song_detail.dart';

/// Service class interfacing with [AudioPlayer] from just_audio.
class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final StreamController<Duration> _totalPositionController = StreamController<Duration>.broadcast();
  final StreamController<Duration> _totalDurationController = StreamController<Duration>.broadcast();
  final List<Duration> _trackDurations = [];
  Duration _stableTotalDuration = Duration.zero;

  /// Creates an [AudioService] instance.
  AudioService() {
    _player.positionStream.listen((_) => _emitTotalPositionAndDuration());
    _player.currentIndexStream.listen((_) => _emitTotalPositionAndDuration());
    _player.sequenceStateStream.listen((_) => _emitTotalPositionAndDuration());
  }

  void _emitTotalPositionAndDuration() {
    final index = _player.currentIndex;
    final sequence = _player.sequence;
    if (index == null || sequence == null) {
      _totalPositionController.add(Duration.zero);
      _totalDurationController.add(Duration.zero);
      return;
    }

    final safeIndex = index.clamp(0, _trackDurations.length);
    final previousDuration = _trackDurations
        .sublist(0, safeIndex)
        .fold<Duration>(Duration.zero, (prev, curr) => prev + curr);

    // Scale the current track's position proportionally
    Duration scaledPos = _player.position;
    if (safeIndex < _trackDurations.length) {
      final estimatedDur = _trackDurations[safeIndex];
      final actualDur = sequence[index].duration;
      if (actualDur != null && actualDur > Duration.zero) {
        final ratio = estimatedDur.inMilliseconds / actualDur.inMilliseconds;
        scaledPos = Duration(milliseconds: (_player.position.inMilliseconds * ratio).round());
        if (scaledPos > estimatedDur) {
          scaledPos = estimatedDur;
        }
      } else {
        if (scaledPos > estimatedDur) {
          scaledPos = estimatedDur;
        }
      }
    }

    var totalPos = previousDuration + scaledPos;
    if (totalPos > _stableTotalDuration) {
      totalPos = _stableTotalDuration;
    } else if (totalPos < Duration.zero) {
      totalPos = Duration.zero;
    }
    _totalPositionController.add(totalPos);
    _totalDurationController.add(_stableTotalDuration);
  }

  /// Exposes the playing status stream.
  Stream<bool> get isPlayingStream => _player.playingStream;

  /// Exposes the player's processing state stream.
  Stream<ProcessingState> get processingStateStream => _player.processingStateStream;

  /// Exposes the concatenated playback position stream.
  Stream<Duration> get positionStream => _totalPositionController.stream;

  /// Exposes the concatenated total duration stream.
  Stream<Duration?> get durationStream => _totalDurationController.stream;

  /// Returns whether the player is currently playing.
  bool get isPlaying => _player.playing;

  /// Returns the current concatenated playback position of the player.
  Duration get currentPosition {
    final index = _player.currentIndex;
    final sequence = _player.sequence;
    if (index == null || sequence == null) {
      return _player.position;
    }

    final safeIndex = index.clamp(0, _trackDurations.length);
    final previousDuration = _trackDurations
        .sublist(0, safeIndex)
        .fold<Duration>(Duration.zero, (prev, curr) => prev + curr);

    Duration scaledPos = _player.position;
    if (safeIndex < _trackDurations.length) {
      final estimatedDur = _trackDurations[safeIndex];
      final actualDur = sequence[index].duration;
      if (actualDur != null && actualDur > Duration.zero) {
        final ratio = estimatedDur.inMilliseconds / actualDur.inMilliseconds;
        scaledPos = Duration(milliseconds: (_player.position.inMilliseconds * ratio).round());
        if (scaledPos > estimatedDur) {
          scaledPos = estimatedDur;
        }
      } else {
        if (scaledPos > estimatedDur) {
          scaledPos = estimatedDur;
        }
      }
    }

    var totalPos = previousDuration + scaledPos;
    if (totalPos > _stableTotalDuration) {
      totalPos = _stableTotalDuration;
    } else if (totalPos < Duration.zero) {
      totalPos = Duration.zero;
    }
    return totalPos;
  }

  /// Returns the concatenated total duration of the current audio source.
  Duration? get currentDuration => _stableTotalDuration;

  /// Loads and plays a song consisting of multiple audio tracks.
  ///
  /// Concatentates all tracks inside [song] as one seamless stream.
  Future<void> playSong(SongDetail song) async {
    _trackDurations.clear();
    for (final track in song.audioTracks) {
      _trackDurations.add(_estimateAyahDuration(track.arabicText));
    }
    _stableTotalDuration = _trackDurations.fold<Duration>(Duration.zero, (p, c) => p + c);

    final source = ConcatenatingAudioSource(
      children: song.audioTracks
          .map((t) => AudioSource.uri(Uri.parse(t.audioUrl)))
          .toList(),
    );
    await _player.setAudioSource(source);
    await _player.play();
  }

  Duration _estimateAyahDuration(String arabicText) {
    if (arabicText.isEmpty) return const Duration(seconds: 5);
    final words = arabicText.trim().split(RegExp(r'\s+')).length;
    return Duration(seconds: (words * 2.2).clamp(3.0, 120.0).round());
  }

  /// Pauses the audio playback.
  Future<void> pause() => _player.pause();

  /// Resumes the audio playback.
  Future<void> resume() => _player.play();

  /// Sets repeat mode natively on/off.
  Future<void> setRepeatMode(bool enabled) =>
      _player.setLoopMode(enabled ? LoopMode.all : LoopMode.off);

  /// Seeks to a specific [position] in the concatenated playback.
  Future<void> seek(Duration position) async {
    final sequence = _player.sequence;
    if (sequence == null) {
      await _player.seek(position);
      return;
    }

    Duration accumulated = Duration.zero;
    int targetIndex = 0;
    Duration relativeOffset = position;

    for (int i = 0; i < _trackDurations.length; i++) {
      final trackDuration = _trackDurations[i];
      if (accumulated + trackDuration > position) {
        targetIndex = i;
        relativeOffset = position - accumulated;
        break;
      }
      accumulated += trackDuration;
      if (i == _trackDurations.length - 1) {
        targetIndex = i;
        relativeOffset = position - (accumulated - trackDuration);
      }
    }

    // Map estimated relativeOffset back to actual relativeOffset to perform native seek
    Duration targetSeekOffset = relativeOffset;
    if (targetIndex < _trackDurations.length) {
      final estimatedDur = _trackDurations[targetIndex];
      final actualDur = sequence[targetIndex].duration;
      if (actualDur != null && actualDur > Duration.zero && estimatedDur > Duration.zero) {
        final ratio = actualDur.inMilliseconds / estimatedDur.inMilliseconds;
        targetSeekOffset = Duration(milliseconds: (relativeOffset.inMilliseconds * ratio).round());
        if (targetSeekOffset > actualDur) {
          targetSeekOffset = actualDur;
        }
      }
    }

    await _player.seek(targetSeekOffset, index: targetIndex);
  }

  /// Disposes and cleans up the audio player resources.
  Future<void> dispose() async {
    await _totalPositionController.close();
    await _totalDurationController.close();
    await _player.dispose();
  }
}
