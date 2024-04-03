///interface
abstract class DataStore {
  ///connection
  Future<void> connect();

  ///close
  Future<void> close();

  ///table create
  Future<void> onUp();

  ///table drop
  Future<void> onDown();
}

const List<String> tableNames = [
  //categories
  "categories",
  //products
  "products",
  //options
  "options",
  //values
  "values",
  //variants
  "variants",
  // variant_properties
  "variant_properties",
  //inventories
  "inventories"
];
