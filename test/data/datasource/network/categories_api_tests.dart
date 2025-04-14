import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/network/dio_client.dart';
import 'package:kagi_news/data/datasource/network/kagi_news_api_service.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/i18n/strings.g.dart';
import 'package:mockito/mockito.dart';

import 'kagi_news_api_service_test.mocks.dart';

void categoriesTests() {
  group('getCategories', () {
    late MockDio mockDio;
    late DioClient dioClient;
    late KagiNewsApiService apiService;
    const endpoint = '/kite.json';
    final mockCategoriesResponse = {
      'timestamp': 1234567890,
      'categories': [
        {'name': 'Technology', 'file': 'tech.json'},
        {'name': 'Politics', 'file': 'politics.json'},
      ],
    };

    setUp(() {
      mockDio = MockDio();
      when(mockDio.interceptors).thenReturn(MockInterceptors());
      dioClient = DioClient(dio: mockDio);
      apiService = KagiNewsApiService(dioClient: dioClient);
    });

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
      },
    );

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
        throwsA(
          isA<Exception>().having(
                (e) => e.toString(),
            'message',
            contains(t.errors.timeout),
          ),
        ),
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
        throwsA(
          isA<Exception>().having(
                (e) => e.toString(),
            'message',
            contains(t.errors.noInternet),
          ),
        ),
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
        throwsA(
          isA<Exception>().having(
                (e) => e.toString(),
            'message',
            contains(t.errors.badRequest),
          ),
        ),
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
        throwsA(
          isA<Exception>().having(
                (e) => e.toString(),
            'message',
            contains(t.errors.serverError),
          ),
        ),
      );
    });
  });
}