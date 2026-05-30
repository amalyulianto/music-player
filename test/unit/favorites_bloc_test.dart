import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:music_player/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:music_player/presentation/blocs/favorites/favorites_event.dart';
import 'package:music_player/presentation/blocs/favorites/favorites_state.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
  });

  group('FavoritesBloc', () {
    blocTest<FavoritesBloc, FavoritesState>(
      'FavoriteToggled adds id: set contains id, prefs saved',
      build: () {
        when(() => mockPrefs.getString('favorite_song_ids')).thenReturn('1,2');
        when(() => mockPrefs.setString('favorite_song_ids', any()))
            .thenAnswer((_) async => true);
        return FavoritesBloc(prefs: mockPrefs);
      },
      act: (bloc) => bloc.add(const FavoriteToggled(3)),
      expect: () => [
        const FavoritesReady({1, 2}),
        const FavoritesReady({1, 2, 3}),
      ],
      verify: (_) {
        verify(() => mockPrefs.getString('favorite_song_ids')).called(1);
        verify(() => mockPrefs.setString('favorite_song_ids', '1,2,3')).called(1);
      },
    );

    blocTest<FavoritesBloc, FavoritesState>(
      'FavoriteToggled removes id: set no longer contains id, prefs saved',
      build: () {
        when(() => mockPrefs.getString('favorite_song_ids')).thenReturn('1,2');
        when(() => mockPrefs.setString('favorite_song_ids', any()))
            .thenAnswer((_) async => true);
        return FavoritesBloc(prefs: mockPrefs);
      },
      act: (bloc) => bloc.add(const FavoriteToggled(2)),
      expect: () => [
        const FavoritesReady({1, 2}),
        const FavoritesReady({1}),
      ],
      verify: (_) {
        verify(() => mockPrefs.getString('favorite_song_ids')).called(1);
        verify(() => mockPrefs.setString('favorite_song_ids', '1')).called(1);
      },
    );
  });
}
