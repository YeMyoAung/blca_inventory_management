import 'package:inventory_management_with_sql/core/db/impl/sqlite_use_case.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';

// abstract class ProductRelatedUseCase {
//   const ProductRelatedUseCase();
//   Future<Result<Product>> createNoneVariantProduct(VariantProductParams params);

//   Future<Result<Product>> getProductDetails(int id);
//   Future<Result<Product>> getProduct(int id);
//   Future<Result<List<Product>>> getProducts();
// }

class SqliteProductCreateUseCase
    extends SqliteCreateUseCase<Product, VariantProductParams> {
  final SqliteProductRepo productRepo;
  final SqliteVariantRepo variantRepo;

  const SqliteProductCreateUseCase({
    required this.productRepo,
    required this.variantRepo,
  });

  @override
  Future<Result<Product>> create(
    VariantProductParams param,
  ) async {
    final productCreateResult = await productRepo.create(param);
    if (productCreateResult.hasError) {
      return productCreateResult;
    }
    final id = productCreateResult.result!.id;
    param.variant.productID = id;
    final variantCreateResult = await variantRepo.create(param.variant);
    if (variantCreateResult.hasError) {
      final deleteResult = await productRepo.delete(id);
      if (deleteResult.hasError) {
        return Result(exception: deleteResult.exception);
      }
      return Result(exception: variantCreateResult.exception);
    }
    //category,variant
    final productFetchResult = await productRepo.getOne(id, true);
    if (productFetchResult.hasError) {
      return productFetchResult;
    }
    productFetchResult.result!.variants.add(variantCreateResult.result!);
    return productFetchResult;
  }

  Future<Result<List<Product>>> getProducts({
    int limit = 20,
    int offset = 0,
    String? where,
  }) {
    return productRepo.findModels(
      useRef: true,
      limit: limit,
      offset: offset,
      where: where,
    );
  }

  Future<Result<Product>> getProduct(int id) {
    return productRepo.getOne(id, true);
  }

  Future<Result<Product>> getProductDetails(int id) async {
    final productResult = await getProduct(id);
    if (productResult.hasError) {
      return productResult;
    }
    final varaintResult = await variantRepo.findModels(
      where: '"product_id"=\'$id\'',
    );
    if (varaintResult.hasError) {
      return Result(exception: varaintResult.exception);
    }
    productResult.result!.variants.addAll(varaintResult.result!);
    return productResult;
  }
}
