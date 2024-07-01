import 'package:inventory_management_with_sql/core/bloc/sqlite_read_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/attribute_repo/attribute_repo.dart';
import 'package:inventory_management_with_sql/repo/option_repo/option_repo.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_properties_repo/variant_property_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_product_detail_use_case.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_variant_detail_use_case.dart';

class ProductListBloc
    extends SqliteReadBloc<Product, VariantProductParams, SqliteProductRepo> {
  late final SqliteProductDetailUsecase detailUsecase;
  ProductListBloc(
    SqliteProductRepo repo,
    SqliteVariantRepo variantRepo,
    SqliteAttributeRepo attributeRepo,
    SqliteVariantPropertyRepo variantPropertyRepo,
    SqliteOptionRepo optionRepo,
  ) : super(repo, SqliteReadInitialState(<Product>[])) {
    detailUsecase = SqliteProductDetailUsecase(
      productRepo: repo,
      variantRepo: variantRepo,
      sqliteVariantPropertiesDetailUsecase:
          SqliteVariantPropertiesDetailUsecase(
        attributeRepo: attributeRepo,
        variantPropertyRepo: variantPropertyRepo,
        optionRepo: optionRepo,
      ),
      optionRepo: optionRepo,
      attributeRepo: attributeRepo,
    );
  }

  Future<Result<Product>> detail(int index) async {
    if (index > state.list.length) {
      return Result(exception: Error("Index out of bound"));
    }

    final product = await detailUsecase.execute(state.list[index].id);
    if (product.hasError) {
      return product;
    }

    state.list[index] = product.result!;
    return product;
  }
}
