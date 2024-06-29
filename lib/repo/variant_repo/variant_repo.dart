import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_repo.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';

class SqliteVariantRepo extends SqliteRepo<Variant, VariantParam> {
  SqliteVariantRepo(SqliteDatabase store)
      : super(store, Variant.fromJson, variantTb);

  @override
  String get refQuery => """
  SELECT $tableName.*,$productTb.name,$productTb.barcode FROM $tableName
  JOIN $productTb on $tableName.product_id = $productTb.id
  """;
}
