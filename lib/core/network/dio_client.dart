import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// A wrapper around [Dio] for handling HTTP network requests.
class DioClient {
  /// The underlying [Dio] client instance.
  late final Dio dio;

  /// Creates the [DioClient] with predefined base options and logging interceptor.
  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://api.alquran.cloud/v1',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestHeader: true,
        requestBody: true,
        responseHeader: false,
        responseBody: true,
        error: true,
      ));
    }
  }
}
