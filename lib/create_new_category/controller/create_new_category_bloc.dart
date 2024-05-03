import 'package:inventory_management_with_sql/core/bloc/sqlite_create_bloc.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_form.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';

class CreateNewCategoryBloc extends SqliteCreateBloc<Category, CategoryParams,
    SqliteCategoryRepo, CreateNewCategoryForm> {
  CreateNewCategoryBloc(super.form, super.repo);
}
