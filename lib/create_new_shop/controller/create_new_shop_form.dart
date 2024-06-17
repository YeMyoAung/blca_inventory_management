import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_entity.dart';

class ShopCreateForm extends FormGroup<ShopParam> {
  @override
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  final Field<TextEditingController> name;
  final Field<String> coverPhoto;

  @override
  final int? id;

  ShopCreateForm._({
    required this.name,
    required this.coverPhoto,
    this.id,
  }) : super(id);

  factory ShopCreateForm.form({
    String? name,
    String? coverPhoto,
    int? id,
  }) {
    return ShopCreateForm._(
      name: Field(
        input: TextEditingController(text: name),
        isRequired: false,
        dispose: (p0) => p0?.dispose(),
      ),
      coverPhoto: Field(
        input: coverPhoto,
        isValid: (p0) =>
            p0?.isNotEmpty == true ? null : "Cover photo is missing",
      ),
      id: id,
    );
  }

  @override
  List<Field> get form => [name, coverPhoto];

  @override
  Result<ShopParam> toParam() {
    final errorMessage = formIsValid(form);
    return errorMessage == null
        ? Result(
            result: ShopParam.toCreate(
              name: name.input!.text,
              coverPhoto: coverPhoto.input!,
            ),
          )
        : Result(
            exception: Error(errorMessage),
          );
  }

  @override
  bool validate() {
    return formKey?.currentState?.validate() == true;
  }

  @override
  dispose() {
    formKey = null;
    formDispose(form);
  }
}
