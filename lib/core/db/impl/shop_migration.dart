import 'package:inventory_management_with_sql/core/db/interface/database_migration.dart';
import 'package:inventory_management_with_sql/core/db/interface/table.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';

class SqliteShopMigrationV1 extends SqliteBaseMigration {
  SqliteShopMigrationV1()
      : super({
          shopTb: [
            const TableColumn(
              name: "name",
              type: "varchar",
            ),
            const TableColumn(
              name: "cover_photo",
              type: "varchar",
            )
          ]
        });

  @override
  Map<String, List<TableProperties>> get up => {};

  @override
  Map<String, List<TableProperties>> get down => {};
}
