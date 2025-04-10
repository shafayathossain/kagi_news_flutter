class KagiNewsCategoriesResponse {
  final int timestamp;
  final List<NewsCategory> categories;

  KagiNewsCategoriesResponse({
    required this.timestamp,
    required this.categories,
  });

  factory KagiNewsCategoriesResponse.fromJson(Map<String, dynamic> json) {
    return KagiNewsCategoriesResponse(
      timestamp: json['timestamp'] as int,
      categories: (json['categories'] as List)
          .map((item) => NewsCategory.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp,
      'categories': categories.map((item) => item.toJson()).toList(),
    };
  }
}

class NewsCategory {
  final String name;
  final String file;

  NewsCategory({
    required this.name,
    required this.file,
  });

  factory NewsCategory.fromJson(Map<String, dynamic> json) {
    return NewsCategory(
      name: json['name'] as String,
      file: json['file'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'file': file,
    };
  }
}