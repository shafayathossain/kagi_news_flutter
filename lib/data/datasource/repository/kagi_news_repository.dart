import 'package:kagi_news/data/datasource/local/kagi_news_local_data_source.dart';
import 'package:kagi_news/data/datasource/network/kagi_news_api_service.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/data/datasource/repository/result.dart';

class KagiNewsRepository {
  final KagiNewsLocalDataSource _localDataSource;
  final KagiNewsApiService _apiService;

  KagiNewsRepository({
    required KagiNewsLocalDataSource localDataSource,
    required KagiNewsApiService apiService,
  })  : _localDataSource = localDataSource,
        _apiService = apiService;

  /// Syncs data from API with local storage
  /// Returns true if data was updated, false if no update needed
  Future<Result<bool>> sync() async {
    try {
      final categoriesResponse = await _apiService.getCategories();
      final lastSavedTimestamp = await _localDataSource.getLastSavedTimestamp();

      await _localDataSource.saveCategories(categoriesResponse);

      if (lastSavedTimestamp == null ||
          lastSavedTimestamp != categoriesResponse.timestamp) {
        final futures = categoriesResponse.categories.map(
          (category) {
            return _apiService.getCategoryDetails(category.file).then(
              (categoryDetails) async {
                await _localDataSource.saveCategoryDetails(
                  category.file,
                  category.name,
                  categoryDetails,
                );
              },
            );
          },
        ).toList();

        await Future.wait(futures);
        await _localDataSource.saveTimestamp(categoriesResponse.timestamp);

        return Result.success(true);
      }

      return Result.success(false);
    } catch (e) {
      print('Error syncing data: $e');
      return Result.error(e.toString());
    }
  }

  Future<Result<KagiNewsCategoriesResponse>> getCategories({
    bool forceRefresh = false,
  }) async {
    try {
      final cachedCategories = await _localDataSource.getCategories();
      if (cachedCategories == null || forceRefresh) {
        final networkCategories = await _apiService.getCategories();
        await _localDataSource.saveCategories(networkCategories);
        return Result.success(networkCategories);
      } else {
        return Result.success(cachedCategories);
      }
    } catch (e) {
      final cachedCategories = await _localDataSource.getCategories();
      if (cachedCategories != null) {
        return Result.success(cachedCategories);
      }
      return Result.error(e.toString());
    }
  }

  Future<Result<NewsCategoryDetailsResponse>> getCategoryDetails(
    String fileName, {
    bool forceRefresh = false,
  }) async {
    try {
      final cachedDetails = await _localDataSource.getCategoryDetails(fileName);
      if (cachedDetails == null || forceRefresh) {
        final networkDetails = await _apiService.getCategoryDetails(fileName);
        await _localDataSource.saveCategoryDetails(
          fileName,
          networkDetails.category ?? fileName.replaceAll('.json', ''),
          networkDetails,
        );
        return Result.success(networkDetails);
      } else {
        return Result.success(cachedDetails);
      }
    } catch (e) {
      final cachedDetails = await _localDataSource.getCategoryDetails(fileName);
      if (cachedDetails != null) {
        return Result.success(cachedDetails);
      }
      return Result.error(e.toString());
    }
  }

  Future<void> clearCache() async {
    await _localDataSource.clearAllCategoryDetails();
  }
}
