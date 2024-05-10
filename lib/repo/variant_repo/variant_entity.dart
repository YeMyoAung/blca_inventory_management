import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

class Variant extends DatabaseModel {
  final int productID;
  final String coverPhoto, sku;
  final double price, available, damage, onHand, lost;
  final bool allowPurchaseWhenOutOfStock;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Variant({
    required super.id,
    required this.productID,
    required this.coverPhoto,
    required this.sku,
    required this.price,
    required this.available,
    required this.damage,
    required this.onHand,
    required this.lost,
    required this.allowPurchaseWhenOutOfStock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Variant.fromJson(dynamic data) {
    return Variant(
      id: int.parse(data['id'].toString()),
      productID: int.parse(data['product_id'].toString()),
      coverPhoto: data['cover_photo'],
      sku: data['sku'].toString(),
      price: double.parse(data['price'].toString()),
      available: double.parse(data['available'].toString()),
      damage: double.parse(data['damage'].toString()),
      onHand: double.parse(data['on_hand'].toString()),
      lost: double.parse(data['lost'].toString()),
      allowPurchaseWhenOutOfStock:
          data['allow_purchase_when_out_of_stock'] == true,
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.tryParse(data['updated_at'] ?? ""),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "product_id": productID,
      "cover_photo": coverPhoto,
      "sku": sku,
      "price": price,
      "available": available,
      "damage": damage,
      "on_hand": onHand,
      "lost": lost,
      "allow_purchase_when_out_of_stock": allowPurchaseWhenOutOfStock,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}

class VariantParam extends DatabaseParamModel {
  int? productID;

  final String coverPhoto, sku;
  final double price, available, damage, onHand, lost;
  final bool? allowPurchaseWhenOutOfStock;

  VariantParam._({
    required this.coverPhoto,
    required this.sku,
    required this.price,
    required this.available,
    required this.damage,
    required this.onHand,
    required this.lost,
    required this.allowPurchaseWhenOutOfStock,
  });

  VariantParam.toCreate({
    required this.coverPhoto,
    required this.sku,
    required this.price,
    required this.available,
    required this.damage,
    required this.onHand,
    required this.lost,
    required this.allowPurchaseWhenOutOfStock,
  }) : assert(allowPurchaseWhenOutOfStock != null);

  VariantParam.toUpdate({
    this.coverPhoto = "",
    this.sku = "",
    this.price = -1,
    this.available = -1,
    this.damage = -1,
    this.onHand = -1,
    this.lost = -1,
    this.allowPurchaseWhenOutOfStock,
  }) : productID = -1;

  @override
  Map<String, dynamic> toCreate() {
    assert(productID != null);
    return {
      "product_id": productID,
      "cover_photo": coverPhoto,
      "sku": sku,
      "price": price,
      "available": available,
      "on_hand": onHand,
      "damage": damage,
      "lost": lost,
      "allow_purchase_when_out_of_stock": allowPurchaseWhenOutOfStock == true,
    };
  }

  @override
  Map<String, dynamic> toUpdate() {
    final Map<String, dynamic> payload = {};
    if (coverPhoto.isNotEmpty) {
      payload.addEntries({MapEntry("cover_photo", coverPhoto)});
    }
    if (sku.isNotEmpty) {
      payload.addEntries({MapEntry("sku", sku)});
    }
    if (price >= 0) {
      payload.addEntries({MapEntry("price", price)});
    }
    if (available >= 0) {
      payload.addEntries({MapEntry("available", available)});
    }
    if (onHand >= 0) {
      payload.addEntries({MapEntry("on_hand", onHand)});
    }
    if (damage >= 0) {
      payload.addEntries({MapEntry("damage", damage)});
    }
    if (lost >= 0) {
      payload.addEntries({MapEntry("lost", lost)});
    }
    if (allowPurchaseWhenOutOfStock != null) {
      payload.addEntries({
        MapEntry(
            "allow_purchase_when_out_of_stock", allowPurchaseWhenOutOfStock)
      });
    }
    return payload;
  }
}
