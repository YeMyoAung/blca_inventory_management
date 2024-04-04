import 'dart:io';

import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';
import 'package:inventory_management_with_sql/core/db/interface/table.dart';
import 'package:inventory_management_with_sql/core/db/utils/const.dart';
import 'package:inventory_management_with_sql/core/db/utils/sql_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase implements DataStore<Database> {
  final String dbName;
  final int version;
  @override
  Database? database;
  SqliteDatabase._(this.dbName, [this.version = 1]);

  ///singletone
  static final Map<String, SqliteDatabase> _instance = {};

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
      onCreate: (db, __) async {
        await onUp(db);
      },
      onDowngrade: (db, __, ___) async {
        await onDown(db);
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
  Future<void> onUp([Database? db]) async {
    if (db == null) {
      assert(database != null);
    }

    await Future.wait(tableNames.map((tableName) {
      String query = """Create table if not exists "$tableName" (
        id integer primary key autoincrement,
        created_at text not null,  
        updated_at text,
      """;

      for (TableProperties column in tableColumns[tableName] ?? []) {
        query += toSqlQuery(column);
      }
      query = query.replaceFirst(",", "", query.length - 2);
      query += ");";
      return (db ?? database)!.execute(query);
    }));
    print("object created");
  }

  @override
  Future<void> onDown([Database? db]) async {
    if (db == null) {
      assert(database != null);
    }
    await Future.wait(tableNames.reversed.map((e) {
      return (db ?? database)!.execute(""" 
        drop table if exists "$e" 
      """);
    }));
    print("object deleted");
  }
}
