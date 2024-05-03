import 'package:inventory_management_with_sql/core/bloc/sqlite_create_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_form.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';

class CreateNewProductBloc extends SqliteCreateBloc<Product, ProductParams,
    SqliteProductRepo, CreateNewProductForm> {
  ///Product Photo
  CreateNewProductBloc(super.form, super.repo);
}
