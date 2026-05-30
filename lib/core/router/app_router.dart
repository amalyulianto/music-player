import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/browse/browse_screen.dart';
import '../../presentation/screens/now_playing/now_playing_screen.dart';

/// The routing configuration for the Music Player application.
///
/// Sets up the GoRouter instance with named routes and screen builders.
class AppRouter {
  /// The global router instance.
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (BuildContext context, GoRouterState state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/browse',
        name: 'browse',
        builder: (BuildContext context, GoRouterState state) => const BrowseScreen(),
      ),
      GoRoute(
        path: '/now-playing',
        name: 'nowPlaying',
        builder: (BuildContext context, GoRouterState state) => const NowPlayingScreen(),
      ),
    ],
  );
}
