import 'package:inventory_management_with_sql/core/bloc/sqlite_read_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_repo.dart';

class CategoryListBloc
    extends SqliteReadBloc<Category, CategoryParams, SqliteCategoryRepo> {
  CategoryListBloc(
    SqliteCategoryRepo repo,
  ) : super(repo, SqliteReadInitialState(<Category>[]));
}
