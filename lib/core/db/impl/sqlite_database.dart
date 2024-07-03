import 'dart:io';

import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/interface/table.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/db/utils/sql_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// SqliteDatabase? _single;

class SqliteDatabase implements DataStore<Database> {
  final String dbName;
  final int version;
  final Map<int, Map<String, List<TableProperties>>> tableColumns;
  final String storePath;
  @override
  Database? database;
  Directory? doc;

  SqliteDatabase._(
    this.dbName,
    this.tableColumns, [
    this.version = 1,
    this.storePath = "/sqlite",
  ]);

  ///singletone
  ///dbName => SqliteDatabase
  static final Map<String, SqliteDatabase> _instance = {};

  Future<void> removeAllSqliteFiles() async {
    if (doc == null) {
      await checkStorePath();
    }
    // await doc!.list().forEach((fs) async {
    //   final stat = await fs.stat();
    //   if (stat.type == FileSystemEntityType.file) {
    //     logger.i("Sqlite DB File `${fs.path}` was deleted.");
    //     await fs.delete();
    //   }
    // });
    await doc!.delete(recursive: true);

    // final sqliteDir = Directory("${doc!.path}/sqlite/");
    // if (await sqliteDir.exists()) {
    //   await sqliteDir.delete();
    // }
  }

  // static SqliteDatabase? _single;

  // static SqliteDatabase get single {
  //   _single ??= SqliteDatabase._('hello');
  //   return _single!;
  // }

  // static SqliteDatabase single() {
  //   _single ??= SqliteDatabase._("dbName");
  //   return _single!;
  // }

  // factory SqliteDatabase.single() {
  //   _single ??= SqliteDatabase._("dbName");
  //   return _single!;
  // }

  static SqliteDatabase newInstance(
    String dbName,
    Map<int, Map<String, List<TableProperties>>> tableColumns, [
    int version = 1,
    String storePath = "/sqlite",
  ]) {
    if (_instance[dbName] != null) {
      return _instance[dbName]!;
    }
    // assert(== null);
    _instance[dbName] ??= SqliteDatabase._(
      dbName,
      tableColumns,
      version,
      storePath,
    );

    return _instance[dbName]!;
  }

  static SqliteDatabase getInstance(String dbName) {
    return _instance[dbName]!;
  }

  Future<void> checkStorePath() async {
    if (doc == null) {
      doc = await getApplicationDocumentsDirectory();
      doc = Directory(doc!.path + storePath);
      if (await doc!.exists()) return;

      await doc!.create();
    }
  }

  @override
  Future<Result> connect() async {
    if (database != null) {
      return const Result();
    }

    try {
      /// check db file
      /// open db
      await checkStorePath();
      final File dbFile = File("${doc!.path}/$dbName");
      if (!(await dbFile.exists())) {
        await dbFile.create();
      }

      await openDatabase(
        dbFile.path,
        version: version,
        onConfigure: (db) {
          database = db;
        },
        onCreate: (db, current) async {
          logger.f("onCreate Run");

          await onUp(
            current,
            db,
          );
        },
        onUpgrade: (db, old, current) async {
          logger.f("OnUpgrade Run");
          await onDown(old, current, db);
          await onUp(current, db);
        },
        onDowngrade: (db, old, current) async {
          logger.f("onDowngrade Run");

          await onDown(old, current, db);
        },
        readOnly: false,
      );

      logger.i("$dbName was connected");
      return const Result();
    } catch (e) {
      return Result(exception: Error(e.toString(), StackTrace.current));
    }
  }

  @override
  Future<void> close() async {
    assert(database != null);
    await database!.close();
    logger.e("SqliteDatabase $_instance");
    _instance.remove(dbName);
  }

  @override
  Future<void> onUp(
    int version, [
    Database? db,
  ]) async {
    assert(db != null || database != null);

    final columnMigration = tableColumns[version];
    if (columnMigration == null) throw "version not found";

    await Future.wait(columnMigration.keys.map((tableName) {
      String query = """Create table if not exists "$tableName" (
        id integer primary key autoincrement,
        created_at text not null,  
        updated_at text,
      """;

      ///other column
      for (TableProperties column in columnMigration[tableName] ?? []) {
        query += toSqlQuery(column);
      }

      /// Create table if not exists $tableName (
      ///  id integer primary key autoincrement,
      ///  created_at text not null,
      ///  updated_at text,
      ///  name varchar(255) not null,
      ///  length > index  > 1
      ///  2
      query = query.replaceFirst(",", "", query.length - 2);

      /// Create table if not exists $tableName (
      ///  id integer primary key autoincrement,
      ///  created_at text not null,
      ///  updated_at text,
      ///  name varchar(255) not null

      query += ");";
      return (db ?? database)!.execute(query);
    }));
    logger.i("Migration Up");
  }

  @override
  Future<void> onDown(int old, current, [Database? db]) async {
    assert(db != null || database != null);
    final currentMigration = tableColumns[current];
    if (currentMigration == null) throw "version now found";
    final oldColumnMigration = tableColumns[old];
    if (oldColumnMigration == null) {
      throw "version not found";
    }
    await Future.wait(currentMigration.keys.toList().reversed.map((e) {
      return (db ?? database)!.execute("""
        drop table if exists "$e"; 
      """);
    }));
    logger.i("Migration Down");
    // await onUp(current, db);
  }
}
