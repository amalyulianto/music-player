import '../../core/network/dio_client.dart';
import '../models/song_detail_model.dart';
import '../models/song_model.dart';
import 'song_remote_datasource.dart';

/// Implementation of [SongRemoteDataSource] that communicates with the API.
class SongRemoteDataSourceImpl implements SongRemoteDataSource {
  final DioClient _client;

  /// Creates a [SongRemoteDataSourceImpl] with the given [DioClient].
  SongRemoteDataSourceImpl(this._client);

  @override
  Future<List<SongModel>> getAllSongs() async {
    final response = await _client.dio.get('/surah');
    final List<dynamic> data = response.data['data'] as List<dynamic>;
    return data.map((json) => SongModel.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<SongDetailModel> getSongDetail(int id) async {
    final response = await _client.dio.get('/surah/$id/ar.alafasy');
    final Map<String, dynamic> data = response.data['data'] as Map<String, dynamic>;
    return SongDetailModel.fromJson(data);
  }
}
