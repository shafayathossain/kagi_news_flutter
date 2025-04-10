import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/network/model/news_categories_response.dart';

void main() {
  group('NewsCategory', () {
    test('toJson converts NewsCategory to correct map', () {
      final category = NewsCategory(
        name: 'Technology',
        file: 'tech.json',
      );

      final json = category.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['name'], 'Technology');
      expect(json['file'], 'tech.json');
    });
  });

  group('KagiNewsCategoriesResponse', () {
    test('toJson converts response with categories correctly', () {
      final categories = [
        NewsCategory(name: 'World', file: 'world.json'),
        NewsCategory(name: 'Business', file: 'business.json'),
      ];

      final response = KagiNewsCategoriesResponse(
        timestamp: 1644048227,
        categories: categories,
      );

      final json = response.toJson();

      expect(json, isA<Map<String, dynamic>>());
      expect(json['timestamp'], 1644048227);
      expect(json['categories'], isA<List>());
      expect((json['categories'] as List).length, 2);
    });

    test('toJson handles empty categories list', () {
      final response = KagiNewsCategoriesResponse(
        timestamp: 1644048227,
        categories: [],
      );

      final json = response.toJson();

      expect(json['categories'], isEmpty);
    });

    test('Round-trip test: fromJson → toJson maintains data integrity', () {
      final originalJson = {
        'timestamp': 1644048227,
        'categories': [
          {'name': 'Sports', 'file': 'sports.json'},
          {'name': 'Health', 'file': 'health.json'},
        ]
      };

      final response = KagiNewsCategoriesResponse.fromJson(originalJson);

      final convertedJson = response.toJson();

      expect(convertedJson['timestamp'], originalJson['timestamp']);
      expect(
        (convertedJson['categories'] as List).length,
        (originalJson['categories'] as List).length,
      );

      for (var i = 0; i < (originalJson['categories'] as List).length; i++) {
        expect(
          (convertedJson['categories'] as List)[i]['name'],
          (originalJson['categories'] as List)[i]['name'],
        );
        expect(
          (convertedJson['categories'] as List)[i]['file'],
          (originalJson['categories'] as List)[i]['file'],
        );
      }
    });

    test('serializes to JSON string correctly', () {
      final response = KagiNewsCategoriesResponse(
        timestamp: 1644048227,
        categories: [NewsCategory(name: 'Tech', file: 'tech.json')],
      );

      final jsonString = jsonEncode(response.toJson());

      expect(
        jsonString,
        '{"timestamp":1644048227,"categories":[{"name":"Tech","file":"tech.json"}]}',
      );
    });
  });
}
