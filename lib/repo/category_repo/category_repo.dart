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
  Future<List<Category>> find([int limit = 20, int offset = 0]) async {
    final result = await database.rawQuery("""
          select * from "$tableName" limit $offset,$limit
        """);
    if (result.isEmpty) return [];
    return result.map(Category.fromJson).toList();
  }

  @override
  Future<Category?> get(int id) async {
    final result = await database.rawQuery("""
          select * from "$tableName" where id=$id limit 1
        """);
    if (result.isEmpty) return null;
    return Category.fromJson(result.first);
  }

  @override
  Future<Category?> create(CategoryParams values) async {
    /// table/column name = ""
    /// value = ''
    final payload = values.toCreate();
    payload
        .addEntries({MapEntry("created_at", DateTime.now().toIso8601String())});
    final insertedId = await database.rawInsert("""
      insert into "$tableName" (${payload.keys.join(",")}) values (${payload.values.map((e) => "'$e'").join(",")});
    """);

    return get(insertedId);
  }

  @override
  Future<Category?> delete() {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<Category?> update(int id, CategoryParams values) async {
    final payload = values.toUpdate();
    payload
        .addEntries({MapEntry("updated_at", DateTime.now().toIso8601String())});
    final dataSet = payload.keys.map((column) {
      return "$column = '${payload[column]}'";
    }).join(',');
    final updatedIdId = await database.rawInsert("""
      update "$tableName" set $dataSet where id = $id;
    """);

    return get(updatedIdId);
  }

  @override
  Database get database => store.database!;
}
