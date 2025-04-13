import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/local/kagi_news_local_data_source.dart';
import 'package:kagi_news/data/datasource/network/kagi_news_api_service.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../datasource/network/model/news_category_details_test_data_client.dart';
import 'kagi_news_repository_test.mocks.dart';

@GenerateMocks([KagiNewsLocalDataSource, KagiNewsApiService])
void main() {
  late KagiNewsRepository repository;
  late MockKagiNewsLocalDataSource mockLocalDataSource;
  late MockKagiNewsApiService mockApiService;

  setUp(() {
    mockLocalDataSource = MockKagiNewsLocalDataSource();
    mockApiService = MockKagiNewsApiService();
    repository = KagiNewsRepositoryImpl(
      localDataSource: mockLocalDataSource,
      apiService: mockApiService,
    );
  });

  group('sync', () {
    final categoriesResponse = KagiNewsCategoriesResponse(
      timestamp: 12345,
      categories: [
        NewsCategory(name: 'Tech', file: 'tech.json'),
        NewsCategory(name: 'Business', file: 'business.json'),
      ],
    );

    final techDetails =
        NewsCategoryDetailsTestDataClient.getTechNewsCategoryDetailsResponse();

    final businessDetails = NewsCategoryDetailsTestDataClient
        .getBusinessNewsCategoryDetailsResponse();

    test(
        'when timestamp differs, should fetch all category details and return true',
        () async {
      when(mockApiService.getCategories())
          .thenAnswer((_) async => categoriesResponse);
      when(mockLocalDataSource.getLastSavedTimestamp())
          .thenAnswer((_) async => 12340);
      when(mockLocalDataSource.saveCategories(any)).thenAnswer((_) async => {});
      when(mockLocalDataSource.saveTimestamp(any)).thenAnswer((_) async => {});

      when(mockApiService.getCategoryDetails('tech.json'))
          .thenAnswer((_) async => techDetails);
      when(mockApiService.getCategoryDetails('business.json'))
          .thenAnswer((_) async => businessDetails);
      when(mockLocalDataSource.saveCategoryDetails(any, any, any))
          .thenAnswer((_) async => {});

      final result = await repository.sync();

      expect(result.isSuccess, true);
      expect(result.data, true);
      verify(mockApiService.getCategories()).called(1);
      verify(mockLocalDataSource.saveCategories(categoriesResponse)).called(1);
      verify(mockApiService.getCategoryDetails('tech.json')).called(1);
      verify(mockApiService.getCategoryDetails('business.json')).called(1);
      verify(mockLocalDataSource.saveCategoryDetails(
              'tech.json', 'Tech', techDetails))
          .called(1);
      verify(mockLocalDataSource.saveCategoryDetails(
              'business.json', 'Business', businessDetails))
          .called(1);
      verify(mockLocalDataSource.saveTimestamp(12345)).called(1);
    });

    test(
      'when timestamp is null, should fetch all category details and return true',
      () async {
        when(mockApiService.getCategories())
            .thenAnswer((_) async => categoriesResponse);
        when(mockLocalDataSource.getLastSavedTimestamp())
            .thenAnswer((_) async => null);
        when(mockLocalDataSource.saveCategories(any))
            .thenAnswer((_) async => {});
        when(mockLocalDataSource.saveTimestamp(any))
            .thenAnswer((_) async => {});

        when(mockApiService.getCategoryDetails('tech.json'))
            .thenAnswer((_) async => techDetails);
        when(mockApiService.getCategoryDetails('business.json'))
            .thenAnswer((_) async => businessDetails);
        when(mockLocalDataSource.saveCategoryDetails(any, any, any))
            .thenAnswer((_) async => {});

        final result = await repository.sync();

        expect(result.isSuccess, true);
        expect(result.data, true);
        verify(mockApiService.getCategoryDetails('tech.json')).called(1);
        verify(mockApiService.getCategoryDetails('business.json')).called(1);
      },
    );

    test(
      'when timestamp is the same, should not fetch details and return false',
      () async {
        when(mockApiService.getCategories())
            .thenAnswer((_) async => categoriesResponse);
        when(mockLocalDataSource.getLastSavedTimestamp())
            .thenAnswer((_) async => 12345); // Same timestamp
        when(mockLocalDataSource.saveCategories(any))
            .thenAnswer((_) async => {});

        final result = await repository.sync();

        expect(result.isSuccess, true);
        expect(result.data, false);
        verify(mockApiService.getCategories()).called(1);
        verifyNever(mockApiService.getCategoryDetails(any));
        verifyNever(mockLocalDataSource.saveTimestamp(any));
      },
    );

    test('when api throws error, should return error result', () async {
      when(mockApiService.getCategories())
          .thenThrow(Exception('Network error'));

      final result = await repository.sync();

      expect(result.isSuccess, false);
      expect(result.error, contains('Exception: Network error'));
    });
  });

  group('getCategories', () {
    final cachedCategories = KagiNewsCategoriesResponse(
      timestamp: 12345,
      categories: [NewsCategory(name: 'Tech', file: 'tech.json')],
    );

    final networkCategories = KagiNewsCategoriesResponse(
      timestamp: 12346,
      categories: [NewsCategory(name: 'Tech', file: 'tech.json')],
    );

    test('with cache and no forced refresh, should return cached data',
        () async {
      when(mockLocalDataSource.getCategories())
          .thenAnswer((_) async => cachedCategories);

      final result = await repository.getCategories();

      expect(result.isSuccess, true);
      expect(result.data, cachedCategories);
      verifyNever(mockApiService.getCategories());
    });

    test('with cache and forced refresh, should fetch from network', () async {
      when(mockLocalDataSource.getCategories())
          .thenAnswer((_) async => cachedCategories);
      when(mockApiService.getCategories())
          .thenAnswer((_) async => networkCategories);
      when(mockLocalDataSource.saveCategories(any)).thenAnswer((_) async => {});

      final result = await repository.getCategories(forceRefresh: true);

      expect(result.isSuccess, true);
      expect(result.data, networkCategories);
      verify(mockApiService.getCategories()).called(1);
      verify(mockLocalDataSource.saveCategories(networkCategories)).called(1);
    });

    test('without cache, should fetch from network', () async {
      when(mockLocalDataSource.getCategories()).thenAnswer((_) async => null);
      when(mockApiService.getCategories())
          .thenAnswer((_) async => networkCategories);
      when(mockLocalDataSource.saveCategories(any)).thenAnswer((_) async => {});

      final result = await repository.getCategories();

      expect(result.isSuccess, true);
      expect(result.data, networkCategories);
      verify(mockApiService.getCategories()).called(1);
      verify(mockLocalDataSource.saveCategories(networkCategories)).called(1);
    });

    test('error handling with cache, should fall back to cache', () async {
      when(mockLocalDataSource.getCategories())
          .thenAnswer((_) async => cachedCategories);
      when(mockApiService.getCategories())
          .thenThrow(Exception('Network error'));

      final result = await repository.getCategories(forceRefresh: true);

      expect(result.isSuccess, true);
      expect(result.data, cachedCategories);
    });

    test('error handling without cache, should return error', () async {
      when(mockLocalDataSource.getCategories()).thenAnswer((_) async => null);
      when(mockApiService.getCategories())
          .thenThrow(Exception('Network error'));

      final result = await repository.getCategories();

      expect(result.isSuccess, false);
      expect(result.error, contains('Exception: Network error'));
    });
  });

  group('getCategoryDetails', () {
    final cachedDetails =
        NewsCategoryDetailsTestDataClient.getTechNewsCategoryDetailsResponse();

    final networkDetails = NewsCategoryDetailsTestDataClient
        .getBusinessNewsCategoryDetailsResponse();

    test('with cache and no forced refresh, should return cached data',
        () async {
      when(mockLocalDataSource.getCategoryDetails('tech.json'))
          .thenAnswer((_) async => cachedDetails);

      final result = await repository.getCategoryDetails('tech.json');

      expect(result.isSuccess, true);
      expect(result.data, cachedDetails);
      verifyNever(mockApiService.getCategoryDetails(any));
    });

    test('with cache and forced refresh, should fetch from network', () async {
      when(mockLocalDataSource.getCategoryDetails('tech.json'))
          .thenAnswer((_) async => cachedDetails);
      when(mockApiService.getCategoryDetails('tech.json'))
          .thenAnswer((_) async => networkDetails);
      when(mockLocalDataSource.saveCategoryDetails(any, any, any))
          .thenAnswer((_) async => {});

      final result =
          await repository.getCategoryDetails('tech.json', forceRefresh: true);

      expect(result.isSuccess, true);
      expect(result.data, networkDetails);
      verify(mockApiService.getCategoryDetails('tech.json')).called(1);
      verify(mockLocalDataSource.saveCategoryDetails(
        'tech.json',
        networkDetails.category,
        networkDetails,
      )).called(1);
    });

    test('without cache, should fetch from network', () async {
      when(mockLocalDataSource.getCategoryDetails('tech.json'))
          .thenAnswer((_) async => null);
      when(mockApiService.getCategoryDetails('tech.json'))
          .thenAnswer((_) async => networkDetails);
      when(mockLocalDataSource.saveCategoryDetails(any, any, any))
          .thenAnswer((_) async => {});

      final result = await repository.getCategoryDetails('tech.json');

      expect(result.isSuccess, true);
      expect(result.data, networkDetails);
      verify(mockApiService.getCategoryDetails('tech.json')).called(1);
    });

    test('error handling with cache, should fall back to cache', () async {
      when(mockLocalDataSource.getCategoryDetails('tech.json'))
          .thenAnswer((_) async => cachedDetails);
      when(mockApiService.getCategoryDetails('tech.json'))
          .thenThrow(Exception('Network error'));

      final result =
          await repository.getCategoryDetails('tech.json', forceRefresh: true);

      expect(result.isSuccess, true);
      expect(result.data, cachedDetails);
    });

    test('error handling without cache, should return error', () async {
      when(mockLocalDataSource.getCategoryDetails('tech.json'))
          .thenAnswer((_) async => null);
      when(mockApiService.getCategoryDetails('tech.json'))
          .thenThrow(Exception('Network error'));

      final result = await repository.getCategoryDetails('tech.json');

      expect(result.isSuccess, false);
      expect(result.error, contains('Exception: Network error'));
    });
  });

  test('clearCache should call clearAllCategoryDetails', () async {
    when(mockLocalDataSource.clearAllCategoryDetails())
        .thenAnswer((_) async => {});

    await repository.clearCache();

    verify(mockLocalDataSource.clearAllCategoryDetails()).called(1);
  });
}
