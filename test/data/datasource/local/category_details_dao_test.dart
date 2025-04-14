import 'package:drift/drift.dart' as drift;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kagi_news/data/datasource/local/app_database.dart';
import 'package:kagi_news/data/datasource/local/category_details_dao.dart';

void main() {
  late AppDatabase database;
  late CategoryDetailsDao categoryDetailsDao;

  setUp(() {
    database = AppDatabase(
      drift.DatabaseConnection(
        NativeDatabase.memory(),
        closeStreamsSynchronously: true,
      ),
    );
    categoryDetailsDao = database.categoryDetailsDao;
  });

  tearDown(() async {
    await database.close();
  });

  test('getAll returns empty list when database is empty', () async {
    final result = await categoryDetailsDao.getAll();
    expect(result, isEmpty);
  });

  test('getAll returns all inserted items', () async {
    const details1 = CategoryDetail(
      fileName: 'world.json',
      category: 'World',
      timestamp: 1744048227,
      jsonData: '{"articles": []}',
    );
    const details2 = CategoryDetail(
      fileName: 'usa.json',
      category: 'USA',
      timestamp: 1744048227,
      jsonData: '{"articles": []}',
    );

    await categoryDetailsDao.insertOrUpdate(details1);
    await categoryDetailsDao.insertOrUpdate(details2);

    final result = await categoryDetailsDao.getAll();

    expect(result.length, 2);
    expect(result.map((e) => e.fileName).toList()..sort(), [
      'usa.json',
      'world.json',
    ]);
  });

  test('getByFileName returns null when item does not exist', () async {
    final result = await categoryDetailsDao.getByFileName('nonexistent.json');
    expect(result, isNull);
  });

  test('getByFileName returns correct item', () async {
    const details = CategoryDetail(
      fileName: 'world.json',
      category: 'World',
      timestamp: 1744048227,
      jsonData: '{"articles": [{"title": "Test"}]}',
    );
    await categoryDetailsDao.insertOrUpdate(details);

    final result = await categoryDetailsDao.getByFileName('world.json');

    expect(result, isNotNull);
    expect(result!.fileName, 'world.json');
    expect(result.category, 'World');
    expect(result.jsonData, '{"articles": [{"title": "Test"}]}');
  });

  test('insertOrUpdate inserts new record and returns id', () async {
    const details = CategoryDetail(
      fileName: 'tech.json',
      category: 'Technology',
      timestamp: 1744048227,
      jsonData: '{"articles": []}',
    );

    final id = await categoryDetailsDao.insertOrUpdate(details);
    expect(id, isNotNull);

    final result = await categoryDetailsDao.getByFileName('tech.json');
    expect(result, isNotNull);
    expect(result!.category, 'Technology');
  });

  test('insertOrUpdate updates existing record', () async {
    const details = CategoryDetail(
      fileName: 'health.json',
      category: 'Health',
      timestamp: 1744048227,
      jsonData: '{"articles": []}',
    );
    await categoryDetailsDao.insertOrUpdate(details);

    const updatedDetails = CategoryDetail(
      fileName: 'health.json',
      category: 'Health & Wellness',
      timestamp: 1744048300,
      jsonData: '{"articles": [{"title": "Updated"}]}',
    );
    await categoryDetailsDao.insertOrUpdate(updatedDetails);

    final result = await categoryDetailsDao.getByFileName('health.json');
    expect(result, isNotNull);
    expect(result!.category, 'Health & Wellness');
    expect(result.timestamp, 1744048300);
    expect(result.jsonData, '{"articles": [{"title": "Updated"}]}');
  });

  test('insertOrUpdate handles multiple records', () async {
    final categories = [
      const CategoryDetail(
        fileName: 'sports.json',
        category: 'Sports',
        timestamp: 1744048227,
        jsonData: '{"articles": [{"id": 1}]}',
      ),
      const CategoryDetail(
        fileName: 'finance.json',
        category: 'Finance',
        timestamp: 1744048227,
        jsonData: '{"articles": [{"id": 2}]}',
      ),
      const CategoryDetail(
        fileName: 'politics.json',
        category: 'Politics',
        timestamp: 1744048227,
        jsonData: '{"articles": [{"id": 3}]}',
      ),
    ];

    for (final detail in categories) {
      await categoryDetailsDao.insertOrUpdate(detail);
    }

    final allResults = await categoryDetailsDao.getAll();
    expect(allResults.length, 3);

    final sports = await categoryDetailsDao.getByFileName('sports.json');
    final finance = await categoryDetailsDao.getByFileName('finance.json');

    expect(sports?.category, 'Sports');
    expect(finance?.category, 'Finance');
  });

  test(
    'insertOrUpdate with duplicate primary key updates the record without creating duplicates',
    () async {
      const details = CategoryDetail(
        fileName: 'duplicate.json',
        category: 'Initial',
        timestamp: 1000,
        jsonData: '{"articles": []}',
      );
      await categoryDetailsDao.insertOrUpdate(details);

      const updatedDetails = CategoryDetail(
        fileName: 'duplicate.json',
        category: 'Updated',
        timestamp: 2000,
        jsonData: '{"articles": [{"title": "Updated"}]}',
      );
      await categoryDetailsDao.insertOrUpdate(updatedDetails);

      final allRecords = await categoryDetailsDao.getAll();
      expect(allRecords.length, equals(1));
      final result = await categoryDetailsDao.getByFileName('duplicate.json');
      expect(result, isNotNull);
      expect(result!.category, equals('Updated'));
      expect(result.timestamp, equals(2000));
    },
  );

  test('deleteAll removes all records from the table', () async {
    await categoryDetailsDao.insertOrUpdate(
      const CategoryDetail(
        fileName: 'a.json',
        category: 'A',
        timestamp: 123,
        jsonData: '{"articles": []}',
      ),
    );

    await categoryDetailsDao.insertOrUpdate(
      const CategoryDetail(
        fileName: 'b.json',
        category: 'B',
        timestamp: 456,
        jsonData: '{"articles": []}',
      ),
    );

    await categoryDetailsDao.deleteAll();
    final result = await categoryDetailsDao.getAll();
    expect(result, isEmpty);
  });
}
