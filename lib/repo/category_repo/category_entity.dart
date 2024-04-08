import 'dart:convert';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

class Category implements DatabaseModel {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Category({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(dynamic data) {
    return Category(
      id: int.parse(data['id'].toString()),
      name: data['name'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.tryParse(data['updated_at'] ?? ''),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}

class CategoryParams implements DatabaseParamModel {
  final String name;

  const CategoryParams._({required this.name});

  factory CategoryParams.create({required String name}) {
    return CategoryParams._(name: name);
  }

  factory CategoryParams.update({String? name}) {
    return CategoryParams._(name: name ?? "");
  }

  @override
  Map<String, dynamic> toCreate() {
    return {"name": name};
  }

  @override
  Map<String, dynamic> toUpdate() {
    final Map<String, dynamic> data = {};
    if (name.isNotEmpty) data['name'] = name;
    return data;
  }
}

// class ProductParams implements DatabaseParamModel {
//   final String name;
//   final String photo;
//   final String? category;
//   final double price;
//   final int qty;

//   @override
//   Map<String, dynamic> toCreate() {
//     return {
//       ///columnName:value
//       "name": name,
//       "photo": photo,
//       "category": category,
//       "price": price,
//       "qty": qty,
//     };
//   }

//   @override
//   Map<String, dynamic> toUpdate() {
//     final Map<String, dynamic> data = {};
//     if (name.isNotEmpty) data['name'] = name;
//     if (photo.isNotEmpty) data['photo'] = photo;
//     if (category == null || category?.isNotEmpty == true) {
//       data['category'] = category;
//     }
//     if (price > 0) data['price'] = price;
//     if (qty > 0) data['qty'] = qty;
//     return data;
//   }
// }
