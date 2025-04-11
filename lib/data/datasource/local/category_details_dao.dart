import 'package:drift/drift.dart';
import 'package:kagi_news/data/datasource/local/app_database.dart';
import 'package:kagi_news/data/datasource/local/model/category_details_entity.dart';

part 'category_details_dao.g.dart';

@DriftAccessor(tables: [CategoryDetailsEntity])
class CategoryDetailsDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDetailsDaoMixin {

  CategoryDetailsDao(AppDatabase db) : super(db);

  Future<List<CategoryDetail>> getAll() => select(categoryDetailsEntity).get();

  Future<CategoryDetail?> getByFileName(String fileName) {
    return (select(categoryDetailsEntity)
          ..where((tbl) => tbl.fileName.equals(fileName)))
        .getSingleOrNull();
  }

  Future<int> insertOrUpdate(CategoryDetail detail) =>
      into(categoryDetailsEntity).insertOnConflictUpdate(detail);

  Future<void> deleteAll() {
    return (delete(categoryDetailsEntity)).go();
  }
}
