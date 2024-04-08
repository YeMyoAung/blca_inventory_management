import 'package:inventory_management_with_sql/core/db/interface/database_crud.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_interface.dart';
import 'package:inventory_management_with_sql/core/db/utils/const.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:sqflite/sqflite.dart';

class SqliteCategoryRepo
    implements DatabaseCrud<Database, Category, CategoryParams> {
  @override
  final DataStore<Database> store;
  @override
  final String tableName;

  const SqliteCategoryRepo(this.store) : tableName = categoryTb;

  @override
  Future<List<Category>> find({
    int limit = 20,
    int offset = 0,
    String? where,
  }) async {
    final result = await database.rawQuery("""
          select * from "$tableName" ${where ?? ""} limit ?,?;
        """, [offset, limit]);
    if (result.isEmpty) return [];
    return result.map(Category.fromJson).toList();
  }

  @override
  Future<Category?> get(int id) async {
    final result = await database.rawQuery("""
          select * from "$tableName" where id=? limit 1;
        """, [id]);
    if (result.isEmpty) return null;
    return Category.fromJson(result.first);
  }

  @override
  Future<Category?> create(CategoryParams values) async {
    /// table/column name = ""
    /// value = ''
    /// {
    ///     "name": "hello ${DateTime.now()}"
    /// }
    /// insert into tablename (col1,col2) values (val1,val2);
    final Map<String, dynamic> payload = values.toCreate();
    payload
        .addEntries({MapEntry("created_at", DateTime.now().toIso8601String())});
    final insertColumns = payload.keys.join(",");
    final insertValues = payload.values.map((e) => "'$e'").join(",");
    final insertedId = await database.rawInsert("""
      insert into "$tableName" ($insertColumns) values ($insertValues);
    """);

    return get(insertedId);
  }

  @override
  Future<Category?> update(int id, CategoryParams values) async {
    final Map<String, dynamic> payload = values.toUpdate();
    payload
        .addEntries({MapEntry("updated_at", DateTime.now().toIso8601String())});

    /// update table set col1='val1',col2='val2' where id = ?
    final dataSet = payload.keys.map((column) {
      return "$column = '${payload[column]}'";
    }).join(',');
    final effectedRows = await database.rawUpdate("""
      update "$tableName" set $dataSet where id = ?;
    """, [id]);

    if (effectedRows < 1) return null;

    return get(id);
  }

  @override
  Future<Category?> delete(int id) async {
    final category = await get(id);
    if (category == null) return null;
    final effectedRows = await database
        .rawDelete("""delete from "$tableName" where id=?""", [id]);
    if (effectedRows < 1) return null;
    return category;
  }

  @override
  Database get database => store.database!;
}
