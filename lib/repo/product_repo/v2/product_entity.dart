import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';

class Product extends DatabaseModel {
  final String name;
  final int categoryId;
  final String barcode;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ///ref
  final Category? category;

  ///TODO
  final List<Variant> variants;

  const Product({
    required super.id,
    required this.name,
    required this.categoryId,
    required this.barcode,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.variants,
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
      description: data['description'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.tryParse(data['updated_at'].toString()),
      category: categoryPayload == null
          ? null
          : Category.fromJson(
              categoryPayload,
            ),

      ///TODO
      variants: [],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "category_id": categoryId,
      "barcode": barcode,
      "description": description,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
      "category": category?.toJson(),
      "variants": variants.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductParams extends DatabaseParamModel {
  final String name;
  final String coverPhoto;
  final int categoryId;
  final String barcode;
  final String description;

  const ProductParams._({
    required this.name,
    required this.coverPhoto,
    required this.categoryId,
    required this.barcode,
    required this.description,
  });

  factory ProductParams.toCreate({
    required String name,
    required int categoryId,
    required String coverPhoto,
    required String barcode,
    String description = "",
  }) {
    return ProductParams._(
      name: name,
      categoryId: categoryId,
      barcode: barcode,
      coverPhoto: coverPhoto,
      description: description,
    );
  }

  factory ProductParams.toUpdate({
    String? name,
    int? categoryId,
    String? barcode,
    String? description,
    String? coverPhoto,
  }) {
    return ProductParams._(
      name: name ?? "",
      categoryId: categoryId ?? -1,
      barcode: barcode ?? "",
      description: description ?? "",
      coverPhoto: coverPhoto ?? "",
    );
  }

  @override
  Map<String, dynamic> toCreate() {
    return {
      "name": name,
      "category_id": categoryId,
      "barcode": barcode,
      "description": description,
      "cover_photo": coverPhoto,
    };
  }

  @override
  Map<String, dynamic> toUpdate() {
    assert(name.isNotEmpty || categoryId > 0 || barcode.isNotEmpty);
    final Map<String, dynamic> payload = {};

    if (name.isNotEmpty) payload['name'] = name;
    if (categoryId > 0) payload['category_id'] = categoryId;
    if (barcode.isNotEmpty) payload['barcode'] = barcode;
    if (description.isNotEmpty) payload['description'] = description;
    if (coverPhoto.isNotEmpty) payload['cover_photo'] = coverPhoto;
    return payload;
  }
}

class VariantProductParams extends DatabaseParamModel {
  final ProductParams _product;
  final List<VariantParam> variant;

  String get name => _product.name;
  String get coverPhoto => _product.coverPhoto;
  int get categoryId => _product.categoryId;
  String get barcode => _product.barcode;
  String get description => _product.description;

  const VariantProductParams({
    required ProductParams product,
    required this.variant,
  }) : _product = product;

  @override
  Map<String, dynamic> toCreate() {
    return _product.toCreate();
  }

  @override
  Map<String, dynamic> toUpdate() {
    return _product.toUpdate();
  }

  ///TODO
  ///generate variant properties
}
