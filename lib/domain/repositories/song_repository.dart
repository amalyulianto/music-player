import '../../core/utils/result.dart';
import '../entities/song.dart';
import '../entities/song_detail.dart';

/// Abstract repository defining the contract for retrieving songs and details.
abstract class SongRepository {
  /// Fetches the list of all available songs.
  Future<Result<List<Song>>> getSongList();

  /// Fetches details for a specific song by its [id].
  Future<Result<SongDetail>> getSongDetail(int id);
}
