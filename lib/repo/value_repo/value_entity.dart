import 'dart:convert';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

class Value extends DatabaseModel {
  final int optionId;
  final String name;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Value({
    required super.id,
    required this.optionId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Value.fromJson(dynamic data) {
    return Value(
      id: int.parse(data['id'].toString()),
      optionId: int.parse(data['option_id'].toString()),
      name: data['name'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.tryParse(data['updated_at'] ?? ''),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "option_id": optionId,
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

class ValueParam extends DatabaseParamModel {
  final int optionId;
  final String name;

  const ValueParam({
    required this.optionId,
    required this.name,
  });

  factory ValueParam.toCreate({
    required int productId,
    required String name,
  }) {
    return ValueParam(
      optionId: productId,
      name: name,
    );
  }

  factory ValueParam.toUpdate({String? name}) {
    return ValueParam(
      name: name ?? "",
      optionId: -1,
    );
  }

  @override
  Map<String, dynamic> toCreate() {
    return {
      "option_id": optionId,
      "name": name,
    };
  }

  @override
  Map<String, dynamic> toUpdate() {
    if (name.isNotEmpty) return {"name": name};
    return {};
  }
}
