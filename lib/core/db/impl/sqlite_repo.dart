import 'dart:async';

import 'package:inventory_management_with_sql/core/db/interface/database_crud.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:sqflite/sqflite.dart';

final Map<int, String> _sqliteErrors = {2067: "Already exists"};

class SqliteRepo<Model extends DatabaseModel,
        ModelParam extends DatabaseParamModel>
    implements DatabaseCrud<Database, Model, ModelParam> {
  @override
  final DataStore<Database> store;
  @override
  final String tableName;

  ///Model Parse
  final Model Function(dynamic) parser;

  SqliteRepo(this.store, this.parser, this.tableName);

  final StreamController<DatabaseCrudOnAction<Model>> _action =
      StreamController.broadcast();

  @override
  Stream<DatabaseCrudOnAction<Model>> get onAction => _action.stream;

  bool useRef = false;

  String get query {
    return useRef ? refQuery : nonRefQuery;
  }

  String get nonRefQuery {
    return '''select * from "$tableName"''';
  }

  String get refQuery {
    return '''select * from "$tableName"''';
  }

  Future<Result> _completer<Result>(
    Future<Result> Function() callback,
    bool useRef,
  ) {
    this.useRef = useRef;
    return callback().whenComplete(() => this.useRef = false);
  }

  Future<Result<List<Model>>> findModels({
    int limit = 20,
    int offset = 0,
    String? where,
    bool useRef = false,
  }) {
    return _completer(
      () => find(limit: limit, offset: offset, where: where),
      useRef,
    );
  }

  @override
  Future<Result<List<Model>>> find({
    int limit = 20,
    int offset = 0,
    String? where,
  }) async {
    final result = await database
        .rawQuery("""$query ${where ?? ""} limit ?,?;""", [offset, limit]);
    if (result.isEmpty) {
      return Result(
        exception: Error(
          "Not Found",
          StackTrace.current,
        ),
      );
    }
    return Result(
      result: result.map(parser).toList(),
    );
  }

  Future<Result<Model>> getOne(int id, [bool useRef = false]) {
    return _completer(
      () => get(id),
      useRef,
    );
  }

  @override
  Future<Result<Model>> get(int id) async {
    final result = await database.rawQuery("""
          select * from "$tableName" where id=? limit 1;
        """, [id]);
    if (result.isEmpty) {
      return Result(
        exception: Error(
          "Not Found",
          StackTrace.current,
        ),
      );
    }
    return Result(
      result: parser(result.first),
    );
  }

  @override
  Future<Result<Model>> create(ModelParam values) async {
    /// table/column name = ""
    /// value = ''
    /// {
    ///     "name": "hello ${DateTime.now()}"
    /// }
    /// insert into tablename (col1,col2) values (val1,val2);
    final Map<String, dynamic> payload = values.toCreate();
    payload
        .addEntries({MapEntry("created_at", DateTime.now().toIso8601String())});
    final insertColumns = payload.keys.join(",");
    final insertValues = payload.values.map((e) => "'$e'").join(",");
    try {
      final insertedId = await database.rawInsert("""
      insert into "$tableName" ($insertColumns) values ($insertValues);
    """);
      final model = await get(insertedId);
      _action.sink.add(DatabaseCrudOnAction(
        model: model,
        action: DatabaseCrudAction.create,
      ));

      return model;
    } on DatabaseException catch (e) {
      return Result(
          exception: Error(_sqliteErrors[e.getResultCode()] ?? "Unknown Error",
              StackTrace.current));
    } catch (e) {
      return Result(exception: Error(e.toString(), StackTrace.current));
    }
  }

  @override
  Future<Result<Model>> update(int id, ModelParam values) async {
    final Map<String, dynamic> payload = values.toUpdate();
    payload
        .addEntries({MapEntry("updated_at", DateTime.now().toIso8601String())});

    /// update table set col1='val1',col2='val2' where id = ?
    final dataSet = payload.keys.map((column) {
      return "$column = '${payload[column]}'";
    }).join(',');
    final effectedRows = await database.rawUpdate("""
      update "$tableName" set $dataSet where id = ?;
    """, [id]);

    if (effectedRows < 1) {
      return Result(
        exception: Error(
          "Failed to update.",
          StackTrace.current,
        ),
      );
    }

    final model = await get(id);
    _action.sink.add(DatabaseCrudOnAction(
      model: model,
      action: DatabaseCrudAction.update,
    ));

    return model;
  }

  @override
  Future<Result<Model>> delete(int id) async {
    final model = await get(id);
    final effectedRows = await database
        .rawDelete("""delete from "$tableName" where id=?""", [id]);
    if (effectedRows < 1) {
      return Result(
          exception: Error(
        "Failed to delete.",
        StackTrace.current,
      ));
    }
    _action.sink.add(DatabaseCrudOnAction(
      model: model,
      action: DatabaseCrudAction.delete,
    ));
    return model;
  }

  @override
  Database get database => store.database!;
}
