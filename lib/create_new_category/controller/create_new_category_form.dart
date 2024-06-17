import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';

class CreateNewCategoryForm extends FormGroup<CategoryParams> {
  final Field<TextEditingController> name;

  @override
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  @override
  final int? id;

  CreateNewCategoryForm({required this.name, this.id}) : super(id){
    logger.i("CreateNewCategoryForm: $id");
  }

  factory CreateNewCategoryForm.form({
    String? name,
    int? id,
  }) {
    return CreateNewCategoryForm(
      name: Field(
        input: TextEditingController(
          text: name,
        ),
        isRequired: false,
        dispose: (p0) {
          return p0?.dispose();
        },
      ),
      id: id,
    );
  }

  @override
  dispose() {
    formKey = null;
    for (dynamic field in form) {
      field.dispose?.call(field.input);
    }
  }

  @override
  List<Field> get form => [name];

  @override
  Result<CategoryParams> toParam() {
    final errorMessage = formIsValid(form);
    if (errorMessage != null) {
      return Result(exception: Error(errorMessage, StackTrace.current));
    }

    final insertName = name.input!.text;

    return Result(
      result: id == null
          ? CategoryParams.create(
              name: insertName,
            )
          : CategoryParams.update(
              name: insertName,
            ),
    );
  }

  @override
  bool validate() {
    return formKey?.currentState?.validate() == true;
  }
}
