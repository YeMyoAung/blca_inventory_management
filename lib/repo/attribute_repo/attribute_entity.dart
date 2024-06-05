import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

class Attribute extends DatabaseModel {
  final String name;
  final int optionId;
  final DateTime createdAt;
  final DateTime? updatedAt;
  const Attribute({
    required super.id,
    required this.name,
    required this.optionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attribute.fromJson(dynamic data) {
    return Attribute(
      id: int.parse(data['id'].toString()),
      name: data['name'],
      optionId: int.parse(data['option_id'].toString()),
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.tryParse(data['updated_at'].toString()),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "option_id": optionId,
      "created_at": createdAt.toIso8601String(),
      "updated_at": updatedAt?.toIso8601String(),
    };
  }
}

class AttributeParam extends DatabaseParamModel {
  final String name;
  final int optionId;

  const AttributeParam._({required this.name, required this.optionId});

  factory AttributeParam.create({required String name, required int optionId}) {
    return AttributeParam._(name: name, optionId: optionId);
  }

  factory AttributeParam.update({String? name}) {
    return AttributeParam._(name: name ?? "", optionId: -1);
  }

  @override
  Map<String, dynamic> toCreate() {
    return {
      "name": name,
      "option_id": optionId,
    };
  }

  @override
  Map<String, dynamic> toUpdate() {
    if (name.isEmpty) return {};
    return {
      "name": name,
    };
  }
}
