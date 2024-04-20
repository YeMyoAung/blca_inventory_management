import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

abstract class _DatabaseCrudOperation {}

class CreateOperation implements _DatabaseCrudOperation {}

class UpdateOperation implements _DatabaseCrudOperation {}

class DeleteOperation implements _DatabaseCrudOperation {}

class DatabaseCrudOnChange<Model extends DatabaseModel> {
  final Model model;
  final _DatabaseCrudOperation operation;

  const DatabaseCrudOnChange({required this.model, required this.operation});
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

  Stream<DatabaseCrudOnChange<Model>> get onChange;

  const DatabaseCrud({
    required this.tableName,
    required this.store,
  });

  DatabaseType get database => store.database!;

  Future<List<Model>> find({int limit = 20, int offset = 0, String? where});
  Future<Model?> get(int id);
  Future<Model?> create(ModelParams values);
  Future<Model?> update(int id, ModelParams values);
  Future<Model?> delete(int id);
}
