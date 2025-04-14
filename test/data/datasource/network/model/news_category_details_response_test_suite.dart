import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';

void runNewsTestSuite(
  String description,
  NewsCategoryDetailsResponse response,
) {
  group(description, () {
    _testTopLevelFields(response);
    _testClusterTimeline(response);
    _testNestedObjects(response);
    _testOnThisDayItems(response);
  });
}

void _testTopLevelFields(NewsCategoryDetailsResponse response) {
  test('Top-level fields type check', () {
    if (response.category != null) {
      expect(
        response.category,
        isA<String>(),
        reason: "Expected 'category' to be a String or null",
      );
    }

    expect(
      response.timestamp,
      isA<int>(),
      reason: "Expected 'timestamp' to be an int",
    );

    if (response.read != null) {
      expect(
        response.read,
        isA<int>(),
        reason: "Expected 'read' to be an int or null",
      );
    }

    if (response.clusters != null) {
      expect(
        response.clusters,
        isA<List<NewsCluster>>(),
        reason: "Expected 'clusters' to be a List<NewsCluster> or null",
      );
    }

    if (response.onThisDayItems != null) {
      expect(
        response.onThisDayItems,
        isA<List<OnThisDayItem>>(),
        reason: "Expected 'onThisDayItems' to be a List<OnThisDayItem> or null",
      );
    }
  });
}

void _testClusterTimeline(NewsCategoryDetailsResponse response) {
  test('Clusters timeline type check', () {
    for (final cluster in (response.clusters ?? List<NewsCluster>.empty())) {
      verifyTimeline(cluster);
    }
  });
}

void _testNestedObjects(NewsCategoryDetailsResponse response) {
  test(
    'Nested objects type check (perspectives, sources, articles, news domains)',
    () {
      for (final cluster in (response.clusters ?? List<NewsCluster>.empty())) {
        verifyTimeline(cluster);
        verifyPerspectives(cluster);
        verifyArticles(cluster);
        verifyNewsDomains(cluster);
      }
    },
  );
}

void _testOnThisDayItems(NewsCategoryDetailsResponse response) {
  if (response.onThisDayItems?.isEmpty ?? true) {
    return;
  }

  test('OnThisDayItems type check', () {
    for (final item in response.onThisDayItems!) {
      expect(item.year, isA<String>());
      expect(item.htmlContent, isA<String>());
      expect(item.sortYear, isA<double>());
      expect(item.type, isA<String>());
    }
  });
}

void verifyTimeline(NewsCluster cluster) {
  expect(
    cluster.timeline,
    isA<List<String>>(),
    reason:
        "Expected 'timeline' for cluster ${cluster.clusterNumber} to be a "
        "List<String> even if the JSON field is an empty string",
  );
}

void verifyPerspectives(NewsCluster cluster) {
  for (final perspective in cluster.perspectives) {
    expect(
      perspective.text,
      isA<String>(),
      reason:
          "Expected perspective text in cluster ${cluster.clusterNumber} to be "
          "a String",
    );
    expect(
      perspective.text,
      isNotEmpty,
      reason:
          "Expected perspective text in cluster ${cluster.clusterNumber} to "
          "not be empty",
    );
    for (final source in perspective.sources) {
      expect(
        source.name,
        isA<String>(),
        reason:
            "Expected source name in cluster ${cluster.clusterNumber} to be "
            "a String",
      );
      expect(
        source.url,
        isA<String>(),
        reason:
            "Expected source URL in cluster ${cluster.clusterNumber} to be"
            " a String",
      );
    }
  }
}

void verifyArticles(NewsCluster cluster) {
  for (final article in cluster.articles) {
    expect(
      article.title,
      isA<String>(),
      reason:
          "Expected article title in cluster ${cluster.clusterNumber} to be "
          "a String",
    );
    expect(
      article.link,
      isA<String>(),
      reason:
          "Expected article link in cluster ${cluster.clusterNumber} to be "
          "a String",
    );
    expect(
      article.domain,
      isA<String>(),
      reason:
          "Expected article domain in cluster ${cluster.clusterNumber} to be "
          "a String",
    );
    expect(
      article.date,
      isA<String>(),
      reason:
          "Expected article date in cluster ${cluster.clusterNumber} to be "
          "a String",
    );
    expect(
      article.image,
      isA<String>(),
      reason:
          "Expected article image in cluster ${cluster.clusterNumber} to be "
          "a String",
    );
    expect(
      article.imageCaption,
      isA<String>(),
      reason:
          "Expected article image caption in cluster ${cluster.clusterNumber} "
          "to be a String",
    );
  }
}

void verifyNewsDomains(NewsCluster cluster) {
  for (final newsDomain in cluster.domains) {
    expect(
      newsDomain.name,
      isA<String>(),
      reason:
          "Expected news domain name in cluster ${cluster.clusterNumber} to be "
          "a String",
    );
    expect(
      newsDomain.favicon,
      isA<String>(),
      reason:
          "Expected news domain favicon in cluster ${cluster.clusterNumber} to "
          "be a String",
    );
  }
}
