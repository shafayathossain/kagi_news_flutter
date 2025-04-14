import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/data/datasource/repository/result.dart';

abstract class KagiNewsRepository {
  /// Syncs data from API with local storage
  /// Returns true if data was updated, false if no update needed
  Future<Result<bool>> sync();

  Future<Result<KagiNewsCategoriesResponse>> getCategories({
    bool forceRefresh = false,
  });

  Future<Result<NewsCategoryDetailsResponse>> getCategoryDetails(
    String fileName, {
    bool forceRefresh = false,
  });

  Future<void> clearCache();
}
