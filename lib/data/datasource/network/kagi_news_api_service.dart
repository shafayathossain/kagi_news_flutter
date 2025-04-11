import 'package:kagi_news/data/datasource/network/dio_client.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'package:kagi_news/i18n/strings.g.dart';

class KagiNewsApiService {
  final DioClient _dioClient;

  KagiNewsApiService({DioClient? dioClient})
      : _dioClient = dioClient ?? DioClient();

  Future<KagiNewsCategoriesResponse> getCategories() async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('/kite.json');
      return KagiNewsCategoriesResponse.fromJson(response.data!);
    } catch (e) {
      throw _mapError(e, t.errors.failedToLoadCategories);
    }
  }

  Future<NewsCategoryDetailsResponse> getCategoryDetails(
    String fileName,
  ) async {
    try {
      final response = await _dioClient.get<Map<String, dynamic>>('/$fileName');
      return NewsCategoryDetailsResponse.fromJson(response.data!);
    } catch (e) {
      throw _mapError(e, t.errors.failedToLoadCategoryDetails);
    }
  }

  Exception _mapError(dynamic error, String defaultMessage) {
    if (error is Exception) {
      return error;
    }
    return Exception(defaultMessage);
  }
}
