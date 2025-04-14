import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/network/model/news_category_details_response.dart';
import 'news_category_details_test_data_client.dart';

void main() {
  group('NewsCategoryDetailsResponse toJson tests', () {
    _testNewsCategoryDetailsResponse();
    _testNewsCluster();
    _testSmallerModels();
    _testOnThisDayItem();
    _testRoundTrip();
  });
}

void _testNewsCategoryDetailsResponse() {
    test('NewsCategoryDetailsResponse.toJson correctly converts to map', () {
      final response = NewsCategoryDetailsResponse(
        category: 'tech',
        timestamp: 1644048227,
        read: 5,
        clusters: [
          NewsCluster(
            articles: [],
            businessAnglePoints: ['Point 1', 'Point 2'],
            businessAngleText: 'Business angle',
            category: 'tech',
            clusterNumber: 1,
            culinarySignificance: '',
            designPrinciples: '',
            destinationHighlights: '',
            didYouKnow: 'Test fact',
            diyTips: '',
            domains: [],
            economicImplications: '',
            emoji: '🔧',
            futureOutlook: '',
            gameplayMechanics: [],
            geopoliticalContext: '',
            historicalBackground: '',
            humanitarianImpact: '',
            industryImpact: [],
            internationalReactions: [],
            keyPlayers: ['Player 1'],
            leagueStandings: '',
            location: 'Global',
            numberOfTitles: 5,
            performanceStatistics: [],
            perspectives: [],
            quote: '',
            quoteAuthor: '',
            quoteSourceDomain: '',
            quoteSourceUrl: '',
            scientificSignificance: [],
            shortSummary: 'Summary',
            talkingPoints: ['Point 1'],
            technicalDetails: ['Detail 1'],
            technicalSpecifications: '',
            timeline: ['2023: Event'],
            title: 'Test Cluster',
            travelAdvisory: [],
            uniqueDomains: 3,
            userActionItems: [],
            userExperienceImpact: [],
          ),
        ],
        onThisDayItems: null,
      );

      final json = response.toJson();

      expect(json['category'], 'tech');
      expect(json['timestamp'], 1644048227);
      expect(json['read'], 5);
      expect(json['clusters'], isA<List>());
      expect((json['clusters'] as List).length, 1);
    });

    test('NewsCategoryDetailsResponse.toJson with onThisDayItems', () {
      final response = NewsCategoryDetailsResponse(
        category: null,
        timestamp: 1644048227,
        read: null,
        clusters: null,
        onThisDayItems: [
          OnThisDayItem(
            year: '1969',
            htmlContent: 'Apollo 11 landed on the moon',
            sortYear: 1969.0,
            type: 'event',
          ),
        ],
      );

      final json = response.toJson();

      expect(json['category'], isNull);
      expect(json['timestamp'], 1644048227);
      expect(json['read'], isNull);
      expect(json['clusters'], isNull);
      expect(json['events'], isA<List>());
      expect((json['events'] as List).length, 1);
    });
}

void _testNewsCluster() {
    test('NewsCluster.toJson correctly converts to map', () {
      final cluster = NewsCluster(
        articles: [],
        businessAnglePoints: ['Point 1', 'Point 2'],
        businessAngleText: 'Business angle',
        category: 'tech',
        clusterNumber: 1,
        culinarySignificance: '',
        designPrinciples: '',
        destinationHighlights: '',
        didYouKnow: 'Test fact',
        diyTips: '',
        domains: [],
        economicImplications: '',
        emoji: '🔧',
        futureOutlook: '',
        gameplayMechanics: [],
        geopoliticalContext: '',
        historicalBackground: '',
        humanitarianImpact: '',
        industryImpact: [],
        internationalReactions: [],
        keyPlayers: ['Player 1'],
        leagueStandings: '',
        location: 'Global',
        numberOfTitles: 5,
        performanceStatistics: [],
        perspectives: [],
        quote: '',
        quoteAuthor: '',
        quoteSourceDomain: '',
        quoteSourceUrl: '',
        scientificSignificance: [],
        shortSummary: 'Summary',
        talkingPoints: ['Point 1'],
        technicalDetails: ['Detail 1'],
        technicalSpecifications: '',
        timeline: ['2023: Event'],
        title: 'Test Cluster',
        travelAdvisory: [],
        uniqueDomains: 3,
        userActionItems: [],
        userExperienceImpact: [],
      );

      final json = cluster.toJson();

      expect(json['business_angle_points'], ['Point 1', 'Point 2']);
      expect(json['business_angle_text'], 'Business angle');
      expect(json['category'], 'tech');
      expect(json['cluster_number'], 1);
      expect(json['emoji'], '🔧');
      expect(json['key_players'], ['Player 1']);
      expect(json['location'], 'Global');
      expect(json['number_of_titles'], 5);
      expect(json['short_summary'], 'Summary');
      expect(json['talking_points'], ['Point 1']);
      expect(json['technical_details'], ['Detail 1']);
      expect(json['timeline'], ['2023: Event']);
      expect(json['title'], 'Test Cluster');
      expect(json['unique_domains'], 3);
    });
}

