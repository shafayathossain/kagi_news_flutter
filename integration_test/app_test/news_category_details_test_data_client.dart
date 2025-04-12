import 'dart:convert';
import 'dart:io';

import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';

import 'business_news_category_details_sample.dart';
import 'tech_news_category_details_sample.dart';


class NewsCategoryDetailsTestDataClient {

  NewsCategoryDetailsTestDataClient._();

  static NewsCategoryDetailsResponse getTechNewsCategoryDetailsResponse() {
    final contents = techNewsCategoryDetailsSample;
    final jsonMap = json.decode(contents) as Map<String, dynamic>;
    return NewsCategoryDetailsResponse.fromJson(jsonMap);
  }

  static NewsCategoryDetailsResponse getBusinessNewsCategoryDetailsResponse() {
    final contents = businessNewsCategoryDetailsSample;
    final jsonMap = json.decode(contents) as Map<String, dynamic>;
    return NewsCategoryDetailsResponse.fromJson(jsonMap);
  }
}
