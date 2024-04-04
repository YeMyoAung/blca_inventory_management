import 'package:inventory_management_with_sql/core/db/interface/curd_model.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';

abstract class DatabaseCrud<D, M, MP extends DatabaseModel> {
  final DataStore<D> store;
  final String tableName;

  const DatabaseCrud({
    required this.tableName,
    required this.store,
  });

  D get database => store.database!;

  Future<List<M>> find([int limit = 20, int offset = 0]);
  Future<M?> get(int id);
  Future<M?> create(MP values);
  Future<M?> update(int id, MP values);
  Future<M?> delete();
}
