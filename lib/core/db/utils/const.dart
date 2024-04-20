import 'package:inventory_management_with_sql/core/db/interface/table.dart';

const String shopDbName = "shop_store";

const String categoryTb = "categories",
    productTb = "products",
    optionTb = "options",
    valueTb = "values",
    variantTb = "variants",
    variantPropertiesTb = "variant_properties",
    inventoryTb = "inventories",
    shopTb = "shops";

// const Map<int, List<String>> tableNames = {
//   1: [
//     //categories
//     categoryTb,
//     //products
//     productTb,
//     //options
//     optionTb,
//     //values
//     valueTb,
//     //variants
//     variantTb,
//     // variant_properties
//     variantPropertiesTb,
//     //inventories
//     inventoryTb,
//     //shopTb
//     shopTb,
//   ]
// };

const Map<int, Map<String, List<TableProperties>>> shopTableColumns = {
  1: {
    shopTb: [
      TableColumn(
        name: "name",
        type: "varchar",
      ),
      TableColumn(
        name: "cover_photo",
        type: "varchar",
      )
    ]
  }
};

const Map<int, Map<String, List<TableProperties>>>
    inventoryMangementTableColumns = {
  1: {
    categoryTb: [
      TableColumn(
        name: "name",
        type: "varchar",
        options: "not null unique",
      ),
      TableColumn(
        name: "cover_photo",
        type: "varchar",
      )
    ],
    productTb: [
      TableColumn(
        name: "cover_photo",
        type: "varchar",
      ),
      TableColumn(
        name: "name",
        type: "varchar",
        options: "not null",
      ),
      TableColumn(
        name: "category_id",
        type: "integer",
        options: "not null",
      ),
      TableColumn(
        name: "barcode",
        type: "varchar",
        options: "unique",
      ),
    ],
    optionTb: [
      TableColumn(
        name: "name",
        type: "varchar",
        options: "not null",
      ),
      TableColumn(
        name: "product_id",
        type: "integer",
        options: "not null",
      )
    ],
    valueTb: [
      TableColumn(
        name: "name",
        type: "varchar",
        options: "not null",
      ),
      TableColumn(
        name: "option_id",
        type: "integer",
        options: "not null",
      )
    ],
    variantTb: [
      TableColumn(
        name: "product_id",
        type: "integer",
        options: "not null",
      ),
      TableColumn(
        name: "cover_photo",
        type: "varchar",
      ),
      TableColumn(
        name: "sku",
        type: "varchar",
        options: "not null unique",
      ),
      TableColumn(
        name: "price",
        type: "NUMERIC",
        options: "default 0",
      ),
      TableColumn(
        name: "on_hand",
        type: "NUMERIC",
        options: "default 0",
      ),
      TableColumn(
        name: "damange",
        type: "NUMERIC",
        options: "default 0",
      ),
      TableColumn(
        name: "lost",
        type: "NUMERIC",
        options: "default 0",
      ),
    ],
    variantPropertiesTb: [
      TableColumn(
        name: "variant_id",
        type: "integer",
        options: "not null",
      ),
      TableColumn(
        name: "value_id",
        type: "integer",
        options: "not null",
      )
    ],
    inventoryTb: [
      TableColumn(
        name: "variant_id",
        type: "integer",
        options: "not null",
      ),
      TableColumn(
        name: "reason",
        type: "text",
        options: "not null",
      ),
      TableColumn(
        name: "quantity",
        type: "NUMERIC",
        options: "default 0",
      ),
      TableColumn(
        name: "description",
        type: "text",
      )
    ]
  },
};
