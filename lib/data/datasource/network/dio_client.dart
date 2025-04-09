import 'package:dio/dio.dart';
import 'package:kagi_news/i18n/strings.g.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class DioClient {
  static const String baseUrl = 'https://kite.kagi.com';

  late final Dio _dio;

  DioClient({Dio? dio}) {
    _dio = dio ?? Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
      ),
    );
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: true,
        compact: false,
      ),
    );
  }

  Future<Response<T>> get<T>(String path) async {
    try {
      return await _dio.get<T>(path);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception(t.errors.timeout);
      case DioExceptionType.connectionError:
        return Exception(t.errors.noInternet);
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        switch (statusCode) {
          case 400:
            return Exception(t.errors.badRequest);
          case 401:
            return Exception(t.errors.unauthorized);
          case 403:
            return Exception(t.errors.forbidden);
          case 404:
            return Exception(t.errors.notFound);
          case 500:
          case 501:
          case 502:
          case 503:
            return Exception(t.errors.serverError);
          default:
            return Exception(t.errors.unknownError);
        }
      default:
        return Exception(t.errors.unknownError);
    }
  }
}
