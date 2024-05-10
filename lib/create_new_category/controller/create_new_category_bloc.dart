import 'package:inventory_management_with_sql/core/bloc/sqlite_create_bloc.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_form.dart';
import 'package:inventory_management_with_sql/create_new_category/use_case/sqlite_create_new_category_use_case.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';

class CreateNewCategoryBloc extends SqliteCreateBloc<Category, CategoryParams,
    SqliteCategoryCreateUseCase, CreateNewCategoryForm> {
  CreateNewCategoryBloc(super.form, super.repo);
}
