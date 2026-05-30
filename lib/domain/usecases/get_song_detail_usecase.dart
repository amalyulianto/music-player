import '../../core/utils/result.dart';
import '../entities/song_detail.dart';
import '../repositories/song_repository.dart';

/// Usecase to retrieve detailed information and tracks of a specific song.
class GetSongDetailUseCase {
  final SongRepository _repository;

  /// Creates a [GetSongDetailUseCase] with the required [_repository].
  GetSongDetailUseCase(this._repository);

  /// Executes the usecase to get song details by its [id].
  Future<Result<SongDetail>> call(int id) => _repository.getSongDetail(id);
}
