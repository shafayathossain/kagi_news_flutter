import 'package:intl/intl.dart';

class NewsCategoryDetailsResponse {
  final String? category;
  final int timestamp;
  final int? read;
  final List<NewsCluster>? clusters;
  final List<OnThisDayItem>? onThisDayItems;

  NewsCategoryDetailsResponse({
    required this.category,
    required this.timestamp,
    required this.read,
    required this.clusters,
    required this.onThisDayItems,
  });

  factory NewsCategoryDetailsResponse.fromJson(Map<String, dynamic> json) {
    try {
      if (json['clusters'] != null) {
        return NewsCategoryDetailsResponse(
          category: json['category'] as String,
          timestamp: json['timestamp'] as int,
          read: json['read'] as int,
          clusters: (json['clusters'] as List)
              .map((item) => NewsCluster.fromJson(item))
              .toList(),
          onThisDayItems: null,
        );
      } else if (json['events'] != null) {
        return NewsCategoryDetailsResponse(
          category: null,
          timestamp: json['timestamp'] as int,
          read: null,
          clusters: null,
          onThisDayItems: (json['events'] as List)
              .map((item) => OnThisDayItem.fromJson(item))
              .toList()
              ..sort((a, b) => b.sortYear.compareTo(a.sortYear)),
        );
      } else {
        return NewsCategoryDetailsResponse(
          category: null,
          timestamp: 0,
          read: null,
          clusters: null,
          onThisDayItems: null,
        );
      }
    } catch (e) {
      print("Error parsing NewsCategoryDetailsResponse: $e  --> $json");
      throw Exception("Failed to parse NewsCategoryDetailsResponse");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'timestamp': timestamp,
      'read': read,
      'clusters': clusters?.map((item) => item.toJson()).toList(),
      'events': onThisDayItems?.map((item) => item.toJson()).toList(),
    };
  }
}

class NewsCluster {
  final int clusterNumber;
  final int uniqueDomains;
  final int numberOfTitles;
  final String category;
  final String title;
  final String shortSummary;
  final String didYouKnow;
  final List<String> talkingPoints;
  final String quote;
  final String quoteAuthor;
  final String quoteSourceUrl;
  final String quoteSourceDomain;
  final String location;
  final List<Perspective> perspectives;
  final String emoji;
  final String geopoliticalContext;
  final String historicalBackground;
  final List<String> internationalReactions;
  final String humanitarianImpact;
  final String economicImplications;
  final List<String> timeline;
  final String futureOutlook;
  final List<String> keyPlayers;
  final List<String> technicalDetails;
  final String businessAngleText;
  final List<String> businessAnglePoints;
  final List<String> userActionItems;
  final List<String> scientificSignificance;
  final List<String> travelAdvisory;
  final String destinationHighlights;
  final String culinarySignificance;
  final List<String> performanceStatistics;
  final String leagueStandings;
  final String diyTips;
  final String designPrinciples;
  final List<String> userExperienceImpact;
  final List<String> gameplayMechanics;
  final List<String> industryImpact;
  final String technicalSpecifications;
  final List<Article> articles;
  final List<NewsDomain> domains;

  NewsCluster({
    required this.articles,
    required this.businessAnglePoints,
    required this.businessAngleText,
    required this.category,
    required this.clusterNumber,
    required this.culinarySignificance,
    required this.designPrinciples,
    required this.destinationHighlights,
    required this.didYouKnow,
    required this.diyTips,
    required this.domains,
    required this.economicImplications,
    required this.emoji,
    required this.futureOutlook,
    required this.gameplayMechanics,
    required this.geopoliticalContext,
    required this.historicalBackground,
    required this.humanitarianImpact,
    required this.industryImpact,
    required this.internationalReactions,
    required this.keyPlayers,
    required this.leagueStandings,
    required this.location,
    required this.numberOfTitles,
    required this.performanceStatistics,
    required this.perspectives,
    required this.quote,
    required this.quoteAuthor,
    required this.quoteSourceDomain,
    required this.quoteSourceUrl,
    required this.scientificSignificance,
    required this.shortSummary,
    required this.talkingPoints,
    required this.technicalDetails,
    required this.technicalSpecifications,
    required this.timeline,
    required this.title,
    required this.travelAdvisory,
    required this.uniqueDomains,
    required this.userActionItems,
    required this.userExperienceImpact,
  });

