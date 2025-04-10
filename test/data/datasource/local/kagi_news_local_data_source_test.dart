import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/local/app_database.dart';
import 'package:kagi_news/data/datasource/local/category_details_dao.dart';
import 'package:kagi_news/data/datasource/local/kagi_news_local_data_source.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../network/model/news_category_details_test_data_client.dart';
import 'kagi_news_local_data_source_test.mocks.dart';

@GenerateMocks([CategoryDetailsDao, NewsCategoryDetailsResponse])
void main() {
  late KagiNewsLocalDataSource dataSource;
  late MockCategoryDetailsDao mockDao;

  setUp(() {
    mockDao = MockCategoryDetailsDao();
    dataSource = KagiNewsLocalDataSource(categoryDetailsDao: mockDao);

    SharedPreferences.setMockInitialValues({});
  });

  group('SharedPreferences operations', () {
    test('getLastSavedTimestamp returns null when no timestamp is saved',
        () async {
      final timestamp = await dataSource.getLastSavedTimestamp();
      expect(timestamp, isNull);
    });

    test('saveTimestamp and getLastSavedTimestamp work correctly', () async {
      await dataSource.saveTimestamp(12345);
      final timestamp = await dataSource.getLastSavedTimestamp();
      expect(timestamp, 12345);
    });

    test('getCategories returns null when no categories are saved', () async {
      final categories = await dataSource.getCategories();
      expect(categories, isNull);
    });

    test('saveCategories and getCategories work correctly', () async {
      final categoriesResponse = KagiNewsCategoriesResponse(
          timestamp: 12345,
          categories: [NewsCategory(name: 'Tech', file: 'tech.json')]);

      await dataSource.saveCategories(categoriesResponse);
      final retrievedCategories = await dataSource.getCategories();

      expect(retrievedCategories?.timestamp, 12345);
      expect(retrievedCategories?.categories.length, 1);
      expect(retrievedCategories?.categories[0].name, 'Tech');
      expect(retrievedCategories?.categories[0].file, 'tech.json');
    });
  });

  group('CategoryDetailsDao operations', () {
    test('getCategoryDetails returns null when no category details are found',
        () async {
      when(mockDao.getByFileName(any)).thenAnswer((_) async => null);

      final details = await dataSource.getCategoryDetails('tech.json');
      expect(details, isNull);
      verify(mockDao.getByFileName('tech.json')).called(1);
    });

    test('getCategoryDetails correctly deserializes data', () async {
      final categoryDetailResponse =
          NewsCategoryDetailsTestDataClient().getNewsCategoryDetailsResponse();

      when(mockDao.getByFileName('${categoryDetailResponse.category}.json'))
          .thenAnswer(
        (_) async => CategoryDetail(
          fileName: "${categoryDetailResponse.category}.json",
          category: categoryDetailResponse.category,
          timestamp: categoryDetailResponse.timestamp,
          jsonData: jsonEncode(categoryDetailResponse.toJson()),
        ),
      );

      final details = await dataSource
          .getCategoryDetails('${categoryDetailResponse.category}.json');

      expect(details, isNotNull);
      expect(details?.category, categoryDetailResponse.category);
      expect(details?.timestamp, categoryDetailResponse.timestamp);
      verify(mockDao.getByFileName("${categoryDetailResponse.category}.json"))
          .called(1);
    });

    test('saveCategoryDetails correctly calls dao', () async {
      final categoryDetailResponse =
          NewsCategoryDetailsTestDataClient().getNewsCategoryDetailsResponse();

      when(mockDao.insertOrUpdate(any)).thenAnswer((_) async => 1);

      await dataSource.saveCategoryDetails(
        'tech.json',
        categoryDetailResponse.category,
        categoryDetailResponse,
      );

      verify(
        mockDao.insertOrUpdate(
          argThat(
            predicate<CategoryDetail>((detail) =>
                detail.fileName == 'tech.json' &&
                detail.category == categoryDetailResponse.category &&
                detail.timestamp == categoryDetailResponse.timestamp),
          ),
        ),
      ).called(1);
    });

    test('getAllCategoryDetails returns all category details', () async {
      final detailsList = [
        CategoryDetail(
            fileName: 'tech.json',
            category: 'Tech',
            timestamp: 12345,
            jsonData: jsonEncode({
              'category': 'Tech',
              'timestamp': 12345,
              'read': 0,
              'clusters': []
            })),
        CategoryDetail(
            fileName: 'business.json',
            category: 'Business',
            timestamp: 54321,
            jsonData: jsonEncode({
              'category': 'Business',
              'timestamp': 54321,
              'read': 0,
              'clusters': []
            }))
      ];

      when(mockDao.getAll()).thenAnswer((_) async => detailsList);

      final allDetails = await dataSource.getAllCategoryDetails();

      expect(allDetails.length, 2);
      expect(allDetails[0].category, 'Tech');
      expect(allDetails[1].category, 'Business');
    });

    test('getCategoryDetailsByName works correctly', () async {
      final detailsJson = {
        'category': 'Tech',
        'timestamp': 12345,
        'read': 0,
        'clusters': []
      };

      when(mockDao.getByFileName('Tech')).thenAnswer(
        (_) async => CategoryDetail(
          fileName: 'tech.json',
          category: 'Tech',
          timestamp: 12345,
          jsonData: jsonEncode(detailsJson),
        ),
      );

      final details = await dataSource.getCategoryDetailsByName('Tech');

      expect(details, isNotNull);
      expect(details?.category, 'Tech');
      verify(mockDao.getByFileName('Tech')).called(1);
    });

    test('clearAllCategoryDetails calls deleteAll on dao', () async {
      when(mockDao.deleteAll()).thenAnswer((_) async {});

      await dataSource.clearAllCategoryDetails();

      verify(mockDao.deleteAll()).called(1);
      final categories = await dataSource.getCategories();
      expect(categories, isNull);
    });
  });
}
