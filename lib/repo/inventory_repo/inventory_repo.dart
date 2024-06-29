import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_repo.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_entity.dart';

class SqliteInventoryRepo extends SqliteRepo<Inventory, InventoryParam> {
  SqliteInventoryRepo(SqliteDatabase store)
      : super(store, Inventory.fromJson, inventoryTb);

  @override
  String get refQuery => """
  SELECT $tableName.*,$productTb.name,$variantTb.sku,$productTb.barcode
  FROM $tableName
  JOIN $variantTb ON $variantTb.id=$tableName.variant_id
  JOIN $productTb ON $variantTb.product_id=$productTb.id
""";
}
