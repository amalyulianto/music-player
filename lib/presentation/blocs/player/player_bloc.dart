import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/audio/audio_service.dart';
import '../../../core/utils/result.dart';
import '../../../domain/entities/song.dart';
import '../../../domain/entities/song_detail.dart';
import '../../../domain/usecases/get_song_detail_usecase.dart';
import 'player_event.dart';
import 'player_state.dart';

/// Manages the audio player state and coordinates with [AudioService].
class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final GetSongDetailUseCase _getSongDetailUseCase;
  final AudioService _audioService;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<bool>? _playingSub;

  /// Creates a [PlayerBloc] instance.
  PlayerBloc({
    required GetSongDetailUseCase getSongDetailUseCase,
    required AudioService audioService,
  }) : _getSongDetailUseCase = getSongDetailUseCase,
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
  }

  Future<void> _onSongRequested(
    PlayerSongRequested event,
    Emitter<PlayerState> emit,
  ) async {
    emit(const PlayerLoading());
    final result = await _getSongDetailUseCase(event.songId);
    if (result is Success<SongDetail>) {
      final detail = result.data;
      try {
        await _audioService.playSong(detail);
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
          ),
        );
      } catch (e) {
        emit(PlayerError(e.toString()));
      }
    } else if (result is Failure<SongDetail>) {
      emit(PlayerError(result.message));
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

  void _onNextRequested(PlayerNextRequested event, Emitter<PlayerState> emit) {
    // Stub for next requested
  }

  void _onPreviousRequested(
    PlayerPreviousRequested event,
    Emitter<PlayerState> emit,
  ) {
    // Stub for previous requested
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

  @override
  Future<void> close() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playingSub?.cancel();
    return super.close();
  }
}
