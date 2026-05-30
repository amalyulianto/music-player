import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:music_player/presentation/widgets/common/song_list_item.dart';

void main() {
  group('SongListItem Widget Tests', () {
    testWidgets('renders title and subtitle text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              title: 'Bohemian Rhapsody',
              subtitle: 'Queen',
              isFavorite: false,
              onPlayTap: () {},
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Bohemian Rhapsody'), findsOneWidget);
      expect(find.text('Queen'), findsOneWidget);
    });

    testWidgets('shows Icons.favorite when isFavorite:true', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              title: 'Bohemian Rhapsody',
              subtitle: 'Queen',
              isFavorite: true,
              onPlayTap: () {},
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.byIcon(Icons.favorite_border), findsNothing);
    });

    testWidgets('shows Icons.favorite_border when isFavorite:false', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              title: 'Bohemian Rhapsody',
              subtitle: 'Queen',
              isFavorite: false,
              onPlayTap: () {},
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.favorite), findsNothing);
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);
    });

    testWidgets('calls onFavoriteTap when heart tapped', (WidgetTester tester) async {
      var favoriteTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              title: 'Bohemian Rhapsody',
              subtitle: 'Queen',
              isFavorite: false,
              onPlayTap: () {},
              onFavoriteTap: () {
                favoriteTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.favorite_border));
      await tester.pump();

      expect(favoriteTapped, isTrue);
    });

    testWidgets('calls onPlayTap when play button tapped', (WidgetTester tester) async {
      var playTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SongListItem(
              title: 'Bohemian Rhapsody',
              subtitle: 'Queen',
              isFavorite: false,
              onPlayTap: () {
                playTapped = true;
              },
              onFavoriteTap: () {},
            ),
          ),
        ),
      );

      // Tap the song list item row (which triggers onPlayTap)
      await tester.tap(find.text('Bohemian Rhapsody'));
      await tester.pump();

      expect(playTapped, isTrue);
    });
  });
}
