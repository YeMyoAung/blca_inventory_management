import 'dart:convert';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

class VariantProperty extends DatabaseModel {
  final int variantId;
  final int valueId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  final int optionID;
  final String optionName, attributeName;

  const VariantProperty({
    required super.id,
    required this.variantId,
    required this.valueId,
    required this.createdAt,
    required this.updatedAt,
    this.optionID = -1,
    this.optionName = '',
    this.attributeName = '',
  });

  factory VariantProperty.fromJson(dynamic data) {
    return VariantProperty(
      id: int.parse(data['id'].toString()),
      variantId: int.parse(data['variant_id'].toString()),
      valueId: int.parse(data['value_id'].toString()),
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.tryParse(data['updated_at'] ?? ''),
      optionID: int.tryParse(data['option_id'].toString()) ?? -1,
      optionName: data['option_name'] ?? '',
      attributeName: data['attribute_name'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "variant_id": variantId,
      "value_id": valueId,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}

class VariantPropertyParam extends DatabaseParamModel {
  final int variantId;
  final int valueId;

  const VariantPropertyParam({
    required this.variantId,
    required this.valueId,
  });

  factory VariantPropertyParam.toCreate({
    required int variantId,
    required int valueId,
  }) {
    return VariantPropertyParam(
      variantId: variantId,
      valueId: valueId,
    );
  }

  factory VariantPropertyParam.toUpdate({int? valueId}) {
    return VariantPropertyParam(
      valueId: valueId ?? -1,
      variantId: -1,
    );
  }

  @override
  Map<String, dynamic> toCreate() {
    return {
      "variant_id": variantId,
      "value_id": valueId,
    };
  }

  @override
  Map<String, dynamic> toUpdate() {
    if (valueId != -1) return {"value_id": valueId};
    return {};
  }
}