  // Helper function that converts a JSON field into a List<String>.
  // If the field is a string (possibly empty), it returns an empty list if the string is empty,
  // or a singleton list if there is a non-empty value.
  static List<String> _parseStringList(dynamic value) {
    if (value is String) {
      return value.isEmpty ? [] : [value];
    } else if (value is List) {
      return List<String>.from(value);
    }
    return [];
  }

  factory NewsCluster.fromJson(Map<String, dynamic> json) {
    try {
      return NewsCluster(
        articles: (json['articles'] as List)
            .map((item) => Article.fromJson(item))
            .toList(),
        businessAnglePoints: _parseStringList(json['business_angle_points']),
        businessAngleText: json['business_angle_text'] as String,
        category: json['category'] as String,
        clusterNumber: json['cluster_number'] as int,
        culinarySignificance: json['culinary_significance'] as String,
        designPrinciples: json['design_principles'] as String,
        destinationHighlights: json['destination_highlights'] as String,
        didYouKnow: json['did_you_know'] as String,
        diyTips: json['diy_tips'] as String,
        domains: (json['domains'] as List)
            .map((item) => NewsDomain.fromJson(item))
            .toList(),
        economicImplications: json['economic_implications'] as String,
        emoji: json['emoji'] as String,
        futureOutlook: json['future_outlook'] as String,
        gameplayMechanics: _parseStringList(json['gameplay_mechanics']),
        geopoliticalContext: json['geopolitical_context'] as String,
        historicalBackground: json['historical_background'] as String,
        humanitarianImpact: json['humanitarian_impact'] as String,
        industryImpact: _parseStringList(json['industry_impact']),
        internationalReactions:
            _parseStringList(json['international_reactions']),
        keyPlayers: _parseStringList(json['key_players']),
        leagueStandings: json['league_standings'] as String,
        location: json['location'] as String,
        numberOfTitles: json['number_of_titles'] as int,
        performanceStatistics: _parseStringList(json['performance_statistics']),
        perspectives: (json['perspectives'] as List)
            .map((item) => Perspective.fromJson(item))
            .toList(),
        quote: json['quote'] as String,
        quoteAuthor: json['quote_author'] as String,
        quoteSourceDomain: json['quote_source_domain'] as String,
        quoteSourceUrl: json['quote_source_url'] as String,
        scientificSignificance:
            _parseStringList(json['scientific_significance']),
        shortSummary: json['short_summary'] as String,
        talkingPoints: _parseStringList(json['talking_points']),
        technicalDetails: _parseStringList(json['technical_details']),
        technicalSpecifications: json['technical_specifications'] as String,
        timeline: _parseStringList(json['timeline']),
        title: json['title'] as String,
        travelAdvisory: _parseStringList(json['travel_advisory']),
        uniqueDomains: json['unique_domains'] as int,
        userActionItems: _parseStringList(json['user_action_items']),
        userExperienceImpact: _parseStringList(json['user_experience_impact']),
      );
    } catch (e) {
      print("Error parsing NewsCluster: $e  --> $json");
      throw Exception("Failed to parse NewsCluster");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'articles': articles.map((item) => item.toJson()).toList(),
      'business_angle_points': businessAnglePoints,
      'business_angle_text': businessAngleText,
      'category': category,
      'cluster_number': clusterNumber,
      'culinary_significance': culinarySignificance,
      'design_principles': designPrinciples,
      'destination_highlights': destinationHighlights,
      'did_you_know': didYouKnow,
      'diy_tips': diyTips,
      'domains': domains.map((item) => item.toJson()).toList(),
      'economic_implications': economicImplications,
      'emoji': emoji,
      'future_outlook': futureOutlook,
      'gameplay_mechanics': gameplayMechanics,
      'geopolitical_context': geopoliticalContext,
      'historical_background': historicalBackground,
      'humanitarian_impact': humanitarianImpact,
      'industry_impact': industryImpact,
      'international_reactions': internationalReactions,
      'key_players': keyPlayers,
      'league_standings': leagueStandings,
      'location': location,
      'number_of_titles': numberOfTitles,
      'performance_statistics': performanceStatistics,
      'perspectives': perspectives.map((item) => item.toJson()).toList(),
      'quote': quote,
      'quote_author': quoteAuthor,
      'quote_source_domain': quoteSourceDomain,
      'quote_source_url': quoteSourceUrl,
      'scientific_significance': scientificSignificance,
      'short_summary': shortSummary,
      'talking_points': talkingPoints,
      'technical_details': technicalDetails,
      'technical_specifications': technicalSpecifications,
      'timeline': timeline,
      'title': title,
      'travel_advisory': travelAdvisory,
      'unique_domains': uniqueDomains,
      'user_action_items': userActionItems,
      'user_experience_impact': userExperienceImpact,
    };
  }
}

