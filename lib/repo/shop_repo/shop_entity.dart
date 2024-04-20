import 'dart:convert';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

class Shop extends DatabaseModel {
  final int id;
  final String name, coverPhoto;

  const Shop({
    required this.id,
    required this.name,
    required this.coverPhoto,
  });

  factory Shop.fromJson(dynamic data) {
    return Shop(
      id: int.parse(data['id'].toString()),
      name: data['name'],
      coverPhoto: data['cover_photo'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "cover_photo": coverPhoto,
    };
  }

  @override
  String toString() {
    return json.encode(toJson());
  }
}

class ShopParam extends DatabaseParamModel {
  final String name, coverPhoto;
  const ShopParam._(
    this.name,
    this.coverPhoto,
  );

  factory ShopParam.toCreate({
    required String name,
    required String coverPhoto,
  }) {
    return ShopParam._(
      name,
      coverPhoto,
    );
  }

  factory ShopParam.toUpdate({
    String? name,
    String? coverPhoto,
  }) {
    return ShopParam._(
      name ?? "",
      coverPhoto ?? "",
    );
  }

  @override
  Map<String, dynamic> toCreate() {
    return {
      "name": name,
      "cover_photo": coverPhoto,
    };
  }

  @override
  Map<String, dynamic> toUpdate() {
    assert(name.isNotEmpty || coverPhoto.isNotEmpty);
    final Map<String, dynamic> payload = {};
    if (name.isNotEmpty) payload["name"] = name;
    if (coverPhoto.isNotEmpty) payload["cover_photo"] = coverPhoto;
    return payload;
  }
}
