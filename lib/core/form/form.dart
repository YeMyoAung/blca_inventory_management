import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';

abstract class FormGroup<T extends DatabaseParamModel> {
  final int? id;

  GlobalKey<FormState>? get formKey;

  const FormGroup([this.id]);

  bool validate();

  Result<T> toParam();

  List<Field> get form;

  dispose();
}
