import 'package:flutter/cupertino.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';

//TODO
class CreateNewProductForm extends FormGroup<VariantProductParams> {
  final Field<String> coverPhoto;
  final Field<TextEditingController> name,
      description,
      price,
      barcode,
      sku,
      available,
      onHand,
      damange,
      lost;
  final Field<Category> category;
  final Field<bool> availableToSellWhenOutOfStock;

  factory CreateNewProductForm.form() {
    return CreateNewProductForm(
      name: Field.textEditingController(),
      description: Field.textEditingController(),
      price: Field.textEditingController(),
      barcode: Field.textEditingController(),
      sku: Field.textEditingController(),
      available: Field.textEditingController(),
      onHand: Field.textEditingController(),
      damange: Field.textEditingController(),
      lost: Field.textEditingController(),
      category: Field<Category>(
        isValid: (p0) => p0 != null ? null : "Category is required",
      ),
      coverPhoto: Field<String>(
        isValid: (p0) => p0 != null ? null : "Cover Photo is required",
      ),
      availableToSellWhenOutOfStock: Field<bool>(
        input: false,
        isRequired: false,
      ),
    );
  }

  CreateNewProductForm({
    required this.coverPhoto,
    required this.name,
    required this.description,
    required this.price,
    required this.barcode,
    required this.sku,
    required this.available,
    required this.onHand,
    required this.damange,
    required this.lost,
    required this.category,
    required this.availableToSellWhenOutOfStock,
  });

  ///TODO product photo

  @override
  List<Field> get form => [name, description, barcode, category];

  @override
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  @override
  bool validate() {
    // return formKey?.currentState?.validate() == true;
    return true;
  }

  @override
  Result<VariantProductParams> toParam() {
    final errorMessage = formIsValid(form);

    if (errorMessage != null) {
      return Result(exception: Error(errorMessage, StackTrace.current));
    }
    return Result(
      result: VariantProductParams(
        product: ProductParams.toCreate(
          name: name.input!.text,
          categoryId: category.input!.id,
          barcode: barcode.input!.text,
          description: description.input!.text,
          coverPhoto: coverPhoto.notNullInput,
        ),
        variant: [
          VariantParam.toCreate(
            coverPhoto: coverPhoto.notNullInput,
            sku: sku.notNullInput.text,
            price: double.parse(price.notNullInput.text),
            available: double.tryParse(available.notNullInput.text) ?? 0,
            damage: double.tryParse(damange.notNullInput.text) ?? 0,
            onHand: double.tryParse(onHand.notNullInput.text) ?? 0,
            lost: double.tryParse(lost.notNullInput.text) ?? 0,
            allowPurchaseWhenOutOfStock:
                availableToSellWhenOutOfStock.notNullInput,
          )
        ],
      ),
    );
  }

  @override
  dispose() {
    formKey = null;
    formDispose(form);
  }
}
