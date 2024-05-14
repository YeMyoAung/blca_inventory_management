import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_repo.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/repo/value_repo/value_entity.dart';

class SqliteValueRepo extends SqliteRepo<Value, ValueParam> {
  SqliteValueRepo(SqliteDatabase store)
      : super(
          store,
          Value.fromJson,
          valueTb,
        );
}
