import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_database.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';
import 'package:inventory_management_with_sql/repo/product_repo/product_repo.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final SqliteDatabase database =
        SqliteDatabase.newInstance("hello_world", 1);
    final SqliteCategoryRepo categoryRepo = SqliteCategoryRepo(database);
    final SqliteProductRepo productRepo = SqliteProductRepo(database);
    database.connect().then((value) async {
      // final category = await categoryRepo
      //     .create(CategoryParams.create(name: "hello ${DateTime.now()}"));
      // print(category);

      // final updated = await categoryRepo.update(
      //     category!.id, CategoryParams.update(name: "Hello World"));
      // print(updated);

      // final List<Category> category = await categoryRepo.find(limit: 5);
      // print(category);
      // final Category? category1 = await categoryRepo.delete(2);
      // print(category1);
      // final List<Category> categoryResult = await categoryRepo.find(limit: 5);
      // print(categoryResult);

      // final product = await productRepo.create(
      //   ProductParams.toCreate(
      //     name: "Category ${1} Product ${DateTime.now()}",
      //     categoryId: 1,
      //     barcode: DateTime.now().toIso8601String(),
      //   ),
      // );
      // print(product);
      // final productResult = await productRepo.findModels(limit: 1);
      // print(productResult);
      // print('_______________');
      // final productResultWithRef =
      //     await productRepo.findModels(limit: 1, useRef: true);
      // print(productResultWithRef);
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
