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

    test('getCategoryDetails correctly deserializes news data', () async {
      final categoryDetailResponse = NewsCategoryDetailsTestDataClient
          .getTechNewsCategoryDetailsResponse();

      final category = categoryDetailResponse.category ?? 'tech';
      when(mockDao.getByFileName('$category.json')).thenAnswer(
        (_) async => CategoryDetail(
          fileName: "$category.json",
          category: category,
          timestamp: categoryDetailResponse.timestamp,
          jsonData: jsonEncode(categoryDetailResponse.toJson()),
        ),
      );

      final details = await dataSource.getCategoryDetails('$category.json');

      expect(details, isNotNull);
      expect(details?.category, categoryDetailResponse.category);
      expect(details?.timestamp, categoryDetailResponse.timestamp);
      verify(mockDao.getByFileName("$category.json")).called(1);
    });

    test('getCategoryDetails correctly deserializes onThisDay data', () async {
      final onThisDayResponse = NewsCategoryDetailsResponse(
          category: null,
          timestamp: 1644048227,
          read: null,
          clusters: null,
          onThisDayItems: [
            OnThisDayItem(
                year: '1969',
                htmlContent: 'Apollo 11 landed on the moon',
                sortYear: 1969.0,
                type: 'event')
          ]);

      when(mockDao.getByFileName('onthisday.json')).thenAnswer(
        (_) async => CategoryDetail(
          fileName: "onthisday.json",
          category: "onthisday",
          timestamp: onThisDayResponse.timestamp,
          jsonData: jsonEncode(onThisDayResponse.toJson()),
        ),
      );

      final details = await dataSource.getCategoryDetails('onthisday.json');

      expect(details, isNotNull);
      expect(details?.category, isNull);
      expect(details?.timestamp, onThisDayResponse.timestamp);
      expect(details?.onThisDayItems, isNotNull);
      expect(details?.onThisDayItems?.length, 1);
      expect(details?.onThisDayItems?[0].year, '1969');
      verify(mockDao.getByFileName("onthisday.json")).called(1);
    });

    test('saveCategoryDetails correctly calls dao for regular news', () async {
      final categoryDetailResponse = NewsCategoryDetailsTestDataClient
          .getTechNewsCategoryDetailsResponse();

      when(mockDao.insertOrUpdate(any)).thenAnswer((_) async => 1);

      final category = categoryDetailResponse.category ?? 'unknown';
      await dataSource.saveCategoryDetails(
        'tech.json',
        category,
        categoryDetailResponse,
      );

      verify(
        mockDao.insertOrUpdate(
          argThat(
            predicate<CategoryDetail>((detail) =>
                detail.fileName == 'tech.json' &&
                detail.category == category &&
                detail.timestamp == categoryDetailResponse.timestamp),
          ),
        ),
      ).called(1);
    });

    test('saveCategoryDetails correctly calls dao for onThisDay data',
        () async {
      final onThisDayResponse = NewsCategoryDetailsResponse(
          category: null,
          timestamp: 1644048227,
          read: null,
          clusters: null,
          onThisDayItems: [
            OnThisDayItem(
                year: '1969',
                htmlContent: 'Apollo 11 landed on the moon',
                sortYear: 1969.0,
                type: 'event')
          ]);

      when(mockDao.insertOrUpdate(any)).thenAnswer((_) async => 1);

      await dataSource.saveCategoryDetails(
        'onthisday.json',
        "onthisday",
        onThisDayResponse,
      );

      verify(
        mockDao.insertOrUpdate(
          argThat(
            predicate<CategoryDetail>(
              (detail) =>
                  detail.fileName == 'onthisday.json' &&
                  detail.category == "onthisday" &&
                  detail.timestamp == onThisDayResponse.timestamp,
            ),
          ),
        ),
      ).called(1);
    });

    test(
        'getAllCategoryDetails returns all category details including onThisDay',
        () async {
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
            })),
        CategoryDetail(
            fileName: 'onthisday.json',
            category: "onthisday",
            timestamp: 98765,
            jsonData: jsonEncode({
              'timestamp': 98765,
              'events': [
                {
                  'year': '1969',
                  'content': 'Apollo 11 landed on the moon',
                  'sort_year': 1969.0,
                  'type': 'event'
                }
              ]
            }))
      ];

      when(mockDao.getAll()).thenAnswer((_) async => detailsList);

      final allDetails = await dataSource.getAllCategoryDetails();

      expect(allDetails.length, 3);
      expect(allDetails[0].category, 'Tech');
      expect(allDetails[1].category, 'Business');
      expect(allDetails[2].category, null);
      expect(allDetails[2].onThisDayItems, isNotNull);
      expect(allDetails[2].onThisDayItems?.length, 1);
    });

    test('getCategoryDetailsByName handles nullable category', () async {
      final techJson = {
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
          jsonData: jsonEncode(techJson),
        ),
      );

      final techDetails = await dataSource.getCategoryDetailsByName('Tech');
      expect(techDetails, isNotNull);
      expect(techDetails?.category, 'Tech');

      when(mockDao.getByFileName('onthisday')).thenAnswer(
        (_) async => CategoryDetail(
          fileName: 'onthisday.json',
          category: "onthisday",
          timestamp: 98765,
          jsonData: jsonEncode({'timestamp': 98765, 'events': []}),
        ),
      );

      final onThisDayDetails =
          await dataSource.getCategoryDetailsByName('onthisday');
      expect(onThisDayDetails, isNotNull);
      expect(onThisDayDetails?.category, isNull);
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
