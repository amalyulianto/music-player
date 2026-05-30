import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/result.dart';
import '../../../domain/entities/song.dart';
import '../../../domain/usecases/get_song_list_usecase.dart';
import 'song_event.dart';
import 'song_state.dart';

/// Manages the song list state.
class SongBloc extends Bloc<SongEvent, SongState> {
  final GetSongListUseCase _getSongListUseCase;

  /// Creates a [SongBloc] instance.
  SongBloc({
    required GetSongListUseCase getSongListUseCase,
  })  : _getSongListUseCase = getSongListUseCase,
        super(const SongInitial()) {
    on<SongListRequested>(_onListRequested);
    on<SongSearchQueryChanged>(_onSearchChanged);
  }

  Future<void> _onListRequested(
    SongListRequested event,
    Emitter<SongState> emit,
  ) async {
    emit(const SongLoading());
    final result = await _getSongListUseCase();
    switch (result) {
      case Success<List<Song>>(:final data):
        emit(SongLoaded(
          songs: data,
          filteredSongs: data,
          searchQuery: '',
        ));
      case Failure<List<Song>>(:final message):
        emit(SongError(message));
    }
  }

  void _onSearchChanged(
    SongSearchQueryChanged event,
    Emitter<SongState> emit,
  ) {
    final currentState = state;
    if (currentState is SongLoaded) {
      final query = event.query.toLowerCase();
      final filtered = currentState.songs.where((song) {
        final titleMatch = song.title.toLowerCase().contains(query);
        final subtitleMatch = song.subtitle.toLowerCase().contains(query);
        return titleMatch || subtitleMatch;
      }).toList();
      emit(SongLoaded(
        songs: currentState.songs,
        filteredSongs: filtered,
        searchQuery: event.query,
      ));
    }
  }
}

