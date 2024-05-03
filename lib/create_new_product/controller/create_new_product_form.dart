import 'package:flutter/cupertino.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';

class CreateNewProductForm extends FormGroup<ProductParams> {
  final Field<TextEditingController> name;
  final Field<TextEditingController> description;
  final Field<TextEditingController> barcode;
  final Field<int> categoryId;

  CreateNewProductForm({
    required this.name,
    required this.description,
    required this.barcode,
    required this.categoryId,
  });

  factory CreateNewProductForm.form() {
    return CreateNewProductForm(
      name: Field.textEditingController(),
      description: Field.textEditingController(),
      barcode: Field.textEditingController(),
      categoryId: Field(
        isValid: (p0) => p0 != null && p0 > 0 ? null : "Category is required",
      ),
    );
  }

  ///TODO product photo

  @override
  // TODO: implement form
  List<Field> get form => [name, description, barcode, categoryId];

  @override
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  @override
  bool validate() {
    // return formKey?.currentState?.validate() == true;
    return true;
  }

  @override
  Result<ProductParams> toParam() {
    final errorMessage = formIsValid(form);

    if (errorMessage != null) {
      return Result(exception: Error(errorMessage, StackTrace.current));
    }
    return Result(
      result: ProductParams.toCreate(
        name: name.input!.text,
        categoryId: categoryId.input!,
        barcode: barcode.input!.text,
        description: description.input!.text,
      ),
    );
  }

  @override
  dispose() {
    formKey = null;
    formDispose(form);
  }
}
