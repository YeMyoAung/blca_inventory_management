import 'package:inventory_management_with_sql/core/db/interface/database_migration.dart';
import 'package:inventory_management_with_sql/core/db/interface/table.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';

class SqliteInventoryMigration extends SqliteBaseMigration {
  SqliteInventoryMigration()
      : super({
          categoryTb: [
            const TableColumn(
              name: "name",
              type: "varchar",
              options: "not null unique",
            ),
            const TableColumn(
              name: "cover_photo",
              type: "varchar",
            )
          ],
          productTb: [
            const TableColumn(
              name: "cover_photo",
              type: "varchar",
            ),
            const TableColumn(
              name: "name",
              type: "varchar",
              options: "not null",
            ),
            const TableColumn(
              name: "category_id",
              type: "integer",
              options: "not null",
            ),
            const TableColumn(
              name: "barcode",
              type: "varchar",
            ),
          ],
          optionTb: [
            const TableColumn(
              name: "name",
              type: "varchar",
              options: "not null",
            ),
            const TableColumn(
              name: "product_id",
              type: "integer",
              options: "not null",
            )
          ],
          attributeTb: [
            const TableColumn(
              name: "name",
              type: "varchar",
              options: "not null",
            ),
            const TableColumn(
              name: "option_id",
              type: "integer",
              options: "not null",
            )
          ],
          variantTb: [
            const TableColumn(
              name: "product_id",
              type: "integer",
              options: "not null",
            ),
            const TableColumn(
              name: "cover_photo",
              type: "varchar",
            ),
            const TableColumn(
              name: "sku",
              type: "varchar",
            ),
            const TableColumn(
              name: "price",
              type: "NUMERIC",
              options: "default 0",
            ),
            const TableColumn(
              name: "available",
              type: "NUMERIC",
              options: "default 0",
            ),
            const TableColumn(
              name: "on_hand",
              type: "NUMERIC",
              options: "default 0",
            ),
            const TableColumn(
              name: "damage",
              type: "NUMERIC",
              options: "default 0",
            ),
            const TableColumn(
              name: "lost",
              type: "NUMERIC",
              options: "default 0",
            ),
          ],
          variantPropertiesTb: [
            const TableColumn(
              name: "variant_id",
              type: "integer",
              options: "not null",
            ),
            const TableColumn(
              name: "value_id",
              type: "integer",
              options: "not null",
            )
          ],
          inventoryTb: [
            const TableColumn(
              name: "variant_id",
              type: "integer",
              options: "not null",
            ),
            const TableColumn(
              name: "reason",
              type: "text",
              options: "not null",
            ),
            const TableColumn(
              name: "quantity",
              type: "NUMERIC",
              options: "default 0",
            ),
            const TableColumn(
              name: "description",
              type: "text",
            )
          ]
        });
  @override
  Map<String, List<TableProperties>> get up => {};
  @override
  Map<String, List<TableProperties>> get down => {};
}

class SqliteInventoryMigrationV1 extends SqliteInventoryMigration {
  SqliteInventoryMigrationV1();
  @override
  Map<String, List<TableProperties>> get down => {};

  @override
  Map<String, List<TableProperties>> get up => {};
}

class SqliteInventoryMigrationV2 extends SqliteInventoryMigration {
  SqliteInventoryMigrationV2();
  @override
  Map<String, List<TableProperties>> get down => {};

  @override
  Map<String, List<TableProperties>> get up => const {
        productTb: [
          TableColumn(
            name: "description",
            type: "varchar",
          ),
        ],
      };
}

class SqliteInventoryMigrationV3 extends SqliteInventoryMigration {
  @override
  Map<String, List<TableProperties>> get up => const {
        productTb: [
          TableColumn(name: "photo", type: "varchar"),
          TableColumn(name: "description", type: "varchar"),
        ],
        variantTb: [
          TableColumn(
            name: "allow_purchase_when_out_of_stock",
            type: "bool",
            options: "default false",
          ),
        ]
      };
}
