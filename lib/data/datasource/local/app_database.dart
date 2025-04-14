import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:kagi_news/data/datasource/local/category_details_dao.dart';
import 'package:kagi_news/data/datasource/local/model/category_details_entity.dart';
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [CategoryDetailsEntity], daos: [CategoryDetailsDao])
class AppDatabase extends _$AppDatabase {
  @override
  int get schemaVersion => 1;

  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'app_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
