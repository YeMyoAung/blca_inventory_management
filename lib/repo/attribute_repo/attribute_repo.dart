import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_repo.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/repo/attribute_repo/attribute_entity.dart';

class SqliteAttributeRepo extends SqliteRepo<Attribute, AttributeParam> {
  SqliteAttributeRepo(SqliteDatabase store)
      : super(store, Attribute.fromJson, attributeTb);
}
