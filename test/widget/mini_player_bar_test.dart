import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:music_player/domain/entities/song.dart';
import 'package:music_player/presentation/blocs/player/player_bloc.dart';
import 'package:music_player/presentation/blocs/player/player_event.dart';
import 'package:music_player/presentation/blocs/player/player_state.dart';
import 'package:music_player/presentation/widgets/player/mini_player_bar.dart';

class MockPlayerBloc extends MockBloc<PlayerEvent, PlayerState> implements PlayerBloc {}

void main() {
  late MockPlayerBloc mockPlayerBloc;

  setUp(() {
    mockPlayerBloc = MockPlayerBloc();
  });

  const mockSong = Song(
    id: 1,
    title: 'Imagine',
    subtitle: 'John Lennon',
    arabicName: 'تخيل',
    trackCount: 1,
    category: 'Pop',
  );

  Widget buildWidgetUnderTest(MockPlayerBloc bloc) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(
            body: Column(
              children: [
                Expanded(child: SizedBox()),
                MiniPlayerBar(),
              ],
            ),
          ),
        ),
        GoRoute(
          path: '/now-playing',
          name: 'nowPlaying',
          builder: (context, state) => const Scaffold(
            body: Text('Now Playing Screen'),
          ),
        ),
      ],
    );

    return BlocProvider<PlayerBloc>.value(
      value: bloc,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }

  group('MiniPlayerBar Widget Tests', () {
    testWidgets('returns SizedBox (does not render) when PlayerInitial', (WidgetTester tester) async {
      when(() => mockPlayerBloc.state).thenReturn(const PlayerInitial());

      await tester.pumpWidget(buildWidgetUnderTest(mockPlayerBloc));

      // Container has margin and details, let's verify no text from song or player container is rendered
      expect(find.byType(GestureDetector), findsNothing);
    });

    testWidgets('shows song title and subtitle when PlayerActive', (WidgetTester tester) async {
      when(() => mockPlayerBloc.state).thenReturn(const PlayerActive(
        song: mockSong,
        position: Duration.zero,
        totalDuration: Duration(minutes: 3),
        isPlaying: false,
      ));

      await tester.pumpWidget(buildWidgetUnderTest(mockPlayerBloc));

      expect(find.text('Imagine'), findsOneWidget);
      expect(find.text('John Lennon'), findsOneWidget);
    });

    testWidgets('shows pause icon when isPlaying:true', (WidgetTester tester) async {
      when(() => mockPlayerBloc.state).thenReturn(const PlayerActive(
        song: mockSong,
        position: Duration.zero,
        totalDuration: Duration(minutes: 3),
        isPlaying: true,
      ));

      await tester.pumpWidget(buildWidgetUnderTest(mockPlayerBloc));

      expect(find.byIcon(Icons.pause), findsOneWidget);
      expect(find.byIcon(Icons.play_arrow), findsNothing);
    });

    testWidgets('shows play icon when isPlaying:false', (WidgetTester tester) async {
      when(() => mockPlayerBloc.state).thenReturn(const PlayerActive(
        song: mockSong,
        position: Duration.zero,
        totalDuration: Duration(minutes: 3),
        isPlaying: false,
      ));

      await tester.pumpWidget(buildWidgetUnderTest(mockPlayerBloc));

      expect(find.byIcon(Icons.pause), findsNothing);
      expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    });

    testWidgets('taps play/pause button and triggers appropriate Bloc event', (WidgetTester tester) async {
      // 1. Test tapping when paused (isPlaying: false) -> triggers PlayerResumeRequested
      when(() => mockPlayerBloc.state).thenReturn(const PlayerActive(
        song: mockSong,
        position: Duration.zero,
        totalDuration: Duration(minutes: 3),
        isPlaying: false,
      ));

      await tester.pumpWidget(buildWidgetUnderTest(mockPlayerBloc));
      await tester.tap(find.byIcon(Icons.play_arrow));
      await tester.pump();

      verify(() => mockPlayerBloc.add(const PlayerResumeRequested())).called(1);

      // 2. Test tapping when playing (isPlaying: true) -> triggers PlayerPauseRequested
      when(() => mockPlayerBloc.state).thenReturn(const PlayerActive(
        song: mockSong,
        position: Duration.zero,
        totalDuration: Duration(minutes: 3),
        isPlaying: true,
      ));

      await tester.pumpWidget(buildWidgetUnderTest(mockPlayerBloc));
      await tester.tap(find.byIcon(Icons.pause));
      await tester.pump();

      verify(() => mockPlayerBloc.add(const PlayerPauseRequested())).called(1);
    });
  });
}
