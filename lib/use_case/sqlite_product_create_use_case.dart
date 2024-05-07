import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';

abstract class ProductCreateUseCase {
  const ProductCreateUseCase();
  Future<Result<Product>> createNoneVariantProduct(
    ProductParams product,
    VariantParam variant,
  );
}

class SqliteProductCreateUseCase extends ProductCreateUseCase {
  final SqliteProductRepo productRepo;
  final SqliteVariantRepo variantRepo;

  const SqliteProductCreateUseCase({
    required this.productRepo,
    required this.variantRepo,
  });

  @override
  Future<Result<Product>> createNoneVariantProduct(
    ProductParams product,
    VariantParam variant,
  ) async {
    final productResult = await productRepo.create(product);
    if (productResult.hasError) {
      return productResult;
    }
    final id = productResult.result!.id;
    variant.productID = id;
    final variantResult = await variantRepo.create(variant);
    if (variantResult.hasError) {
      final deleteResult = await productRepo.delete(id);
      if (deleteResult.hasError) {
        return Result(exception: deleteResult.exception);
      }
      return Result(exception: variantResult.exception);
    }
    //category,variant
    return productRepo.getOne(id, true);
  }
}
