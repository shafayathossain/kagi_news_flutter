import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:kagi_news/data/datasource/local/model/category_details_entity.dart';
import 'package:path_provider/path_provider.dart';

import 'category_details_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [CategoryDetailsEntity], daos: [CategoryDetailsDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'app_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationSupportDirectory,
      ),
    );
  }
}
