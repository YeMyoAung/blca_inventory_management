import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SqliteDatabase database =
        SqliteDatabase.newInstance("hello_world", 1);
    final SqliteCategoryRepo productRepo = SqliteCategoryRepo(database);
    database.connect().then((value) async {
      // await productRepo
      //     .create(CategoryParams.create(name: "hello ${DateTime.now()}"));
      // final List<Category> product = await productRepo.find(limit: 5);
      // print(product);
      // final Category? product1 = await productRepo.delete(2);
      // print(product1);
      // final List<Category> result = await productRepo.find(limit: 5);
      // print(result);
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
