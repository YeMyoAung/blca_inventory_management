import 'dart:async';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/repo/attribute_repo/attribute_entity.dart';
import 'package:inventory_management_with_sql/repo/attribute_repo/attribute_repo.dart';
import 'package:inventory_management_with_sql/repo/option_repo/option_entity.dart';
import 'package:inventory_management_with_sql/repo/option_repo/option_repo.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_variant_detail_use_case.dart';

class SqliteProductDetailUsecase {
  final SqliteProductRepo productRepo;
  final SqliteVariantRepo variantRepo;
  final SqliteOptionRepo optionRepo;
  final SqliteAttributeRepo attributeRepo;

  final SqliteVariantPropertiesDetailUsecase
      sqliteVariantPropertiesDetailUsecase;

  const SqliteProductDetailUsecase({
    required this.productRepo,
    required this.variantRepo,
    required this.sqliteVariantPropertiesDetailUsecase,
    required this.optionRepo,
    required this.attributeRepo,
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

    final optionQuery = "where product_id=$id";
    final optionCount = await optionRepo.count(optionQuery);

    final List<Option> options = [];

    for (int offset = 0; offset < optionCount; offset += limit) {
      final optionResult = await optionRepo.findModels(
        where: optionQuery,
        offset: offset,
        limit: limit,
      );
      if (optionResult.hasError) {
        return Result(exception: optionResult.exception);
      }
      options.addAll(optionResult.result ?? []);
    }

    final attributeQuery =
        "where option_id in (${options.map((e) => e.id).join(",")})";

    final attributeCount = await attributeRepo.count(attributeQuery);

    final List<Attribute> attributes = [];

    for (int offset = 0; offset < attributeCount; offset += limit) {
      final attributeResult = await attributeRepo.findModels(
        where: attributeQuery,
        offset: offset,
        limit: limit,
      );
      if (attributeResult.hasError) {
        return Result(exception: attributeResult.exception);
      }
      attributes.addAll(attributeResult.result ?? []);
    }

    logger.i(productResult);
    logger.i(productResult.result?.variants);
    for (final variant in productResult.result?.variants ?? []) {
      logger.i(variant.properties);
    }

    return productResult;
  }
}
