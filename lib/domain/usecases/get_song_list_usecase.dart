import '../../core/utils/result.dart';
import '../entities/song.dart';
import '../repositories/song_repository.dart';

/// Usecase to retrieve the list of all available songs.
class GetSongListUseCase {
  final SongRepository _repository;

  /// Creates a [GetSongListUseCase] with the required [_repository].
  GetSongListUseCase(this._repository);

  /// Executes the usecase to get all songs.
  Future<Result<List<Song>>> call() => _repository.getSongList();
}
