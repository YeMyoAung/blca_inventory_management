import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_repo.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';

class SqliteCategoryRepo extends SqliteRepo<Category, CategoryParams> {
  SqliteCategoryRepo(SqliteDatabase store)
      : super(store, Category.fromJson, categoryTb);

  @override
  String get refQuery {
    return '''
      select "$tableName".*,
      (select count("$productTb"."id") from "$productTb" where "$productTb"."category_id"="$tableName"."id") as product_count 
      from "$tableName"
    ''';
  }
}
