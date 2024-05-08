import 'package:inventory_management_with_sql/core/bloc/sqlite_read_bloc.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';

class ProductListBloc
    extends SqliteReadBloc<Product, VariantProductParams, SqliteProductRepo> {
  ProductListBloc(super.repo);
}
