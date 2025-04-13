import 'package:flutter/foundation.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository.dart';
import 'package:kagi_news/data/datasource/repository/result.dart';
import 'package:kagi_news/data/datasource/repository/kagi_news_repository_impl.dart';

class KagiNewsController {
  late final KagiNewsRepository _repository;

  final ValueNotifier<Result<KagiNewsCategoriesResponse>?> categoriesNotifier =
      ValueNotifier(null);

  final Map<String, ValueNotifier<Result<NewsCategoryDetailsResponse>?>>
      categoryDetailsNotifiers = {};

  KagiNewsController({required KagiNewsRepository repository}) {
    _repository = repository;
    _repository.sync();
    fetchCategories();
  }

  Future<Result<bool>> syncData() async {
    try {
      final result = await _repository.sync();
      return result;
    } catch (e) {
      return Result.error(e.toString());
    }
  }

  Future<void> fetchCategories({bool forceRefresh = false}) async {
    categoriesNotifier.value = null;
    try {
      final result =
          await _repository.getCategories(forceRefresh: forceRefresh);
      if (result.isSuccess) {
        for (var category in result.data!.categories) {
          if (!categoryDetailsNotifiers.containsKey(category.file)) {
            categoryDetailsNotifiers[category.file] = ValueNotifier(null);
          }
        }
      }
      categoriesNotifier.value = result;
    } catch (e) {
      categoriesNotifier.value = Result.error(e.toString());
    }
  }

  Future<void> fetchCategoryDetails(String fileName,
      {bool forceRefresh = false}) async {
    categoryDetailsNotifiers[fileName] ??= ValueNotifier(null);

    categoryDetailsNotifiers[fileName]?.value = null;

    try {
      final result = await _repository.getCategoryDetails(
        fileName,
        forceRefresh: forceRefresh,
      );
      categoryDetailsNotifiers[fileName]?.value = result;
    } catch (e) {
      categoryDetailsNotifiers[fileName]?.value = Result.error(e.toString());
    }
  }

  Future<void> refreshAllData() async {
    await fetchCategories(forceRefresh: true);

    final categoriesResult = categoriesNotifier.value;
    if (categoriesResult != null && categoriesResult.isSuccess) {
      final categories = categoriesResult.data!.categories;

      await Future.wait(categories.map((category) =>
          fetchCategoryDetails(category.file, forceRefresh: true)));
    }
  }

  Future<void> clearCache() async {
    await _repository.clearCache();
  }
}
