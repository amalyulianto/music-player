import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart' hide PlayerState;
import '../../../core/audio/audio_service.dart';
import '../../../core/utils/result.dart';
import '../../../domain/entities/song.dart';
import '../../../domain/entities/song_detail.dart';
import '../../../domain/usecases/get_song_detail_usecase.dart';
import '../../../domain/usecases/get_song_list_usecase.dart';
import 'player_event.dart';
import 'player_state.dart';

/// Manages the audio player state and coordinates with [AudioService].
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetSongDetailUseCase _getSongDetailUseCase;
  final GetSongListUseCase _getSongListUseCase;
  final AudioService _audioService;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<bool>? _playingSub;
  StreamSubscription<ProcessingState>? _processingStateSub;
  int? _currentRequestedSongId;

  bool _isShuffle = false;
  bool _isRepeat = false;

  /// The last requested song ID, used for retry controls on error.
  int? get lastRequestedSongId => _currentRequestedSongId;

  /// Creates a [PlayerBloc] instance.
  PlayerBloc({
    required GetSongDetailUseCase getSongDetailUseCase,
    required GetSongListUseCase getSongListUseCase,
    required AudioService audioService,
  }) : _getSongDetailUseCase = getSongDetailUseCase,
       _getSongListUseCase = getSongListUseCase,
       _audioService = audioService,
       super(const PlayerInitial()) {
    on<PlayerSongRequested>(_onSongRequested);
    on<PlayerPauseRequested>(_onPauseRequested);
    on<PlayerResumeRequested>(_onResumeRequested);
    on<PlayerSeekRequested>(_onSeekRequested);
    on<PlayerNextRequested>(_onNextRequested);
    on<PlayerPreviousRequested>(_onPreviousRequested);
    on<PlayerPositionUpdated>(_onPositionUpdated);
    on<PlayerDurationUpdated>(_onDurationUpdated);
    on<PlayerIsPlayingChanged>(_onIsPlayingChanged);
    on<PlayerShuffleToggled>(_onShuffleToggled);
    on<PlayerRepeatToggled>(_onRepeatToggled);
    on<PlayerPlaybackCompleted>(_onPlaybackCompleted);

    _positionSub = _audioService.positionStream.listen(
      (pos) => add(PlayerPositionUpdated(pos)),
    );
    _durationSub = _audioService.durationStream.listen((dur) {
      if (dur != null) {
        add(PlayerDurationUpdated(dur));
      }
    });
    _playingSub = _audioService.isPlayingStream.listen(
      (p) => add(PlayerIsPlayingChanged(p)),
    );
    _processingStateSub = _audioService.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        add(const PlayerPlaybackCompleted());
      }
    });
  }

  Future<void> _onSongRequested(
    PlayerSongRequested event,
    Emitter<PlayerState> emit,
  ) async {
    _currentRequestedSongId = event.songId;
    final targetSongId = event.songId;

    emit(const PlayerLoading());
    final result = await _getSongDetailUseCase(event.songId);

    if (_currentRequestedSongId != targetSongId) {
      return;
    }

    if (result is Success<SongDetail>) {
      final detail = result.data;
      try {
        await _audioService.playSong(detail);

        if (_currentRequestedSongId != targetSongId) {
          return;
        }

        final currentDuration = _audioService.currentDuration ?? Duration.zero;
        final currentPosition = _audioService.currentPosition;
        final isPlaying = _audioService.isPlaying;
        emit(
          PlayerActive(
            song: Song(
              id: detail.id,
              title: detail.title,
              subtitle: detail.subtitle,
              arabicName: '',
              trackCount: detail.audioTracks.length,
              category: '',
            ),
            position: currentPosition,
            totalDuration: currentDuration,
            isPlaying: isPlaying,
            isShuffle: _isShuffle,
            isRepeat: _isRepeat,
          ),
        );
      } catch (e) {
        if (_currentRequestedSongId == targetSongId) {
          emit(PlayerError(e.toString()));
        }
      }
    } else if (result is Failure<SongDetail>) {
      if (_currentRequestedSongId == targetSongId) {
        emit(PlayerError(result.message));
      }
    }
  }

  Future<void> _onPauseRequested(
    PlayerPauseRequested event,
    Emitter<PlayerState> emit,
  ) async {
    await _audioService.pause();
    if (state is PlayerActive) {
      emit((state as PlayerActive).copyWith(isPlaying: false));
    }
  }

  Future<void> _onResumeRequested(
    PlayerResumeRequested event,
    Emitter<PlayerState> emit,
  ) async {
    await _audioService.resume();
    if (state is PlayerActive) {
      emit((state as PlayerActive).copyWith(isPlaying: true));
    }
  }

  Future<void> _onSeekRequested(
    PlayerSeekRequested event,
    Emitter<PlayerState> emit,
  ) async {
    await _audioService.seek(event.position);
  }

  Future<void> _onNextRequested(
    PlayerNextRequested event,
    Emitter<PlayerState> emit,
  ) async {
    if (state is! PlayerActive) return;
    final activeSong = (state as PlayerActive).song;

    final result = await _getSongListUseCase();
    if (result is Success<List<Song>> && result.data.isNotEmpty) {
      final songs = result.data;
      final currentIndex = songs.indexWhere((s) => s.id == activeSong.id);
      if (currentIndex != -1) {
        int nextIndex;
        if (_isShuffle && songs.length > 1) {
          final random = DateTime.now().millisecond;
          nextIndex = (currentIndex + 1 + random) % songs.length;
          if (nextIndex == currentIndex) {
            nextIndex = (currentIndex + 1) % songs.length;
          }
        } else {
          nextIndex = (currentIndex + 1) % songs.length;
        }
        add(PlayerSongRequested(songs[nextIndex].id));
      }
    }
  }

  Future<void> _onPreviousRequested(
    PlayerPreviousRequested event,
    Emitter<PlayerState> emit,
  ) async {
    if (state is! PlayerActive) return;
    final activeSong = (state as PlayerActive).song;

    final result = await _getSongListUseCase();
    if (result is Success<List<Song>> && result.data.isNotEmpty) {
      final songs = result.data;
      final currentIndex = songs.indexWhere((s) => s.id == activeSong.id);
      if (currentIndex != -1) {
        int prevIndex;
        if (_isShuffle && songs.length > 1) {
          final random = DateTime.now().millisecond;
          prevIndex = (currentIndex - 1 - random + songs.length) % songs.length;
          if (prevIndex == currentIndex) {
            prevIndex = (currentIndex - 1 + songs.length) % songs.length;
          }
        } else {
          prevIndex = (currentIndex - 1 + songs.length) % songs.length;
        }
        add(PlayerSongRequested(songs[prevIndex].id));
      }
    }
  }

  void _onShuffleToggled(
    PlayerShuffleToggled event,
    Emitter<PlayerState> emit,
  ) {
    _isShuffle = !_isShuffle;
    if (state is PlayerActive) {
      emit((state as PlayerActive).copyWith(isShuffle: _isShuffle));
    }
  }

  Future<void> _onRepeatToggled(
    PlayerRepeatToggled event,
    Emitter<PlayerState> emit,
  ) async {
    _isRepeat = !_isRepeat;
    await _audioService.setRepeatMode(_isRepeat);
    if (state is PlayerActive) {
      emit((state as PlayerActive).copyWith(isRepeat: _isRepeat));
    }
  }

  void _onPositionUpdated(
    PlayerPositionUpdated event,
    Emitter<PlayerState> emit,
  ) {
    if (state is PlayerActive) {
      emit((state as PlayerActive).copyWith(position: event.position));
    }
  }

  void _onDurationUpdated(
    PlayerDurationUpdated event,
    Emitter<PlayerState> emit,
  ) {
    if (state is PlayerActive) {
      emit((state as PlayerActive).copyWith(totalDuration: event.duration));
    }
  }

  void _onIsPlayingChanged(
    PlayerIsPlayingChanged event,
    Emitter<PlayerState> emit,
  ) {
    if (state is PlayerActive) {
      emit((state as PlayerActive).copyWith(isPlaying: event.isPlaying));
    }
  }

  void _onPlaybackCompleted(
    PlayerPlaybackCompleted event,
    Emitter<PlayerState> emit,
  ) {
    if (state is PlayerActive) {
      add(const PlayerNextRequested());
    }
  }

  @override
  Future<void> close() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playingSub?.cancel();
    _processingStateSub?.cancel();
    return super.close();
  }
}
