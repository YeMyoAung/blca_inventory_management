import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';

class SetOptionValueForm extends FormGroup {
  @override

  /// index 0 = option name
  /// index 1 or 1+ = attribute
  final List<Field<TextEditingController>> form;

  SetOptionValueForm({required this.form}) : assert(form.length >= 2);

  factory SetOptionValueForm.instance() {
    return SetOptionValueForm(form: [
      Field.textEditingController(),
      Field.textEditingController(),
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
