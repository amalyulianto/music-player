import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../audio/audio_service.dart';
import '../network/dio_client.dart';
import '../../data/datasources/song_remote_datasource.dart';
import '../../data/datasources/song_remote_datasource_impl.dart';
import '../../data/repositories/song_repository_impl.dart';
import '../../domain/repositories/song_repository.dart';
import '../../domain/usecases/get_song_detail_usecase.dart';
import '../../domain/usecases/get_song_list_usecase.dart';
import '../../presentation/blocs/favorites/favorites_bloc.dart';
import '../../presentation/blocs/player/player_bloc.dart';
import '../../presentation/blocs/recently_played/recently_played_bloc.dart';
import '../../presentation/blocs/song/song_bloc.dart';

/// The global [GetIt] instance for dependency injection.
final sl = GetIt.instance;

/// Sets up all service locator dependency registrations.
Future<void> setupServiceLocator() async {
  // External
  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // Core
  sl.registerLazySingleton(() => DioClient());
  sl.registerLazySingleton(() => AudioService());

  // Data
  sl.registerLazySingleton<SongRemoteDataSource>(
    () => SongRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<SongRepository>(
    () => SongRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetSongListUseCase(sl()));
  sl.registerLazySingleton(() => GetSongDetailUseCase(sl()));

  // BLoCs (Factories for fresh instances per Provider)
  sl.registerFactory(() => SongBloc(getSongListUseCase: sl()));
  sl.registerFactory(() => PlayerBloc(getSongDetailUseCase: sl(), audioService: sl()));
  sl.registerFactory(() => FavoritesBloc(prefs: sl()));
  sl.registerFactory(() => RecentlyPlayedBloc(prefs: sl()));
}
