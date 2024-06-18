import 'dart:async';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_variant_detail_use_case.dart';

class SqliteProductDetailUsecase {
  final SqliteProductRepo productRepo;
  final SqliteVariantRepo variantRepo;

  final SqliteVariantPropertiesDetailUsecase
      sqliteVariantPropertiesDetailUsecase;

  const SqliteProductDetailUsecase({
    required this.productRepo,
    required this.variantRepo,
    required this.sqliteVariantPropertiesDetailUsecase,
  });

  final int limit = 100;


  FutureOr<Result<Product>> execute(int id) async {
    final productResult = await productRepo.getOne(id, true);
    if (productResult.hasError) return productResult;
    final where = "where product_id=$id";
    final varaintCount = await variantRepo.count(where);

    for (int offset = 0; offset < varaintCount; offset += limit) {
      final variantResult = await variantRepo.findModels(
        where: where,
        limit: limit,
        offset: offset,
      );
      if (variantResult.hasError) {
        return Result(exception: variantResult.exception);
      }
      productResult.result?.variants.addAll(variantResult.result ?? []);
    }
    final List<Variant> variants = productResult.result?.variants ?? [];

    for (final variant in variants) {
      final properties =
          await sqliteVariantPropertiesDetailUsecase.execute(variant.id);

      if (properties.hasError) return Result(exception: properties.exception);
      variant.properties.addAll(properties.result ?? []);
    }

    logger.i(productResult);
    logger.i(productResult.result?.variants);
    for (final variant in productResult.result?.variants ?? []) {
      logger.i(variant.properties);
    }

    return productResult;
  }
}
