import 'dart:async';

import 'package:inventory_management_with_sql/core/db/interface/database_crud.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:sqflite/sqflite.dart';

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

  final StreamController<DatabaseCrudOnChange<Model>> _onchange =
      StreamController.broadcast();

  @override
  Stream<DatabaseCrudOnChange<Model>> get onChange => _onchange.stream;

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

  Future<List<Model>> findModels({
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
  Future<List<Model>> find({
    int limit = 20,
    int offset = 0,
    String? where,
  }) async {
    final result = await database
        .rawQuery("""$query ${where ?? ""} limit ?,?;""", [offset, limit]);
    if (result.isEmpty) return [];
    return result.map(parser).toList();
  }

  Future<Model?> getOne(int id, [bool useRef = false]) {
    return _completer(
      () => get(id),
      useRef,
    );
  }

  @override
  Future<Model?> get(int id) async {
    final result = await database.rawQuery("""
          select * from "$tableName" where id=? limit 1;
        """, [id]);
    if (result.isEmpty) return null;
    return parser(result.first);
  }

  @override
  Future<Model?> create(ModelParam values) async {
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
    final insertedId = await database.rawInsert("""
      insert into "$tableName" ($insertColumns) values ($insertValues);
    """);

    final model = await get(insertedId);
    if (model != null) {
      _onchange.sink.add(DatabaseCrudOnChange(
        model: model,
        operation: CreateOperation(),
      ));
    }

    return model;
  }

  @override
  Future<Model?> update(int id, ModelParam values) async {
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

    if (effectedRows < 1) return null;

    final model = await get(id);
    if (model != null) {
      _onchange.sink.add(DatabaseCrudOnChange(
        model: model,
        operation: UpdateOperation(),
      ));
    }

    return model;
  }

  @override
  Future<Model?> delete(int id) async {
    final model = await get(id);
    if (model == null) return null;
    final effectedRows = await database
        .rawDelete("""delete from "$tableName" where id=?""", [id]);
    if (effectedRows < 1) return null;
    _onchange.sink.add(DatabaseCrudOnChange(
      model: model,
      operation: DeleteOperation(),
    ));
    return model;
  }

  @override
  Database get database => store.database!;
}
