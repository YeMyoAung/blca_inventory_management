import 'dart:async';

import 'package:inventory_management_with_sql/core/db/impl/sqlite_use_case.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';

class SqliteCategoryCreateUseCase
    extends SqliteCreateUseCase<Category, CategoryParams> {
  final SqliteCategoryRepo categoryRepo;

  const SqliteCategoryCreateUseCase({required this.categoryRepo});

  @override
  FutureOr<Result<Category>> create(CategoryParams param) {
    return categoryRepo.create(param);
  }
}
