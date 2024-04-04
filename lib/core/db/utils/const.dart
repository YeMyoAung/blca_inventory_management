import 'package:inventory_management_with_sql/core/db/interface/table.dart';

const String categoryTb = "categories",
    productTb = "products",
    optionTb = "options",
    valueTb = "values",
    variantTb = "variants",
    variantPropertiesTb = "variant_properties",
    inventoryTb = "inventories";

const List<String> tableNames = [
  //categories
  categoryTb,
  //products
  productTb,
  //options
  optionTb,
  //values
  valueTb,
  //variants
  variantTb,
  // variant_properties
  variantPropertiesTb,
  //inventories
  inventoryTb
];

const Map<String, List<TableProperties>> tableColumns = {
  categoryTb: [
    TableColumn(
      name: "name",
      type: "varchar",
      options: "not null unique",
    )
  ],
  productTb: [
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
    TableColumn(name: "product_id", type: "integer", options: "not null"),
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
};
