import 'package:inventory_management_with_sql/core/db/impl/inventory_migration.dart';
import 'package:inventory_management_with_sql/core/db/impl/shop_migration.dart';
import 'package:inventory_management_with_sql/core/db/interface/table.dart';

const String shopDbName = "shop_store";

const String categoryTb = "categories",
    productTb = "products",
    optionTb = "options",
    attributeTb = "attributes",
    variantTb = "variants",
    variantPropertiesTb = "variant_properties",
    inventoryTb = "inventories",
    shopTb = "shops";

final SqliteShopMigrationV1 _shopMigrationV1 = SqliteShopMigrationV1();

Map<int, Map<String, List<TableProperties>>> get shopTableColumns => {
      1: _shopMigrationV1.table,
    };

final SqliteInventoryMigrationV1 _inventoryMigrationV1 =
    SqliteInventoryMigrationV1();
final SqliteInventoryMigrationV2 _inventoryMigrationV2 =
    SqliteInventoryMigrationV2();
final SqliteInventoryMigrationV3 _inventoryMigrationV3 =
    SqliteInventoryMigrationV3();

Map<int, Map<String, List<TableProperties>>>
    get inventoryMangementTableColumns => {
          1: _inventoryMigrationV1.table,
          2: _inventoryMigrationV2.table,
          3: _inventoryMigrationV3.table,
        };
