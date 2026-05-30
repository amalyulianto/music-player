import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/core/utils/result.dart';
import 'package:music_player/domain/entities/song.dart';
import 'package:music_player/domain/usecases/get_song_list_usecase.dart';
import 'package:music_player/presentation/blocs/song/song_bloc.dart';
import 'package:music_player/presentation/blocs/song/song_event.dart';
import 'package:music_player/presentation/blocs/song/song_state.dart';

class MockGetSongListUseCase extends Mock implements GetSongListUseCase {}

void main() {
  late MockGetSongListUseCase mockGetSongListUseCase;

  setUp(() {
    mockGetSongListUseCase = MockGetSongListUseCase();
  });

  const mockSongs = [
    Song(
      id: 1,
      title: 'Bohemian Rhapsody',
      subtitle: 'Queen',
      arabicName: 'الملحمة البوهيمية',
      trackCount: 1,
      category: 'Rock',
    ),
    Song(
      id: 2,
      title: 'Imagine',
      subtitle: 'John Lennon',
      arabicName: 'تخيل',
      trackCount: 1,
      category: 'Pop',
    ),
  ];

  group('SongBloc', () {
    blocTest<SongBloc, SongState>(
      'emits [SongLoading, SongLoaded] when SongListRequested is successful',
      build: () {
        when(
          () => mockGetSongListUseCase(),
        ).thenAnswer((_) async => const Success(mockSongs));
        return SongBloc(getSongListUseCase: mockGetSongListUseCase);
      },
      act: (bloc) => bloc.add(SongListRequested()),
      expect: () => [
        const SongLoading(),
        const SongLoaded(
          songs: mockSongs,
          filteredSongs: mockSongs,
          searchQuery: '',
        ),
      ],
    );

    blocTest<SongBloc, SongState>(
      'emits [SongLoading, SongError] when SongListRequested fails',
      build: () {
        when(
          () => mockGetSongListUseCase(),
        ).thenAnswer((_) async => const Failure('Failed to fetch songs'));
        return SongBloc(getSongListUseCase: mockGetSongListUseCase);
      },
      act: (bloc) => bloc.add(SongListRequested()),
      expect: () => [
        const SongLoading(),
        const SongError('Failed to fetch songs'),
      ],
    );

    blocTest<SongBloc, SongState>(
      'filters filteredSongs correctly when SongSearchQueryChanged matches title',
      build: () => SongBloc(getSongListUseCase: mockGetSongListUseCase),
      seed: () => const SongLoaded(
        songs: mockSongs,
        filteredSongs: mockSongs,
        searchQuery: '',
      ),
      act: (bloc) => bloc.add(SongSearchQueryChanged('bohemian')),
      expect: () => [
        SongLoaded(
          songs: mockSongs,
          filteredSongs: [mockSongs[0]],
          searchQuery: 'bohemian',
        ),
      ],
    );

    blocTest<SongBloc, SongState>(
      'filters filteredSongs correctly when SongSearchQueryChanged matches subtitle',
      build: () => SongBloc(getSongListUseCase: mockGetSongListUseCase),
      seed: () => const SongLoaded(
        songs: mockSongs,
        filteredSongs: mockSongs,
        searchQuery: '',
      ),
      act: (bloc) => bloc.add(SongSearchQueryChanged('lennon')),
      expect: () => [
        SongLoaded(
          songs: mockSongs,
          filteredSongs: [mockSongs[1]],
          searchQuery: 'lennon',
        ),
      ],
    );

    blocTest<SongBloc, SongState>(
      'sets filteredSongs to full list when SongSearchQueryChanged has empty query',
      build: () => SongBloc(getSongListUseCase: mockGetSongListUseCase),
      seed: () => SongLoaded(
        songs: mockSongs,
        filteredSongs: [mockSongs[0]],
        searchQuery: 'bohemian',
      ),
      act: (bloc) => bloc.add(SongSearchQueryChanged('')),
      expect: () => [
        const SongLoaded(
          songs: mockSongs,
          filteredSongs: mockSongs,
          searchQuery: '',
        ),
      ],
    );
  });
}
