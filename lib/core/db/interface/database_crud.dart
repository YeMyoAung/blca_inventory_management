import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

/// static Pro = 1;

abstract class DatabaseCrud<DatabaseType, Model extends DatabaseModel,
    ModelParams extends DatabaseParamModel> {
  final DataStore<DatabaseType> store;
  final String tableName;

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
