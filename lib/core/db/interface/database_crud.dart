import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

// abstract class _DatabaseCrudOperation {}

// class CreateOperation implements _DatabaseCrudOperation {}

// class UpdateOperation implements _DatabaseCrudOperation {}

// class DeleteOperation implements _DatabaseCrudOperation {}

enum DatabaseCrudAction { create, update, delete }

class DatabaseCrudOnAction<Model extends DatabaseModel> {
  final Result<Model> model;
  final DatabaseCrudAction action;

  const DatabaseCrudOnAction({required this.model, required this.action});
}

abstract class WhereOperator {
  const WhereOperator();

  @override
  String toString();
}

const _sqlOperator = [
  "=",
  "!=",
  ">",
  ">=",
  "<",
  "<=",
  "in",
  "is null",
  "is not null",
  "like",
  "ilike"
];

class FieldValidator extends WhereOperator {
  final String columnName;

  final String operationSign;
  final String value;

  FieldValidator({
    required this.columnName,
    required this.operationSign,
    required this.value,
  }) : assert(
          _sqlOperator.contains(operationSign) &&
              ((value.isEmpty &&
                      (operationSign == "is null" ||
                          operationSign == "is not null")) ||
                  (value.isNotEmpty &&
                      (operationSign != "is null" &&
                          operationSign != "is not null"))),
        );

  @override
  String toString() {
    if (value.isEmpty) {
      return "$columnName $operationSign";
    }
    return "$columnName $operationSign '$value'";
  }
}

class AndOp extends WhereOperator {
  const AndOp();

  @override
  String toString() {
    return "and";
  }
}

class OrOp extends WhereOperator {
  const OrOp();

  @override
  String toString() {
    return "or";
  }
}

/// static Pro = 1;
/// bloc
///
/// Read Bloc, data read,delete
/// Write Bloc, create,update,delete
///
abstract class DatabaseCrud<DatabaseType, Model extends DatabaseModel,
    ModelParams extends DatabaseParamModel> {
  final DataStore<DatabaseType> store;
  final String tableName;

  Stream<DatabaseCrudOnAction<Model>> get onAction;

  const DatabaseCrud({
    required this.tableName,
    required this.store,
  });

  DatabaseType get database => store.database!;

  Future<int> count([String? where]);

  Future<Result<List<Model>>> find({
    int limit = 20,
    int offset = 0,
    String? where,
  });

  Future<Result<Model>> get(int id);

  Future<Result<Model>> create(ModelParams values);

  Future<Result<Model>> update(int id, ModelParams values);

  Future<Result<Model>> delete(int id);

  Future<Result<List<Model>>> bulkCreate(
    List<ModelParams> values,
    // String indexColumn,
    List<WhereOperator> Function(ModelParams param) afterCreate,
  );

  Future<Result<List<Model>>> deleteWhere(String condition);
}
