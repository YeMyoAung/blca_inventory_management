import 'dart:io';

import 'package:inventory_management_with_sql/core/db/database_interface.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabase implements DataStore {
  final String dbName;
  final int version;
  late final Database? database;
  SqliteDatabase._(this.dbName, [this.version = 1]);

  ///singletone
  static final Map<String, SqliteDatabase> _instance = {};

  static SqliteDatabase newInstance(String dbName, [int version = 1]) {
    _instance[dbName] ??= SqliteDatabase._(dbName, version);
    return _instance[dbName]!;
  }

  @override
  Future<void> connect() async {
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
      onCreate: (_, __) async {
        await onUp();
      },
      onDowngrade: (_, __, ___) async {
        await onDown();
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
  Future<void> onUp() {
    assert(database != null);
    throw UnimplementedError();
  }

  @override
  Future<void> onDown() {
    assert(database != null);
    throw UnimplementedError();
  }
}
