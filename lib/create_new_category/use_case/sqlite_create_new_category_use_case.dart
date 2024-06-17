import 'dart:async';

import 'package:inventory_management_with_sql/core/db/impl/sqlite_use_case.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';

class SqliteCategoryExecuteUseCase
    extends SqliteExecuteUseCase<Category, CategoryParams> {
  final SqliteCategoryRepo categoryRepo;

  const SqliteCategoryExecuteUseCase({required this.categoryRepo});

  @override
  FutureOr<Result<Category>> execute(CategoryParams param, [int? id]) {
    if (id == null) {
      return categoryRepo.create(param);
    }
    return categoryRepo.update(id, param);
  }
}
