// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoryDetailsEntityTable extends CategoryDetailsEntity
    with TableInfo<$CategoryDetailsEntityTable, CategoryDetail> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryDetailsEntityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<int> timestamp = GeneratedColumn<int>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _jsonDataMeta =
      const VerificationMeta('jsonData');
  @override
  late final GeneratedColumn<String> jsonData = GeneratedColumn<String>(
      'json_data', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [fileName, category, timestamp, jsonData];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_details_entity';
  @override
  VerificationContext validateIntegrity(Insertable<CategoryDetail> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('json_data')) {
      context.handle(_jsonDataMeta,
          jsonData.isAcceptableOrUnknown(data['json_data']!, _jsonDataMeta));
    } else if (isInserting) {
      context.missing(_jsonDataMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {fileName};
  @override
  CategoryDetail map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryDetail(
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}timestamp'])!,
      jsonData: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json_data'])!,
    );
  }

  @override
  $CategoryDetailsEntityTable createAlias(String alias) {
    return $CategoryDetailsEntityTable(attachedDatabase, alias);
  }
}

class CategoryDetail extends DataClass implements Insertable<CategoryDetail> {
  /// Unique file name for the category; we use it as the primary key.
  final String fileName;

  /// The category name.
  final String category;

  /// Timestamp from the server.
  final int timestamp;

