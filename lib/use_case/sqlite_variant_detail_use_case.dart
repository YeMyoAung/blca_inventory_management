import 'dart:async';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/attribute_repo/attribute_repo.dart';
import 'package:inventory_management_with_sql/repo/option_repo/option_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_properties_repo/variant_property_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_properties_repo/variant_property_repo.dart';

class SqliteVariantPropertiesDetailUsecase {
  final SqliteVariantPropertyRepo variantPropertyRepo;
  final SqliteAttributeRepo attributeRepo;
  final SqliteOptionRepo optionRepo;

  SqliteVariantPropertiesDetailUsecase({
    required this.variantPropertyRepo,
    required this.attributeRepo,
    required this.optionRepo,
  });

  final int limit = 100;

  FutureOr<Result<List<VariantProperty>>> execute(int id) async {
    final List<VariantProperty> properties = [];
    final where = "where variant_id=$id";
    final count = await variantPropertyRepo.count(where);

    for (int offset = 0; offset < count; offset += limit) {
      final propertiesResult = await variantPropertyRepo.findModels(
        where: where,
        limit: limit,
        offset: offset,
        useRef: true,
      );

      if (propertiesResult.hasError) {
        return Result(exception: propertiesResult.exception);
      }

      properties.addAll(propertiesResult.result ?? []);
    }

    return Result(
      result: properties,
    );
  }
}
