import 'package:inventory_management_with_sql/core/db/interface/table.dart';

abstract class SqliteBaseMigration {
  SqliteBaseMigration([Map<String, List<TableProperties>>? migrations])
      : db = migrations ?? {};
  Map<String, List<TableProperties>> get table {
    _load();

    return db;
  }

  final Map<String, List<TableProperties>> db;

  Map<String, List<TableProperties>> get up;
  Map<String, List<TableProperties>> get down;

  _load() {
    up.forEach(
      (tableName, columns) {
        final isExits = db[tableName];
        if (isExits == null) {
          db[tableName] = columns;
          return;
        }
        for (final column in columns) {
          final index = isExits.indexOf(column);
          if (index >= 0) {
            db[tableName]![index] = column;
          } else {
            db[tableName]!.add(column);
          }
        }
      },
    );

    down.forEach(
      (tableName, columns) {
        final isExits = db[tableName];
        if (isExits == null) {
          return;
        }
        for (final column in columns) {
          db[tableName]!.remove(column);
        }
      },
    );
  }
}