  /// Serialized JSON data for the category details.
  final String jsonData;
  const CategoryDetail(
      {required this.fileName,
      required this.category,
      required this.timestamp,
      required this.jsonData});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['file_name'] = Variable<String>(fileName);
    map['category'] = Variable<String>(category);
    map['timestamp'] = Variable<int>(timestamp);
    map['json_data'] = Variable<String>(jsonData);
    return map;
  }

  CategoryDetailsEntityCompanion toCompanion(bool nullToAbsent) {
    return CategoryDetailsEntityCompanion(
      fileName: Value(fileName),
      category: Value(category),
      timestamp: Value(timestamp),
      jsonData: Value(jsonData),
    );
  }

  factory CategoryDetail.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryDetail(
      fileName: serializer.fromJson<String>(json['fileName']),
      category: serializer.fromJson<String>(json['category']),
      timestamp: serializer.fromJson<int>(json['timestamp']),
      jsonData: serializer.fromJson<String>(json['jsonData']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'fileName': serializer.toJson<String>(fileName),
      'category': serializer.toJson<String>(category),
      'timestamp': serializer.toJson<int>(timestamp),
      'jsonData': serializer.toJson<String>(jsonData),
    };
  }

  CategoryDetail copyWith(
          {String? fileName,
          String? category,
          int? timestamp,
          String? jsonData}) =>
      CategoryDetail(
        fileName: fileName ?? this.fileName,
        category: category ?? this.category,
        timestamp: timestamp ?? this.timestamp,
        jsonData: jsonData ?? this.jsonData,
      );
  CategoryDetail copyWithCompanion(CategoryDetailsEntityCompanion data) {
    return CategoryDetail(
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      category: data.category.present ? data.category.value : this.category,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      jsonData: data.jsonData.present ? data.jsonData.value : this.jsonData,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryDetail(')
          ..write('fileName: $fileName, ')
          ..write('category: $category, ')
          ..write('timestamp: $timestamp, ')
          ..write('jsonData: $jsonData')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(fileName, category, timestamp, jsonData);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryDetail &&
          other.fileName == this.fileName &&
          other.category == this.category &&
          other.timestamp == this.timestamp &&
          other.jsonData == this.jsonData);
}

class CategoryDetailsEntityCompanion extends UpdateCompanion<CategoryDetail> {
  final Value<String> fileName;
  final Value<String> category;
  final Value<int> timestamp;
  final Value<String> jsonData;
  final Value<int> rowid;
  const CategoryDetailsEntityCompanion({
    this.fileName = const Value.absent(),
    this.category = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.jsonData = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryDetailsEntityCompanion.insert({
    required String fileName,
    required String category,
    required int timestamp,
    required String jsonData,
    this.rowid = const Value.absent(),
  })  : fileName = Value(fileName),
        category = Value(category),
        timestamp = Value(timestamp),
        jsonData = Value(jsonData);
  static Insertable<CategoryDetail> custom({
    Expression<String>? fileName,
    Expression<String>? category,
    Expression<int>? timestamp,
    Expression<String>? jsonData,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (fileName != null) 'file_name': fileName,
      if (category != null) 'category': category,
      if (timestamp != null) 'timestamp': timestamp,
      if (jsonData != null) 'json_data': jsonData,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryDetailsEntityCompanion copyWith(
      {Value<String>? fileName,
      Value<String>? category,
      Value<int>? timestamp,
      Value<String>? jsonData,
      Value<int>? rowid}) {
    return CategoryDetailsEntityCompanion(
      fileName: fileName ?? this.fileName,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      jsonData: jsonData ?? this.jsonData,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<int>(timestamp.value);
    }
    if (jsonData.present) {
      map['json_data'] = Variable<String>(jsonData.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryDetailsEntityCompanion(')
          ..write('fileName: $fileName, ')
          ..write('category: $category, ')
          ..write('timestamp: $timestamp, ')
          ..write('jsonData: $jsonData, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoryDetailsEntityTable categoryDetailsEntity =
      $CategoryDetailsEntityTable(this);
  late final CategoryDetailsDao categoryDetailsDao =
      CategoryDetailsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [categoryDetailsEntity];
}

typedef $$CategoryDetailsEntityTableCreateCompanionBuilder
    = CategoryDetailsEntityCompanion Function({
  required String fileName,
  required String category,
  required int timestamp,
  required String jsonData,
  Value<int> rowid,
});
typedef $$CategoryDetailsEntityTableUpdateCompanionBuilder
    = CategoryDetailsEntityCompanion Function({
  Value<String> fileName,
  Value<String> category,
  Value<int> timestamp,
  Value<String> jsonData,
  Value<int> rowid,
});

class $$CategoryDetailsEntityTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryDetailsEntityTable> {
  $$CategoryDetailsEntityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get jsonData => $composableBuilder(
      column: $table.jsonData, builder: (column) => ColumnFilters(column));
}

class $$CategoryDetailsEntityTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryDetailsEntityTable> {
  $$CategoryDetailsEntityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get jsonData => $composableBuilder(
      column: $table.jsonData, builder: (column) => ColumnOrderings(column));
}

class $$CategoryDetailsEntityTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryDetailsEntityTable> {
  $$CategoryDetailsEntityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<String> get jsonData =>
      $composableBuilder(column: $table.jsonData, builder: (column) => column);
}

class $$CategoryDetailsEntityTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CategoryDetailsEntityTable,
    CategoryDetail,
    $$CategoryDetailsEntityTableFilterComposer,
    $$CategoryDetailsEntityTableOrderingComposer,
    $$CategoryDetailsEntityTableAnnotationComposer,
    $$CategoryDetailsEntityTableCreateCompanionBuilder,
    $$CategoryDetailsEntityTableUpdateCompanionBuilder,
    (
      CategoryDetail,
      BaseReferences<_$AppDatabase, $CategoryDetailsEntityTable, CategoryDetail>
    ),
    CategoryDetail,
    PrefetchHooks Function()> {
  $$CategoryDetailsEntityTableTableManager(
      _$AppDatabase db, $CategoryDetailsEntityTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryDetailsEntityTableFilterComposer(
                  $db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryDetailsEntityTableOrderingComposer(
                  $db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryDetailsEntityTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> fileName = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> timestamp = const Value.absent(),
            Value<String> jsonData = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoryDetailsEntityCompanion(
            fileName: fileName,
            category: category,
            timestamp: timestamp,
            jsonData: jsonData,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String fileName,
            required String category,
            required int timestamp,
            required String jsonData,
            Value<int> rowid = const Value.absent(),
          }) =>
              CategoryDetailsEntityCompanion.insert(
            fileName: fileName,
            category: category,
            timestamp: timestamp,
            jsonData: jsonData,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CategoryDetailsEntityTableProcessedTableManager
    = ProcessedTableManager<
        _$AppDatabase,
        $CategoryDetailsEntityTable,
        CategoryDetail,
        $$CategoryDetailsEntityTableFilterComposer,
        $$CategoryDetailsEntityTableOrderingComposer,
        $$CategoryDetailsEntityTableAnnotationComposer,
        $$CategoryDetailsEntityTableCreateCompanionBuilder,
        $$CategoryDetailsEntityTableUpdateCompanionBuilder,
        (
          CategoryDetail,
          BaseReferences<_$AppDatabase, $CategoryDetailsEntityTable,
              CategoryDetail>
        ),
        CategoryDetail,
        PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoryDetailsEntityTableTableManager get categoryDetailsEntity =>
      $$CategoryDetailsEntityTableTableManager(_db, _db.categoryDetailsEntity);
}
