import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/entities/song.dart';
import 'recently_played_event.dart';
import 'recently_played_state.dart';

/// Manages recently played songs persistence and state.
class RecentlyPlayedBloc extends Bloc<RecentlyPlayedEvent, RecentlyPlayedState> {
  final SharedPreferences _prefs;

  /// Creates a [RecentlyPlayedBloc] instance.
  RecentlyPlayedBloc({
    required SharedPreferences prefs,
  })  : _prefs = prefs,
        super(const RecentlyPlayedInitial()) {
    on<RecentlyPlayedRestored>(_onRecentlyPlayedRestored);
    on<RecentlyPlayedSongAdded>(_onRecentlyPlayedSongAdded);
    add(const RecentlyPlayedRestored());
  }

  Future<void> _onRecentlyPlayedRestored(
    RecentlyPlayedRestored event,
    Emitter<RecentlyPlayedState> emit,
  ) async {
    final raw = _prefs.getString('recently_played') ?? '';
    if (raw.isEmpty) {
      emit(const RecentlyPlayedReady([]));
      return;
    }
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final songs = decoded.map((item) {
        final map = item as Map<String, dynamic>;
        return Song(
          id: map['id'] as int,
          title: map['title'] as String,
          subtitle: map['subtitle'] as String,
          arabicName: map['arabicName'] as String,
          trackCount: map['trackCount'] as int,
          category: map['category'] as String,
        );
      }).toList();
      emit(RecentlyPlayedReady(songs));
    } catch (_) {
      emit(const RecentlyPlayedReady([]));
    }
  }

  Future<void> _onRecentlyPlayedSongAdded(
    RecentlyPlayedSongAdded event,
    Emitter<RecentlyPlayedState> emit,
  ) async {
    final list = List<Song>.from((state as RecentlyPlayedReady?)?.songs ?? []);

    list.removeWhere((s) => s.id == event.song.id);
    list.insert(0, event.song);

    if (list.length > 10) {
      list.removeLast();
    }

    final jsonList = list.map((song) => {
      'id': song.id,
      'title': song.title,
      'subtitle': song.subtitle,
      'arabicName': song.arabicName,
      'trackCount': song.trackCount,
      'category': song.category,
    }).toList();

    await _prefs.setString('recently_played', jsonEncode(jsonList));
    emit(RecentlyPlayedReady(list));
  }
}

