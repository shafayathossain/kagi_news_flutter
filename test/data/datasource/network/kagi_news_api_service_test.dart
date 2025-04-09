// dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:kagi_news/data/datasource/network/dio_client.dart';
import 'package:kagi_news/data/datasource/network/kagi_news_api_service.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/i18n/strings.g.dart';

import 'kagi_news_api_service_test.mocks.dart';

@GenerateMocks([DioClient])
void main() {
  late MockDioClient mockDioClient;
  late KagiNewsApiService apiService;

  setUp(() {
    mockDioClient = MockDioClient();
    apiService = KagiNewsApiService(dioClient: mockDioClient);
  });

  group('getCategories', () {
    final mockCategoriesResponse = {
      'timestamp': 1234567890,
      'categories': [
        {'name': 'Technology', 'file': 'tech.json'},
        {'name': 'Politics', 'file': 'politics.json'},
      ]
    };

    test('returns news categories when http call successfully completes',
        () async {
      when(mockDioClient.get<Map<String, dynamic>>('/kite.json')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: mockCategoriesResponse,
          statusCode: 200,
        ),
      );

      // Act
      final result = await apiService.getCategories();

      // Assert
      expect(result, isA<KagiNewsCategoriesResponse>());
      expect(result.categories.length, equals(2));

      verify(mockDioClient.get<Map<String, dynamic>>('/kite.json')).called(1);
    });

    test('handles empty categories list', () async {
      final emptyResponse = {'timestamp': 1234567890, 'categories': []};

      when(mockDioClient.get<Map<String, dynamic>>('/kite.json')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: emptyResponse,
          statusCode: 200,
        ),
      );

      // Act
      final result = await apiService.getCategories();

      // Assert
      expect(result, isA<KagiNewsCategoriesResponse>());
      expect(result.categories, isEmpty);
    });

    test('throws timeout exception', () async {
      when(mockDioClient.get<Map<String, dynamic>>('/kite.json'))
          .thenThrow(DioException(
        type: DioExceptionType.connectionTimeout,
        error: t.errors.timeout,
        requestOptions: RequestOptions(path: '/kite.json'),
      ));

      expect(
        () => apiService.getCategories(),
        throwsA(isA<DioException>().having(
          (e) => e.type,
          'type',
          equals(DioExceptionType.connectionTimeout),
        )),
      );
    });

    test('throws no internet exception', () async {
      when(mockDioClient.get<Map<String, dynamic>>('/kite.json'))
          .thenThrow(DioException(
        type: DioExceptionType.connectionError,
        error: t.errors.noInternet,
        requestOptions: RequestOptions(path: '/kite.json'),
      ));

      expect(
        () => apiService.getCategories(),
        throwsA(isA<DioException>().having(
          (e) => e.type,
          'type',
          equals(DioExceptionType.connectionError),
        )),
      );
    });

    test('throws bad request exception (400)', () async {
      when(mockDioClient.get<Map<String, dynamic>>('/kite.json')).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          error: t.errors.badRequest,
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: '/kite.json'),
          ),
          requestOptions: RequestOptions(path: '/kite.json'),
        ),
      );

      expect(
        () => apiService.getCategories(),
        throwsA(isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          equals(400),
        )),
      );
    });

    test('throws server error exception (5xx)', () async {
      when(mockDioClient.get<Map<String, dynamic>>('/kite.json')).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          error: t.errors.serverError,
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: '/kite.json'),
          ),
          requestOptions: RequestOptions(path: '/kite.json'),
        ),
      );

      expect(
        () => apiService.getCategories(),
        throwsA(isA<DioException>().having(
          (e) => e.response?.statusCode,
          'statusCode',
          equals(500),
        )),
      );
    });
  });

  group('getCategoryDetails', () {
    final String fileName = 'tech.json';
    final mockDetailsResponse = _loadMockNewsCategoryDetailsResponse();

    test('returns category details when http call successfully completes',
        () async {
      when(mockDioClient.get<Map<String, dynamic>>('/$fileName')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: mockDetailsResponse,
          statusCode: 200,
        ),
      );

      final result = await apiService.getCategoryDetails(fileName);

      expect(result, isA<NewsCategoryDetailsResponse>());
      verify(mockDioClient.get<Map<String, dynamic>>('/$fileName')).called(1);
    });

    test('handles empty clusters response', () async {
      final emptyResponse = {
        'timestamp': 1234567890,
        'read': 1,
        "category": "Technology",
        'clusters': []
      };

      when(mockDioClient.get<Map<String, dynamic>>('/$fileName')).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ''),
          data: emptyResponse,
          statusCode: 200,
        ),
      );

      // Act
      final result = await apiService.getCategoryDetails(fileName);

      // Assert
      expect(result, isA<NewsCategoryDetailsResponse>());
      expect(result.clusters, isEmpty);
    });

    test('throws not found exception (404)', () async {
      when(mockDioClient.get<Map<String, dynamic>>('/$fileName'))
          .thenThrow(Exception(t.errors.notFound));

      expect(
        () => apiService.getCategoryDetails(fileName),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(t.errors.notFound),
          ),
        ),
      );
    });

    test('throws unauthorized exception (401)', () async {
      when(mockDioClient.get<Map<String, dynamic>>('/$fileName'))
          .thenThrow(Exception(t.errors.unauthorized));

      expect(
        () => apiService.getCategoryDetails(fileName),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(t.errors.unauthorized),
          ),
        ),
      );
    });

    test('throws forbidden exception (403)', () async {
      when(mockDioClient.get<Map<String, dynamic>>('/$fileName'))
          .thenThrow(Exception(t.errors.forbidden));

      expect(
        () => apiService.getCategoryDetails(fileName),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(t.errors.forbidden),
          ),
        ),
      );
    });

    test('throws unknown error', () async {
      when(mockDioClient.get<Map<String, dynamic>>('/$fileName'))
          .thenThrow(Exception(t.errors.unknownError));

      expect(
        () => apiService.getCategoryDetails(fileName),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains(t.errors.unknownError),
          ),
        ),
      );
    });
  });
}

Map<String, dynamic> _loadMockNewsCategoryDetailsResponse() {
  final file =
      File('test/data/test_data/tech_news_category_details_sample.json');
  final jsonString = file.readAsStringSync();
  return jsonDecode(jsonString) as Map<String, dynamic>;
}