void _testSmallerModels() {
    test('Perspective.toJson correctly converts to map', () {
      final perspective = Perspective(
        text: 'Test perspective',
        sources: [
          Source(name: 'Source 1', url: 'https://example.com'),
        ],
      );

      final json = perspective.toJson();

      expect(json['text'], 'Test perspective');
      expect(json['sources'], isA<List>());
      expect((json['sources'] as List).length, 1);
      expect((json['sources'] as List)[0]['name'], 'Source 1');
      expect((json['sources'] as List)[0]['url'], 'https://example.com');
    });

    test('Source.toJson correctly converts to map', () {
      final source = Source(name: 'Test Source', url: 'https://test.com');

      final json = source.toJson();

      expect(json['name'], 'Test Source');
      expect(json['url'], 'https://test.com');
    });

    test('Article.toJson correctly converts to map', () {
      final article = Article(
        title: 'Test Article',
        link: 'https://example.com/article',
        domain: 'example.com',
        date: '07 Apr 2025, 09.09 AM', // Using the expected format
        image: 'https://example.com/image.jpg',
        imageCaption: 'Image Caption',
      );

      final json = article.toJson();

      expect(json['title'], 'Test Article');
      expect(json['link'], 'https://example.com/article');
      expect(json['domain'], 'example.com');
      expect(json['date'], matches(r'(2024|2025|2026)-(\d{2})-(\d{2})T\d{2}:\d{2}:\d{2}(Z|[+-]\d{2}:\d{2})?'));
      expect(json['image'], 'https://example.com/image.jpg');
      expect(json['image_caption'], 'Image Caption');
    });

    test('NewsDomain.toJson correctly converts to map', () {
      final domain = NewsDomain(
        name: 'example.com',
        favicon: 'https://example.com/favicon.ico',
      );

      final json = domain.toJson();

      expect(json['name'], 'example.com');
      expect(json['favicon'], 'https://example.com/favicon.ico');
    });
}

void _testOnThisDayItem() {
    test('OnThisDayItem.toJson correctly converts to map', () {
      final item = OnThisDayItem(
          year: '1969',
          htmlContent: 'Apollo 11 landed on the moon',
          sortYear: 1969.0,
      type: 'event',
    );

      final json = item.toJson();

      expect(json['year'], '1969');
      expect(json['content'], 'Apollo 11 landed on the moon');
      expect(json['sort_year'], 1969.0);
      expect(json['type'], 'event');
    });
}

void _testRoundTrip() {
    test('Round-trip test: fromJson → toJson maintains data integrity', () {
    final response = NewsCategoryDetailsTestDataClient.getTechNewsCategoryDetailsResponse();
      final json = response.toJson();

      expect(json['category'], response.category);
      expect(json['timestamp'], response.timestamp);
      expect(json['read'], response.read);

      if (response.clusters != null && response.clusters!.isNotEmpty) {
        expect(json['clusters']?.length, response.clusters?.length);

        final firstCluster = response.clusters![0];
        final firstClusterJson = json['clusters'][0];

      expect(firstClusterJson['cluster_number'], firstCluster.clusterNumber);
        expect(firstClusterJson['title'], firstCluster.title);
        expect(firstClusterJson['emoji'], firstCluster.emoji);
        expect(firstClusterJson['short_summary'], firstCluster.shortSummary);

      expect(firstClusterJson['articles'].length, firstCluster.articles.length);
        if (firstCluster.articles.isNotEmpty) {
          final firstArticle = firstCluster.articles[0];
          final firstArticleJson = firstClusterJson['articles'][0];

          expect(firstArticleJson['title'], firstArticle.title);
          expect(firstArticleJson['domain'], firstArticle.domain);
          expect(firstArticleJson['link'], firstArticle.link);
        }
      }

    if (response.onThisDayItems != null && response.onThisDayItems!.isNotEmpty) {
        expect(json['events']?.length, response.onThisDayItems?.length);

        final firstItem = response.onThisDayItems![0];
        final firstItemJson = json['events'][0];

        expect(firstItemJson['year'], firstItem.year);
        expect(firstItemJson['content'], firstItem.htmlContent);
        expect(firstItemJson['sort_year'], firstItem.sortYear);
        expect(firstItemJson['type'], firstItem.type);
      }
    });
}
