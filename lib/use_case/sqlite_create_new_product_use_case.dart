import 'package:inventory_management_with_sql/core/db/impl/sqlite_use_case.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/repo/attribute_repo/attribute_repo.dart';
import 'package:inventory_management_with_sql/repo/option_repo/option_repo.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';

class SqliteCreateNewProductUseCase
    extends SqliteCreateUseCase<Product, VariantProductParams> {
  final SqliteProductRepo productRepo;
  final SqliteVariantRepo variantRepo;
  final SqliteOptionRepo optionRepo;
  final SqliteAttributeRepo attributeRepo;

  const SqliteCreateNewProductUseCase({
    required this.productRepo,
    required this.variantRepo,
    required this.optionRepo,
    required this.attributeRepo,
  });

  @override
  Future<Result<Product>> create(
    VariantProductParams param,
  ) async {
    final barcode = param.barcode;
    if (barcode.isNotEmpty == true) {
      final isBarcodeAreadyExits = await productRepo.findModels(
        where: "where \"$productTb\".\"barcode\"='$barcode'",
      );

      if (!isBarcodeAreadyExits.hasError) {
        return Result(
          exception: Error(
            "Barcode already exist with Product ID:${isBarcodeAreadyExits.result?.first.id}",
          ),
        );
      }
    }

    final skus = param.variant.where(
      (element) => element.sku.isNotEmpty,
    );
    if (skus.isNotEmpty) {
      final isSkuAreadyExits = await variantRepo.findModels(
        where: "where \"$variantTb\".\"sku\" in '${skus.toList()}'",
      );

      if (!isSkuAreadyExits.hasError) {
        return Result(
          exception: Error(
            "Sku already exist with Variant ID:${isSkuAreadyExits.result?.first.id}",
          ),
        );
      }
    }

    final productCreateResult = await productRepo.create(param);
    if (productCreateResult.hasError) {
      logger.t("Product Create Error $productCreateResult");
      return productCreateResult;
    }

    final id = productCreateResult.result!.id;

    ///1. vairant count > 1 ? {
    /// . 1. Option  (product_id) color,size,package  ToParam()
    /// . 2. Value   (option_id) (red,green,blue,black,white),(s,m,l,xl,xxl),  ToParam(),(1star,2start,3start,4start,5start)//5*5*5 = 125  ToParam()
    /// . 3. Variant (product_id) [] * 125, ToParam(),
    /// . 4. Variant Properties (variant_id,value_id)  ToParam(), [[1,2],[2,1],[2,3]]
    ///}: create variant
    
    

    final variantCreateResult = await Future.wait(param.variant.map((e) {
      e.productID = id;
      return variantRepo.create(e);
    }));
    final errors = variantCreateResult.where((element) => element.hasError);
    if (errors.isNotEmpty) {
      logger.t("Variant Create Error $variantCreateResult");
      final deleteResult = await productRepo.delete(id);
      if (deleteResult.hasError) {
        logger.t("Product Delete Error $deleteResult");
        return Result(exception: deleteResult.exception);
      }
      final variantDeleteResult =
          await variantRepo.deleteWhere("\"product_id\"='$id'");
      if (variantDeleteResult.hasError) {
        logger.t("Variant Delete Error $variantDeleteResult");
        return Result(exception: variantDeleteResult.exception);
      }
      return Result(exception: errors.first.exception);
    }
    //category,variant
    final productFetchResult = await productRepo.getOne(id, true);
    if (productFetchResult.hasError) {
      logger.t("Product Fetch Error $productFetchResult");

      return productFetchResult;
    }
    productFetchResult.result!.variants.addAll(
      variantCreateResult.map((e) => e.result!),
    );
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
