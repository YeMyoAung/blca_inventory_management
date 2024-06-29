import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

class Inventory extends DatabaseModel {
  final int variantID;
  final String reason;
  final double quantity;
  final String description;
  final DateTime createdAt;
  final DateTime? updatedAt;

  final String name;
  final String sku;
  final String barcode;

  String variantName = 'NA';

  Inventory({
    required super.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.variantID,
    required this.reason,
    required this.quantity,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Inventory.fromJson(dynamic data) {
    return Inventory(
      id: int.parse(data['id'].toString()),
      variantID: int.parse(data['variant_id'].toString()),
      reason: data['reason'] ?? '',
      name: data['name'] ?? '',
      sku: data['sku'] ?? '',
      barcode: data['barcode'] ?? '',
      quantity: double.parse(data['quantity'].toString()),
      description: data['description'] ?? '',
      createdAt: DateTime.parse(data['created_at'].toString()),
      updatedAt: DateTime.tryParse(data['updated_at'].toString()),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "variant_id": variantID,
      "variant_name": variantName,
      "name": name,
      "sku": sku,
      "barcode": barcode,
      "reason": reason,
      "quantity": quantity,
      "description": description,
    };
  }
}

class InventoryParam extends DatabaseParamModel {
  final int variantID;
  final String reason;
  final double quantity;
  final String description;

  const InventoryParam._({
    required this.variantID,
    required this.reason,
    required this.quantity,
    required this.description,
  });

  factory InventoryParam.create({
    required int variantID,
    required String reason,
    required double quantity,
    required String description,
  }) {
    return InventoryParam._(
      variantID: variantID,
      reason: reason,
      quantity: quantity,
      description: description,
    );
  }

  factory InventoryParam.update({
    String reason = '',
    double quantity = -1,
    String description = '',
  }) {
    return InventoryParam._(
      variantID: -1,
      reason: reason,
      quantity: quantity,
      description: description,
    );
  }

  @override
  Map<String, dynamic> toCreate() {
    return {
      "variant_id": variantID,
      "reason": reason,
      "quantity": quantity,
      "description": description,
    };
  }

  @override
  Map<String, dynamic> toUpdate() {
    final Map<String, dynamic> payload = {};
    if (reason.isNotEmpty) payload['reason'] = reason;
    if (quantity != -1) payload['quantity'] = quantity;
    if (description.isNotEmpty) payload['description'] = description;
    return payload;
  }
}
