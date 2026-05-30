import '../models/song_detail_model.dart';
import '../models/song_model.dart';

/// Abstract definition for fetching song remote data sources.
abstract class SongRemoteDataSource {
  /// Fetches the complete list of all songs available remotely.
  Future<List<SongModel>> getAllSongs();

  /// Fetches the detailed information and tracks of a song by its [id].
  Future<SongDetailModel> getSongDetail(int id);
}
