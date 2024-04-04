import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SqliteDatabase database = SqliteDatabase.newInstance("iv");
    final SqliteCategoryRepo productRepo = SqliteCategoryRepo(database);
    database.connect().then((value) async {
      final List<Category> product = await productRepo.find(5);
      print(product);
      final Category? product1 =
          await productRepo.update(1, CategoryParams.update());
      print(product1);
      final List<Category> result = await productRepo.find(5);
      print(result);
    });

    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}