class Perspective {
  final String text;
  final List<Source> sources;

  Perspective({
    required this.text,
    required this.sources,
  });

  factory Perspective.fromJson(Map<String, dynamic> json) {
    return Perspective(
      text: json['text'] as String,
      sources: (json['sources'] as List)
          .map((item) => Source.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sources': sources.map((item) => item.toJson()).toList(),
    };
  }
}

class Source {
  final String name;
  final String url;

  Source({
    required this.name,
    required this.url,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      name: json['name'] as String,
      url: json['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}

class Article {
  final String title;
  final String link;
  final String domain;
  final String date;
  final String image;
  final String imageCaption;

  Article({
    required this.title,
    required this.link,
    required this.domain,
    required this.date,
    required this.image,
    required this.imageCaption,
  });

  static String _formatDateFromJson(String dateStr) {
    try {
      return DateFormat('dd MMM yyyy, hh.mm a')
          .format(DateTime.parse(dateStr).toLocal());
    } catch (e) {
      return dateStr;
    }
  }

  static String _formatDateToJson(String formattedDate) {
    try {
      return DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").format(
          DateFormat('dd MMM yyyy, hh.mm a').parse(formattedDate).toUtc());
    } catch (e) {
      return formattedDate;
    }
  }

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String,
      link: json['link'] as String,
      domain: json['domain'] as String,
      date: _formatDateFromJson(json['date'] as String),
      image: json['image'] as String,
      imageCaption: json['image_caption'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'link': link,
      'domain': domain,
      'date': _formatDateToJson(date),
      'image': image,
      'image_caption': imageCaption,
    };
  }
}

class NewsDomain {
  final String name;
  final String favicon;

  NewsDomain({
    required this.name,
    required this.favicon,
  });

  factory NewsDomain.fromJson(Map<String, dynamic> json) {
    return NewsDomain(
      name: json['name'] as String,
      favicon: json['favicon'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'favicon': favicon,
    };
  }
}

class OnThisDayItem {
  final String year;
  final String htmlContent;
  final double sortYear;
  final String type;

  OnThisDayItem({
    required this.year,
    required this.htmlContent,
    required this.sortYear,
    required this.type,
  });

  factory OnThisDayItem.fromJson(Map<String, dynamic> json) {
    return OnThisDayItem(
      year: json['year'] as String,
      htmlContent: json['content'] as String,
      sortYear: json['sort_year'] is int
          ? (json['sort_year'] as int).toDouble()
          : json['sort_year'] as double,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'content': htmlContent,
      'sort_year': sortYear,
      'type': type,
    };
  }
}
