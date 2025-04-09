import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:kagi_news/data/datasource/network/dio_client.dart';
import 'package:kagi_news/data/datasource/network/kagi_news_api_service.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/i18n/strings.g.dart';

import 'kagi_news_api_service_test.mocks.dart';

@GenerateMocks([Dio, Interceptors])
void main() {
  late MockDio mockDio;
  late DioClient dioClient;
  late KagiNewsApiService apiService;

  setUp(() {
    mockDio = MockDio();
    when(mockDio.interceptors).thenReturn(MockInterceptors());
    dioClient = DioClient(dio: mockDio);
    apiService = KagiNewsApiService(dioClient: dioClient);
  });

  group('getCategories', () {
    const endpoint = '/kite.json';
    final mockCategoriesResponse = {
      'timestamp': 1234567890,
      'categories': [
        {'name': 'Technology', 'file': 'tech.json'},
        {'name': 'Politics', 'file': 'politics.json'},
      ]
    };

    test(
        'returns news categories when HTTP call successfully completes',
            () async {
          when(mockDio.get<Map<String, dynamic>>(endpoint)).thenAnswer(
                (_) async => Response(
              requestOptions: RequestOptions(path: endpoint),
              data: mockCategoriesResponse,
              statusCode: 200,
            ),
          );

          final result = await apiService.getCategories();

          expect(result, isA<KagiNewsCategoriesResponse>());
          expect(result.categories.length, equals(2));
          verify(mockDio.get<Map<String, dynamic>>(endpoint)).called(1);
        });

    test('handles empty categories list', () async {
      final emptyResponse = {'timestamp': 1234567890, 'categories': []};

      when(mockDio.get<Map<String, dynamic>>(endpoint)).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(path: endpoint),
          data: emptyResponse,
          statusCode: 200,
        ),
      );

      final result = await apiService.getCategories();

      expect(result, isA<KagiNewsCategoriesResponse>());
      expect(result.categories, isEmpty);
    });

    test('throws timeout exception', () async {
      when(mockDio.get<Map<String, dynamic>>(endpoint)).thenThrow(
        DioException(
          type: DioExceptionType.connectionTimeout,
          error: t.errors.timeout,
          requestOptions: RequestOptions(path: endpoint),
        ),
      );

      expect(
            () => apiService.getCategories(),
        throwsA(isA<Exception>().having(
              (e) => e.toString(),
          'message',
          contains(t.errors.timeout),
        )),
      );
    });

    test('throws no internet exception', () async {
      when(mockDio.get<Map<String, dynamic>>(endpoint)).thenThrow(
        DioException(
          type: DioExceptionType.connectionError,
          error: t.errors.noInternet,
          requestOptions: RequestOptions(path: endpoint),
        ),
      );

      expect(
            () => apiService.getCategories(),
        throwsA(isA<Exception>().having(
              (e) => e.toString(),
          'message',
          contains(t.errors.noInternet),
        )),
      );
    });

    test('throws bad request exception (400)', () async {
      when(mockDio.get<Map<String, dynamic>>(endpoint)).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          error: t.errors.badRequest,
          response: Response(
            statusCode: 400,
            requestOptions: RequestOptions(path: endpoint),
          ),
          requestOptions: RequestOptions(path: endpoint),
        ),
      );

      expect(
            () => apiService.getCategories(),
        throwsA(isA<Exception>().having(
              (e) => e.toString(),
          'message',
          contains(t.errors.badRequest),
        )),
      );
    });

    test('throws server error exception (5xx)', () async {
      when(mockDio.get<Map<String, dynamic>>(endpoint)).thenThrow(
        DioException(
          type: DioExceptionType.badResponse,
          error: t.errors.serverError,
          response: Response(
            statusCode: 500,
            requestOptions: RequestOptions(path: endpoint),
          ),
          requestOptions: RequestOptions(path: endpoint),
        ),
      );

      expect(
            () => apiService.getCategories(),
        throwsA(isA<Exception>().having(
              (e) => e.toString(),
          'message',
          contains(t.errors.serverError),
        )),
      );
    });
  });

  group('getCategoryDetails', () {
    const String fileName = 'tech.json';
    final mockDetailsResponse = _loadMockNewsCategoryDetailsResponse();

    test('returns category details when HTTP call successfully completes', () async {
      when(mockDio.get<Map<String, dynamic>>('/$fileName')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(path: '/$fileName'),
          data: mockDetailsResponse,
          statusCode: 200,
        ),
      );

      final result = await apiService.getCategoryDetails(fileName);

      expect(result, isA<NewsCategoryDetailsResponse>());
      verify(mockDio.get<Map<String, dynamic>>('/$fileName')).called(1);
    });

    test('handles empty clusters response', () async {
      final emptyResponse = {
        'timestamp': 1234567890,
        'read': 1,
        'category': 'Technology',
        'clusters': []
      };

      when(mockDio.get<Map<String, dynamic>>('/$fileName')).thenAnswer(
            (_) async => Response(
          requestOptions: RequestOptions(path: '/$fileName'),
          data: emptyResponse,
          statusCode: 200,
        ),
      );

      final result = await apiService.getCategoryDetails(fileName);

      expect(result, isA<NewsCategoryDetailsResponse>());
      expect(result.clusters, isEmpty);
    });

    test('throws not found exception (404)', () async {
      when(mockDio.get<Map<String, dynamic>>('/$fileName'))
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
      when(mockDio.get<Map<String, dynamic>>('/$fileName'))
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
      when(mockDio.get<Map<String, dynamic>>('/$fileName'))
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
      when(mockDio.get<Map<String, dynamic>>('/$fileName'))
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
  final file = File('test/data/test_data/tech_news_category_details_sample.json');
  final jsonString = file.readAsStringSync();
  return jsonDecode(jsonString) as Map<String, dynamic>;
}
