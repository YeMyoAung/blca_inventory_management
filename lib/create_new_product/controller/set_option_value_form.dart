import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';

class SetOptionValueForm extends FormGroup {
  @override
  final int? id;
  @override

  /// index 0 = option name
  /// index 1 or 1+ = attribute
  final List<Field<TextEditingController>> form;

  SetOptionValueForm({required this.form, this.id})
      : assert(form.length >= 2),
        super(id);

  factory SetOptionValueForm.instance() {
    return SetOptionValueForm(form: [
      Field.textEditingController(),// option
      Field.textEditingController(),// attribute
    ]);
  }

  void addNewAttribute() {
    form.add(Field.textEditingController());
  }

  void removeAttribute(int index) {
    form.removeAt(index);
  }

  @override
  dispose() {
    formKey = null;
    formDispose(form);
  }

  @override
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  @override
  Result<DatabaseParamModel> toParam() {
    // TODO: implement toParam
    throw UnimplementedError();
  }

  @override
  bool validate() {
    print(formKey?.currentState?.validate());
    return formKey?.currentState?.validate() ?? false;
  }
}
