import 'package:dio/dio.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/song.dart';
import '../../domain/entities/song_detail.dart';
import '../../domain/repositories/song_repository.dart';
import '../datasources/song_remote_datasource.dart';

/// Implementation of [SongRepository] that handles remote data sources.
class SongRepositoryImpl implements SongRepository {
  final SongRemoteDataSource _dataSource;

  /// Creates a [SongRepositoryImpl] with the given remote [_dataSource].
  SongRepositoryImpl(this._dataSource);

  @override
  Future<Result<List<Song>>> getSongList() async {
    try {
      final models = await _dataSource.getAllSongs();
      final entities = models.map((m) => m.toEntity()).toList();
      return Success(entities);
    } on DioException {
      return const Failure('Network error');
    } catch (_) {
      return const Failure('Unexpected error');
    }
  }

  @override
  Future<Result<SongDetail>> getSongDetail(int id) async {
    try {
      final model = await _dataSource.getSongDetail(id);
      return Success(model.toEntity());
    } on DioException {
      return const Failure('Network error');
    } catch (_) {
      return const Failure('Unexpected error');
    }
  }
}
