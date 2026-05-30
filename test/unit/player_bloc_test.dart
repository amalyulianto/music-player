import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/core/audio/audio_service.dart';
import 'package:music_player/core/utils/result.dart';
import 'package:music_player/domain/entities/audio_track.dart';
import 'package:music_player/domain/entities/song.dart';
import 'package:music_player/domain/entities/song_detail.dart';
import 'package:music_player/domain/usecases/get_song_detail_usecase.dart';
import 'package:music_player/presentation/blocs/player/player_bloc.dart';
import 'package:music_player/presentation/blocs/player/player_event.dart';
import 'package:music_player/presentation/blocs/player/player_state.dart';

class MockGetSongDetailUseCase extends Mock implements GetSongDetailUseCase {}
class MockAudioService extends Mock implements AudioService {}

void main() {
  late MockGetSongDetailUseCase mockGetSongDetailUseCase;
  late MockAudioService mockAudioService;

  setUpAll(() {
    registerFallbackValue(const SongDetail(
      id: 0,
      title: '',
      subtitle: '',
      audioTracks: [],
    ));
  });

  setUp(() {
    mockGetSongDetailUseCase = MockGetSongDetailUseCase();
    mockAudioService = MockAudioService();

    when(() => mockAudioService.positionStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.durationStream)
        .thenAnswer((_) => const Stream.empty());
    when(() => mockAudioService.isPlayingStream)
        .thenAnswer((_) => const Stream.empty());
  });

  const mockAudioTracks = [
    AudioTrack(
      id: 1,
      audioUrl: 'http://example.com/track1.mp3',
      arabicText: 'نص عربي 1',
      trackIndex: 1,
    ),
  ];

  const mockSongDetail = SongDetail(
    id: 1,
    title: 'Bohemian Rhapsody',
    subtitle: 'Queen',
    audioTracks: mockAudioTracks,
  );

  const mockSong = Song(
    id: 1,
    title: 'Bohemian Rhapsody',
    subtitle: 'Queen',
    arabicName: '',
    trackCount: 1,
    category: '',
  );

  group('PlayerBloc', () {
    blocTest<PlayerBloc, PlayerState>(
      'emits [PlayerLoading, PlayerActive] on PlayerSongRequested success',
      build: () {
        when(() => mockGetSongDetailUseCase(any()))
            .thenAnswer((_) async => const Success(mockSongDetail));
        when(() => mockAudioService.playSong(any()))
            .thenAnswer((_) async {});
        when(() => mockAudioService.currentDuration)
            .thenReturn(const Duration(minutes: 3));
        when(() => mockAudioService.currentPosition)
            .thenReturn(Duration.zero);
        when(() => mockAudioService.isPlaying)
            .thenReturn(true);

        return PlayerBloc(
          getSongDetailUseCase: mockGetSongDetailUseCase,
          audioService: mockAudioService,
        );
      },
      act: (bloc) => bloc.add(const PlayerSongRequested(1)),
      expect: () => [
        const PlayerLoading(),
        const PlayerActive(
          song: mockSong,
          position: Duration.zero,
          totalDuration: Duration(minutes: 3),
          isPlaying: true,
        ),
      ],
      verify: (_) {
        verify(() => mockGetSongDetailUseCase(1)).called(1);
        verify(() => mockAudioService.playSong(mockSongDetail)).called(1);
      },
    );

    blocTest<PlayerBloc, PlayerState>(
      'emits [PlayerLoading, PlayerError] on PlayerSongRequested failure',
      build: () {
        when(() => mockGetSongDetailUseCase(any()))
            .thenAnswer((_) async => const Failure('Failed to fetch song detail'));

        return PlayerBloc(
          getSongDetailUseCase: mockGetSongDetailUseCase,
          audioService: mockAudioService,
        );
      },
      act: (bloc) => bloc.add(const PlayerSongRequested(1)),
      expect: () => [
        const PlayerLoading(),
        const PlayerError('Failed to fetch song detail'),
      ],
      verify: (_) {
        verify(() => mockGetSongDetailUseCase(1)).called(1);
        verifyNever(() => mockAudioService.playSong(any()));
      },
    );

    blocTest<PlayerBloc, PlayerState>(
      'emits PlayerActive with isPlaying:false on PlayerPauseRequested',
      build: () {
        when(() => mockAudioService.pause()).thenAnswer((_) async {});
        return PlayerBloc(
          getSongDetailUseCase: mockGetSongDetailUseCase,
          audioService: mockAudioService,
        );
      },
      seed: () => const PlayerActive(
        song: mockSong,
        position: Duration.zero,
        totalDuration: Duration(minutes: 3),
        isPlaying: true,
      ),
      act: (bloc) => bloc.add(const PlayerPauseRequested()),
      expect: () => [
        const PlayerActive(
          song: mockSong,
          position: Duration.zero,
          totalDuration: Duration(minutes: 3),
          isPlaying: false,
        ),
      ],
      verify: (_) {
        verify(() => mockAudioService.pause()).called(1);
      },
    );

    blocTest<PlayerBloc, PlayerState>(
      'emits PlayerActive with isPlaying:true on PlayerResumeRequested',
      build: () {
        when(() => mockAudioService.resume()).thenAnswer((_) async {});
        return PlayerBloc(
          getSongDetailUseCase: mockGetSongDetailUseCase,
          audioService: mockAudioService,
        );
      },
      seed: () => const PlayerActive(
        song: mockSong,
        position: Duration.zero,
        totalDuration: Duration(minutes: 3),
        isPlaying: false,
      ),
      act: (bloc) => bloc.add(const PlayerResumeRequested()),
      expect: () => [
        const PlayerActive(
          song: mockSong,
          position: Duration.zero,
          totalDuration: Duration(minutes: 3),
          isPlaying: true,
        ),
      ],
      verify: (_) {
        verify(() => mockAudioService.resume()).called(1);
      },
    );
  });
}
