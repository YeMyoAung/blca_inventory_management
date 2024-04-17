import 'dart:convert';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';

class Product extends DatabaseModel {
  final int id;
  final String name;
  final int categoryId;
  final String barcode;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ///ref
  final Category? category;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.barcode,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  factory Product.fromJson(dynamic data) {
    Map<String, dynamic>? categoryPayload;
    final categoryId = int.parse(data['category_id'].toString());
    if (data['category_created_at'] != null) {
      categoryPayload = {};
      categoryPayload['id'] = categoryId;
      categoryPayload['name'] = data['category_name'];
      categoryPayload['created_at'] = data['category_created_at'];
      categoryPayload['updated_at'] = data['category_updated_at'];
    }
    return Product(
      id: int.parse(data['id'].toString()),
      name: data['name'],
      categoryId: categoryId,
      barcode: data['barcode'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.tryParse(data['updated_at'].toString()),
      category: categoryPayload == null
          ? null
          : Category.fromJson(
              categoryPayload,
            ),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category_id": categoryId,
      "barcode": barcode,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "category": category?.toJson(),
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}

class ProductParams extends DatabaseParamModel {
  final String name;
  final int categoryId;
  final String barcode;

  const ProductParams._({
    required this.name,
    required this.categoryId,
    required this.barcode,
  });

  factory ProductParams.toCreate({
    required String name,
    required int categoryId,
    required String barcode,
  }) {
    return ProductParams._(
      name: name,
      categoryId: categoryId,
      barcode: barcode,
    );
  }

  factory ProductParams.toUpdate({
    String? name,
    int? categoryId,
    String? barcode,
  }) {
    return ProductParams._(
      name: name ?? "",
      categoryId: categoryId ?? -1,
      barcode: barcode ?? "",
    );
  }

  @override
  Map<String, dynamic> toCreate() {
    return {
      "name": name,
      "category_id": categoryId,
      "barcode": barcode,
    };
  }

  @override
  Map<String, dynamic> toUpdate() {
    final Map<String, dynamic> payload = {};

    if (name.isNotEmpty) payload['name'] = name;
    if (categoryId > 0) payload['category_id'] = categoryId;
    if (barcode.isNotEmpty) payload['barcode'] = barcode;
    assert(payload.isNotEmpty);
    return payload;
  }
}
