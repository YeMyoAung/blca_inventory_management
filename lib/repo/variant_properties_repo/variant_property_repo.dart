import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_repo.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/repo/variant_properties_repo/variant_property_entity.dart';

class SqliteVariantPropertyRepo
    extends SqliteRepo<VaraintProperty, VariantPropertyParam> {
  SqliteVariantPropertyRepo(SqliteDatabase store)
      : super(
          store,
          VaraintProperty.fromJson,
          variantPropertiesTb,
        );
}
