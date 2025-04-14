import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/network/dio_client.dart';
import 'package:kagi_news/data/datasource/network/kagi_news_api_service.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/i18n/strings.g.dart';
import 'package:mockito/mockito.dart';

import 'kagi_news_api_service_test.mocks.dart';

void categoryDetailsTests() {
  group('getCategoryDetails', () {
    const String fileName = 'tech.json';
    final mockDetailsResponse = _loadMockNewsCategoryDetailsResponse();
    late MockDio mockDio;
    late DioClient dioClient;
    late KagiNewsApiService apiService;

    setUp(() {
      mockDio = MockDio();
      when(mockDio.interceptors).thenReturn(MockInterceptors());
      dioClient = DioClient(dio: mockDio);
      apiService = KagiNewsApiService(dioClient: dioClient);
    });

    test(
      'returns category details when HTTP call successfully completes',
          () async {
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
      },
    );

    test('handles empty clusters response', () async {
      final emptyResponse = {
        'timestamp': 1234567890,
        'read': 1,
        'category': 'Technology',
        'clusters': [],
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
      when(
        mockDio.get<Map<String, dynamic>>('/$fileName'),
      ).thenThrow(Exception(t.errors.notFound));

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
      when(
        mockDio.get<Map<String, dynamic>>('/$fileName'),
      ).thenThrow(Exception(t.errors.unauthorized));

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
      when(
        mockDio.get<Map<String, dynamic>>('/$fileName'),
      ).thenThrow(Exception(t.errors.forbidden));

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
      when(
        mockDio.get<Map<String, dynamic>>('/$fileName'),
      ).thenThrow(Exception(t.errors.unknownError));

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
  final file = File(
    'test/data/test_data/tech_news_category_details_sample.json',
  );
  final jsonString = file.readAsStringSync();

  return jsonDecode(jsonString) as Map<String, dynamic>;
}