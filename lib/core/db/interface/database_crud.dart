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

  Future<Result<List<Model>>> find(
      {int limit = 20, int offset = 0, String? where});
  Future<Result<Model>> get(int id);
  Future<Result<Model>> create(ModelParams values);
  Future<Result<Model>> update(int id, ModelParams values);
  Future<Result<Model>> delete(int id);
  Future<Result<List<Model>>> bulkCreate(
    List<ModelParams> values,
    String indexColumn,
    Function(ModelParams param) indexValue,
  );
}
