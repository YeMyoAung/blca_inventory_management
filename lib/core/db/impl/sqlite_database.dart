import 'dart:io';

import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';
import 'package:inventory_management_with_sql/core/db/interface/table.dart';
import 'package:inventory_management_with_sql/core/db/utils/const.dart';
import 'package:inventory_management_with_sql/core/db/utils/sql_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// SqliteDatabase? _single;

class SqliteDatabase implements DataStore<Database> {
  final String dbName;
  final int version;
  @override
  Database? database;
  SqliteDatabase._(this.dbName, [this.version = 1]);

  ///singletone
  ///dbName => SqliteDatabase
  static final Map<String, SqliteDatabase> _instance = {};

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

  static SqliteDatabase newInstance(String dbName, [int version = 1]) {
    _instance[dbName] ??= SqliteDatabase._(dbName, version);
    return _instance[dbName]!;
  }

  @override
  Future<void> connect() async {
    if (database != null) {
      return;
    }

    /// check db file
    /// open db
    final Directory doc = await getApplicationDocumentsDirectory();
    final File dbFile = File("${doc.path}/$dbName");
    if (!(await dbFile.exists())) {
      await dbFile.create();
    }

    database = await openDatabase(
      dbFile.path,
      version: version,
      onCreate: (db, current) async {
        await onUp(
          current,
          db,
        );
      },
      onUpgrade: (db, old, current) async {
        await onUp(current, db);
      },
      onDowngrade: (db, old, current) async {
        await onDown(old, current, db);
      },
    );
  }

  @override
  Future<void> close() async {
    assert(database != null);
    await database!.close();
    _instance.remove(dbName);
  }

  @override
  Future<void> onUp(
    int version, [
    Database? db,
  ]) async {
    assert(db != null || database != null);

    final migration = tableNames[version];
    final columnMigration = tableColumns[version];
    if (migration == null || columnMigration == null) throw "version not found";

    await Future.wait(migration.map((tableName) {
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
    print("object created");
  }

  @override
  Future<void> onDown(int old, current, [Database? db]) async {
    assert(db != null || database != null);
    final currentMigration = tableNames[current];
    final oldMigration = tableNames[old];
    final oldColumnMigration = tableColumns[old];
    if (currentMigration == null ||
        oldMigration == null ||
        oldColumnMigration == null) {
      throw "version not found";
    }
    await Future.wait(currentMigration.reversed.map((e) {
      return (db ?? database)!.execute(""" 
        drop table if exists "$e"; 
      """);
    }));
    print("object deleted");
    await onUp(old, db);
  }
}
