import 'dart:convert';
import 'dart:io';

import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';


class NewsCategoryDetailsTestDataClient {
  static const String techNewsCategoryDetailsFilePath =
      'test/data/test_data/tech_news_category_details_sample.json';
  static const String businessNewsCategoryDetailsFilePath =
      'test/data/test_data/business_news_category_details_sample.json';

  NewsCategoryDetailsTestDataClient._();

  static NewsCategoryDetailsResponse getTechNewsCategoryDetailsResponse() {

    final file = File(techNewsCategoryDetailsFilePath);
    final contents = file.readAsStringSync();
    final jsonMap = json.decode(contents) as Map<String, dynamic>;

    return NewsCategoryDetailsResponse.fromJson(jsonMap);
  }

  static NewsCategoryDetailsResponse getBusinessNewsCategoryDetailsResponse() {
    final file = File(businessNewsCategoryDetailsFilePath);
    final contents = file.readAsStringSync();
    final jsonMap = json.decode(contents) as Map<String, dynamic>;

    return NewsCategoryDetailsResponse.fromJson(jsonMap);
  }
}
