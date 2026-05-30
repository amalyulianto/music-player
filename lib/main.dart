import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/blocs/favorites/favorites_bloc.dart';
import 'presentation/blocs/player/player_bloc.dart';
import 'presentation/blocs/player/player_state.dart';
import 'presentation/blocs/recently_played/recently_played_bloc.dart';
import 'presentation/blocs/recently_played/recently_played_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PlayerBloc>(create: (_) => sl<PlayerBloc>()),
        BlocProvider<FavoritesBloc>(create: (_) => sl<FavoritesBloc>()),
        BlocProvider<RecentlyPlayedBloc>(
          create: (_) => sl<RecentlyPlayedBloc>(),
        ),
      ],
      child: BlocListener<PlayerBloc, PlayerState>(
        listenWhen: (previous, current) =>
            previous is! PlayerActive && current is PlayerActive,
        listener: (context, state) {
          if (state is PlayerActive) {
            context.read<RecentlyPlayedBloc>().add(
              RecentlyPlayedSongAdded(state.song),
            );
          }
        },
        child: MaterialApp.router(
          title: 'Music Player',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}
