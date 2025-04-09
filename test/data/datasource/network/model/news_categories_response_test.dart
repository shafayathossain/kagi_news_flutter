import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'news_category_details_test_data_client.dart';

void main() {
  group('NewsCategoryDetailsResponse', () {
    // Run tests for the tech news sample.
    runNewsTestSuite(
      'Tech news sample tests (type check)',
      'test/data/test_data/tech_news_category_details_sample.json',
    );

    // Run tests for the business news sample.
    runNewsTestSuite(
      'Business news sample tests (type check)',
      'test/data/test_data/business_news_category_details_sample.json',
    );
  });
}

void runNewsTestSuite(String description, String filePath) {
  group(description, () {
    final response = NewsCategoryDetailsTestDataClient(filePath: filePath)
        .getNewsCategoryDetailsResponse();

    test('Top-level fields type check', () {
      expect(
        response.category,
        isA<String>(),
        reason: "Expected 'category' to be a String",
      );
      expect(
        response.timestamp,
        isA<int>(),
        reason: "Expected 'timestamp' to be an int",
      );
      expect(
        response.read,
        isA<int>(),
        reason: "Expected 'read' to be an int",
      );
      expect(
        response.clusters,
        isA<List<NewsCluster>>(),
        reason: "Expected 'clusters' to be a List<NewsCluster>",
      );
    });

    test('Clusters timeline type check', () {
      for (final cluster in response.clusters) {
        _verifyTimeline(cluster);
      }
    });

    test(
        'Nested objects type check (perspectives, sources, articles, news domains)',
        () {
      for (final cluster in response.clusters) {
        _verifyPerspectives(cluster);
        _verifyArticles(cluster);
        _verifyNewsDomains(cluster);
      }
    });
  });
}

void _verifyTimeline(NewsCluster cluster) {
  expect(
    cluster.timeline,
    isA<List<String>>(),
    reason:
        "Expected 'timeline' for cluster ${cluster.clusterNumber} to be a List<String> even if the JSON field is an empty string",
  );
}

void _verifyPerspectives(NewsCluster cluster) {
  for (final perspective in cluster.perspectives) {
    expect(
      perspective.text,
      isA<String>(),
      reason:
          "Expected perspective text in cluster ${cluster.clusterNumber} to be a String",
    );

    for (final source in perspective.sources) {
      expect(
        source.name,
        isA<String>(),
        reason:
            "Expected source name in cluster ${cluster.clusterNumber} to be a String",
      );
      expect(
        source.url,
        isA<String>(),
        reason:
            "Expected source URL in cluster ${cluster.clusterNumber} to be a String",
      );
    }
  }
}

void _verifyArticles(NewsCluster cluster) {
  for (final article in cluster.articles) {
    expect(
      article.title,
      isA<String>(),
      reason:
          "Expected article title in cluster ${cluster.clusterNumber} to be a String",
    );
    expect(
      article.link,
      isA<String>(),
      reason:
          "Expected article link in cluster ${cluster.clusterNumber} to be a String",
    );
    expect(
      article.domain,
      isA<String>(),
      reason:
          "Expected article domain in cluster ${cluster.clusterNumber} to be a String",
    );
    expect(
      article.date,
      isA<String>(),
      reason:
          "Expected article date in cluster ${cluster.clusterNumber} to be a String",
    );
    expect(
      article.image,
      isA<String>(),
      reason:
          "Expected article image in cluster ${cluster.clusterNumber} to be a String",
    );
    expect(
      article.imageCaption,
      isA<String>(),
      reason:
          "Expected article image caption in cluster ${cluster.clusterNumber} to be a String",
    );
  }
}

void _verifyNewsDomains(NewsCluster cluster) {
  for (final newsDomain in cluster.domains) {
    expect(
      newsDomain.name,
      isA<String>(),
      reason:
          "Expected news domain name in cluster ${cluster.clusterNumber} to be a String",
    );
    expect(
      newsDomain.favicon,
      isA<String>(),
      reason:
          "Expected news domain favicon in cluster ${cluster.clusterNumber} to be a String",
    );
  }
}
