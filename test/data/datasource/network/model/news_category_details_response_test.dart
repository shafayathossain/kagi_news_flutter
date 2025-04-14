import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'news_category_details_response_test_suite.dart';
import 'news_category_details_test_data_client.dart';

void main() {
  group('NewsCategoryDetailsResponse', () {
    runNewsTestSuite(
      'Tech news sample tests (type check)',
      NewsCategoryDetailsTestDataClient.getTechNewsCategoryDetailsResponse(),
    );

    runNewsTestSuite(
      'Business news sample tests (type check)',
      NewsCategoryDetailsTestDataClient
          .getBusinessNewsCategoryDetailsResponse(),
    );

    test('OnThisDay response parsing', () {
      final json = {
        'timestamp': 1644048227,
        'events': [
          {
            'year': '1969',
            'content': 'Apollo 11 landed on the moon',
            'sort_year': 1969.0,
            'type': 'event',
          },
        ],
      };

      final response = NewsCategoryDetailsResponse.fromJson(json);

      expect(response.category, isNull);
      expect(response.read, isNull);
      expect(response.clusters, isNull);
      expect(response.onThisDayItems, isNotNull);
      expect(response.onThisDayItems!.length, 1);
      expect(response.onThisDayItems!.first.year, '1969');
      expect(
        response.onThisDayItems!.first.htmlContent,
        'Apollo 11 landed on the moon',
      );
    });
  });
}
