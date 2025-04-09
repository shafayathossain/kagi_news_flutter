// news_data_client.dart
import 'dart:convert';
import 'dart:io';

import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';


class NewsCategoryDetailsTestDataClient {
  final String filePath;

  NewsCategoryDetailsTestDataClient({this.filePath = 'test/data/test_data/tech_news_category_details_sample.json'});

  NewsCategoryDetailsResponse getNewsCategoryDetailsResponse() {
    final file = File(filePath);
    final contents = file.readAsStringSync();
    final jsonMap = json.decode(contents) as Map<String, dynamic>;
    return NewsCategoryDetailsResponse.fromJson(jsonMap);
  }
}
