import 'dart:convert';

import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';

import 'business_news_category_details_sample.dart';
import 'tech_news_category_details_sample.dart';

class NewsCategoryDetailsTestDataClient {
  NewsCategoryDetailsTestDataClient._();

  static NewsCategoryDetailsResponse getTechNewsCategoryDetailsResponse() {
    const contents = techNewsCategoryDetailsSample;
    final jsonMap = json.decode(contents) as Map<String, dynamic>;

    return NewsCategoryDetailsResponse.fromJson(jsonMap);
  }

  static NewsCategoryDetailsResponse getBusinessNewsCategoryDetailsResponse() {
    const contents = businessNewsCategoryDetailsSample;
    final jsonMap = json.decode(contents) as Map<String, dynamic>;

    return NewsCategoryDetailsResponse.fromJson(jsonMap);
  }
}
