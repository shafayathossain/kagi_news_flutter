import 'dart:convert';

import 'package:kagi_news/data/datasource/local/app_database.dart';
import 'package:kagi_news/data/datasource/local/category_details_dao.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KagiNewsLocalDataSource {
  static const String _timestampKey = 'kagi_news_timestamp';
  static const String _categoriesKey = 'kagi_news_categories';

  final CategoryDetailsDao _categoryDetailsDao;

  KagiNewsLocalDataSource({required CategoryDetailsDao categoryDetailsDao})
    : _categoryDetailsDao = categoryDetailsDao;

  factory KagiNewsLocalDataSource.withDefaultDb() {
    final database = AppDatabase();

    return KagiNewsLocalDataSource(
      categoryDetailsDao: database.categoryDetailsDao,
    );
  }

  Future<int?> getLastSavedTimestamp() {
    return SharedPreferences.getInstance().then(
      (prefs) => prefs.getInt(_timestampKey),
    );
  }

  Future<void> saveTimestamp(int timestamp) {
    return SharedPreferences.getInstance().then((prefs) async {
      await prefs.setInt(_timestampKey, timestamp);
    });
  }

  Future<KagiNewsCategoriesResponse?> getCategories() {
    return SharedPreferences.getInstance().then((prefs) async {
      final jsonString = prefs.getString(_categoriesKey);
      if (jsonString == null) return null;

      return KagiNewsCategoriesResponse.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    });
  }

  Future<void> saveCategories(KagiNewsCategoriesResponse categories) {
    return SharedPreferences.getInstance().then((prefs) async {
      await prefs.setString(_categoriesKey, jsonEncode(categories.toJson()));
    });
  }

  Future<NewsCategoryDetailsResponse?> getCategoryDetails(String fileName) {
    return _categoryDetailsDao.getByFileName(fileName).then((categoryDetail) {
      if (categoryDetail == null) return null;

      return NewsCategoryDetailsResponse.fromJson(
        jsonDecode(categoryDetail.jsonData) as Map<String, dynamic>,
      );
    });
  }

  Future<void> saveCategoryDetails(
    String fileName,
    String category,
    NewsCategoryDetailsResponse details,
  ) {
    return _categoryDetailsDao.insertOrUpdate(
      CategoryDetail(
        fileName: fileName,
        category: category,
        timestamp: details.timestamp,
        jsonData: jsonEncode(details.toJson()),
      ),
    );
  }

  Future<List<NewsCategoryDetailsResponse>> getAllCategoryDetails() {
    return _categoryDetailsDao.getAll().then((categoryDetails) {
      return categoryDetails.map((categoryDetail) {
        return NewsCategoryDetailsResponse.fromJson(
          jsonDecode(categoryDetail.jsonData) as Map<String, dynamic>,
        );
      }).toList();
    });
  }

  Future<NewsCategoryDetailsResponse?> getCategoryDetailsByName(
    String categoryName,
  ) {
    return _categoryDetailsDao.getByFileName(categoryName).then((
      categoryDetail,
    ) {
      if (categoryDetail == null) return null;

      return NewsCategoryDetailsResponse.fromJson(
        jsonDecode(categoryDetail.jsonData) as Map<String, dynamic>,
      );
    });
  }

  Future<void> clearAllCategoryDetails() {
    return _categoryDetailsDao.deleteAll();
  }
}
