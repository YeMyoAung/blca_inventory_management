import 'dart:convert';

import 'package:inventory_management_with_sql/core/db/interface/curd_model.dart';

class Category {
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

class CategoryParams implements DatabaseModel {
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
