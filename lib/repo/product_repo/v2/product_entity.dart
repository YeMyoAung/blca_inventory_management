import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_form.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_form.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/option_repo/option_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';

class Product extends DatabaseModel {
  final String name;
  final String coverPhoto;
  final int categoryId;
  final String barcode;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ///ref
  final Category? category;

  final List<Variant> variants;
  final List<Option> options;

  List<CreateNewVariantForm> get variantForm => variants
      .map(
        (e) => CreateNewVariantForm.form(
          coverPhoto: e.coverPhoto,
          sku: e.sku,
          price: e.price.toString(),
          available: e.available.toString(),
          damage: e.damage.toString(),
          onHand: e.onHand.toString(),
          lost: e.lost.toString(),
          allowPurchaseWhenOutOfStock: e.allowPurchaseWhenOutOfStock,
          isVariant: variants.length > 1,
          propertiesString: e.properties.map((e) => e.attributeName).join("-"),
        ),
      )
      .toList();

  Map<int, SetOptionValueForm> get propertiesForm {
    /// varint 3
    /// Color red,green
    /// Size  x,xl
    /// red x, red xl,green x, green xl

    final Map<int, SetOptionValueForm> form = {};
    int count = 1;
    for (final option in options) {
      form[count] = SetOptionValueForm(
        form: [
          Field.textEditingController(text: option.name),
          ...option.attributes
              .map((e) => Field.textEditingController(text: e.name)),
        ],
        id: option.id,
      );
      count++;
    }

    return form;
  }

  const Product({
    required super.id,
    required this.name,
    required this.coverPhoto,
    required this.categoryId,
    required this.barcode,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
    required this.variants,
    required this.options,
  });

  factory Product.fromJson(dynamic data) {
    logger.e("Product.From $data");
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
      coverPhoto: data['cover_photo'] ?? '',
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
      variants: [],
      options: [],
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
