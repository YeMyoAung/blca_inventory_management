import 'dart:async';

import 'package:inventory_management_with_sql/core/bloc/sqlite_create_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_form.dart';
import 'package:inventory_management_with_sql/create_new_category/use_case/sqlite_create_new_category_use_case.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';

class CreateNewCategoryBloc extends SqliteExecuteBloc<Category, CategoryParams,
    SqliteCategoryExecuteUseCase, CreateNewCategoryForm, NullObject> {
  CreateNewCategoryBloc(super.form, super.repo);

  @override
  FutureOr<Result<Category>> onExecute(SqliteExecuteEvent<NullObject> event, CategoryParams param, [int? id]) {
    logger.i("Category ID: ${form.id}");
    return super.onExecute(event, param, id);
  }
}
