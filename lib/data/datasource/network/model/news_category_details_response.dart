class NewsCategoryDetailsResponse {
  final String category;
  final int timestamp;
  final int read;
  final List<NewsCluster> clusters;

  NewsCategoryDetailsResponse({
    required this.category,
    required this.timestamp,
    required this.read,
    required this.clusters,
  });

  factory NewsCategoryDetailsResponse.fromJson(Map<String, dynamic> json) {
    return NewsCategoryDetailsResponse(
      category: json['category'] as String,
      timestamp: json['timestamp'] as int,
      read: json['read'] as int,
      clusters: (json['clusters'] as List)
          .map((item) => NewsCluster.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'category': category,
    'timestamp': timestamp,
    'read': read,
    'clusters': clusters.map((cluster) => cluster.toJson()).toList(),
  };
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
  final String technicalDetails;
  final String businessAngleText;
  final List<String> businessAnglePoints;
  final String userActionItems;
  final List<String> scientificSignificance;
  final List<String> travelAdvisory;
  final String destinationHighlights;
  final String culinarySignificance;
  final List<String> performanceStatistics;
  final String leagueStandings;
  final String diyTips;
  final String designPrinciples;
  final String userExperienceImpact;
  final List<String> gameplayMechanics;
  final List<String> industryImpact;
  final String technicalSpecifications;
  final List<Article> articles;
  final List<NewsDomain> domains;

  NewsCluster({
    required this.clusterNumber,
    required this.uniqueDomains,
    required this.numberOfTitles,
    required this.category,
    required this.title,
    required this.shortSummary,
    required this.didYouKnow,
    required this.talkingPoints,
    required this.quote,
    required this.quoteAuthor,
    required this.quoteSourceUrl,
    required this.quoteSourceDomain,
    required this.location,
    required this.perspectives,
    required this.emoji,
    required this.geopoliticalContext,
    required this.historicalBackground,
    required this.internationalReactions,
    required this.humanitarianImpact,
    required this.economicImplications,
    required this.timeline,
    required this.futureOutlook,
    required this.keyPlayers,
    required this.technicalDetails,
    required this.businessAngleText,
    required this.businessAnglePoints,
    required this.userActionItems,
    required this.scientificSignificance,
    required this.travelAdvisory,
    required this.destinationHighlights,
    required this.culinarySignificance,
    required this.performanceStatistics,
    required this.leagueStandings,
    required this.diyTips,
    required this.designPrinciples,
    required this.userExperienceImpact,
    required this.gameplayMechanics,
    required this.industryImpact,
    required this.technicalSpecifications,
    required this.articles,
    required this.domains,
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
    return NewsCluster(
      clusterNumber: json['cluster_number'] as int,
      uniqueDomains: json['unique_domains'] as int,
      numberOfTitles: json['number_of_titles'] as int,
      category: json['category'] as String,
      title: json['title'] as String,
      shortSummary: json['short_summary'] as String,
      didYouKnow: json['did_you_know'] as String,
      talkingPoints: List<String>.from(json['talking_points'] as List),
      quote: json['quote'] as String,
      quoteAuthor: json['quote_author'] as String,
      quoteSourceUrl: json['quote_source_url'] as String,
      quoteSourceDomain: json['quote_source_domain'] as String,
      location: json['location'] as String,
      perspectives: (json['perspectives'] as List)
          .map((item) => Perspective.fromJson(item))
          .toList(),
      emoji: json['emoji'] as String,
      geopoliticalContext: json['geopolitical_context'] as String,
      historicalBackground: json['historical_background'] as String,
      // Here we use our helper to handle cases where the field can be a string or list.
      internationalReactions:
      _parseStringList(json['international_reactions']),
      humanitarianImpact: json['humanitarian_impact'] as String,
      economicImplications: json['economic_implications'] as String,
      timeline: List<String>.from(json['timeline'] as List),
      futureOutlook: json['future_outlook'] as String,
      keyPlayers: List<String>.from(json['key_players'] as List),
      technicalDetails: json['technical_details'] as String,
      businessAngleText: json['business_angle_text'] as String,
      businessAnglePoints:
      List<String>.from(json['business_angle_points'] as List),
      userActionItems: json['user_action_items'] as String,
      scientificSignificance:
      List<String>.from(json['scientific_significance'] as List),
      travelAdvisory: List<String>.from(json['travel_advisory'] as List),
      destinationHighlights: json['destination_highlights'] as String,
      culinarySignificance: json['culinary_significance'] as String,
      performanceStatistics:
      List<String>.from(json['performance_statistics'] as List),
      leagueStandings: json['league_standings'] as String,
      diyTips: json['diy_tips'] as String,
      designPrinciples: json['design_principles'] as String,
      userExperienceImpact: json['user_experience_impact'] as String,
      gameplayMechanics:
      List<String>.from(json['gameplay_mechanics'] as List),
      industryImpact: List<String>.from(json['industry_impact'] as List),
      technicalSpecifications: json['technical_specifications'] as String,
      articles: (json['articles'] as List)
          .map((item) => Article.fromJson(item))
          .toList(),
      domains: (json['domains'] as List)
          .map((item) => NewsDomain.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'cluster_number': clusterNumber,
    'unique_domains': uniqueDomains,
    'number_of_titles': numberOfTitles,
    'category': category,
    'title': title,
    'short_summary': shortSummary,
    'did_you_know': didYouKnow,
    'talking_points': talkingPoints,
    'quote': quote,
    'quote_author': quoteAuthor,
    'quote_source_url': quoteSourceUrl,
    'quote_source_domain': quoteSourceDomain,
    'location': location,
    'perspectives': perspectives.map((p) => p.toJson()).toList(),
    'emoji': emoji,
    'geopolitical_context': geopoliticalContext,
    'historical_background': historicalBackground,
    'international_reactions': internationalReactions,
    'humanitarian_impact': humanitarianImpact,
    'economic_implications': economicImplications,
    'timeline': timeline,
    'future_outlook': futureOutlook,
    'key_players': keyPlayers,
    'technical_details': technicalDetails,
    'business_angle_text': businessAngleText,
    'business_angle_points': businessAnglePoints,
    'user_action_items': userActionItems,
    'scientific_significance': scientificSignificance,
    'travel_advisory': travelAdvisory,
    'destination_highlights': destinationHighlights,
    'culinary_significance': culinarySignificance,
    'performance_statistics': performanceStatistics,
    'league_standings': leagueStandings,
    'diy_tips': diyTips,
    'design_principles': designPrinciples,
    'user_experience_impact': userExperienceImpact,
    'gameplay_mechanics': gameplayMechanics,
    'industry_impact': industryImpact,
    'technical_specifications': technicalSpecifications,
    'articles': articles.map((a) => a.toJson()).toList(),
    'domains': domains.map((d) => d.toJson()).toList(),
  };
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

  Map<String, dynamic> toJson() => {
    'text': text,
    'sources': sources.map((s) => s.toJson()).toList(),
  };
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

  Map<String, dynamic> toJson() => {
    'name': name,
    'url': url,
  };
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

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String,
      link: json['link'] as String,
      domain: json['domain'] as String,
      date: json['date'] as String,
      image: json['image'] as String,
      imageCaption: json['image_caption'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'link': link,
    'domain': domain,
    'date': date,
    'image': image,
    'image_caption': imageCaption,
  };
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

  Map<String, dynamic> toJson() => {
    'name': name,
    'favicon': favicon,
  };
}
