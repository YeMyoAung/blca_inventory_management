import 'dart:convert';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

///Set Option Value
///Option Name
/// - Attribute Name 
/// {
///   option_name:"",
///   attribute_names:["","",""]  
/// }
class Option extends DatabaseModel {
  final int productId;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Option({
    required super.id,
    required this.productId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Option.fromJson(dynamic data) {
    return Option(
      id: int.parse(data['id'].toString()),
      productId: int.parse(data['product_id'].toString()),
      name: data['name'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.tryParse(data['updated_at'] ?? ''),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "product_id": productId,
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

class OptionParam extends DatabaseParamModel {
  final int productId;
  final String name;

  const OptionParam({
    required this.productId,
    required this.name,
  });

  factory OptionParam.toCreate({
    required int productId,
    required String name,
  }) {
    return OptionParam(
      productId: productId,
      name: name,
    );
  }

  factory OptionParam.toUpdate({String? name}) {
    return OptionParam(
      name: name ?? "",
      productId: -1,
    );
  }

  @override
  Map<String, dynamic> toCreate() {
    return {
      "product_id": productId,
      "name": name,
    };
  }

  @override
  Map<String, dynamic> toUpdate() {
    if (name.isNotEmpty) return {"name": name};
    return {};
  }
}
