import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_repo.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/repo/option_repo/option_entity.dart';

class SqliteOptionRepo extends SqliteRepo<Option, OptionParam> {
  SqliteOptionRepo(SqliteDatabase store)
      : super(
          store,
          Option.fromJson,
          optionTb,
        );
}
