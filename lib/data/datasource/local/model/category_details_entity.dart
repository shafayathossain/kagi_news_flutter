import 'package:drift/drift.dart';

@DataClassName('CategoryDetail')
class CategoryDetailsEntity extends Table {
  TextColumn get fileName => text()();

  TextColumn get category => text()();

  IntColumn get timestamp => integer()();

  /// Serialized JSON data for the category details.
  TextColumn get jsonData => text()();

  @override
  Set<Column> get primaryKey => {fileName};
}
