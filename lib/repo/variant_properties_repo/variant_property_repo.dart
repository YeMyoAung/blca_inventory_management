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

  @override
  String get refQuery =>
      """select 
      $tableName.*,
      $attributeTb.name as attribute_name,
      $optionTb.id as option_id,
      $optionTb.name as option_name
      from $tableName join $attributeTb on $tableName.value_id=$attributeTb.id join $optionTb on $attributeTb.option_id=$optionTb.id""";
}
