import 'package:flutter/cupertino.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';

class CreateNewProductForm extends FormGroup<VariantProductParams> {
  //product
  final Field<String> coverPhoto;
  final Field<TextEditingController> name, description, barcode;
  final Field<Category> category;
  // single product = varaints.length(1)
  // variant product = varaints.length(>1)
  final List<CreateNewVariantForm> varaints;

  ///TODO Option,Value Form

  factory CreateNewProductForm.form() {
    return CreateNewProductForm(
      name: Field.textEditingController(),
      description: Field.textEditingController(),
      barcode: Field.textEditingController(),
      category: Field<Category>(
        isValid: (p0) => p0 != null ? null : "Category is required",
      ),
      coverPhoto: Field<String>(
        isValid: (p0) => p0 != null ? null : "Cover Photo is required",
      ),
      varaints: [
        CreateNewVariantForm.form(),
      ],
    );
  }

  int index = 0;

  Field<bool> get availableToSellWhenOutOfStock =>
      varaints[index].allowPurchaseWhenOutOfStock;
  Field<TextEditingController> get damage => varaints[index].damage;
  Field<TextEditingController> get lost => varaints[index].lost;
  Field<TextEditingController> get onHand => varaints[index].onHand;
  Field<TextEditingController> get price => varaints[index].price;
  Field<TextEditingController> get sku => varaints[index].sku;
  Field<String?> get variantCoverPhoto => varaints[index].coverPhoto;
  Field<TextEditingController> get available => varaints[index].available;

  ///List<Option>
  ///List<Value>

  ///probe => varaints[[1,1],[2,1],[3,1]]=> pro
  ///TODO
  void addNewVaraint() {
    // varaints.add(CreateNewVariantForm.form());
    varaints.clear();

    ///logic
    // varaints.addAll(newVariants);
  }

  void removeVariant(int index) {
    varaints.removeAt(index);
  }

  CreateNewProductForm({
    required this.coverPhoto,
    required this.name,
    required this.description,
    required this.barcode,
    required this.category,
    required this.varaints,
  }) : assert(varaints.isNotEmpty);

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
      return Result(
          exception: Error(
        errorMessage,
        StackTrace.current,
      ));
    }

    ///TODO
    ///Option vaild
    ///Value vaild

    final variantFormResult = varaints.map((e) {
      e.coverPhoto.input ??= coverPhoto.notNullInput;
      return e.toParam();
    });
    final variantFormErrors = variantFormResult.where((e) => e.hasError);
    if (variantFormErrors.isNotEmpty) {
      return Result(
        exception: variantFormErrors.first.exception,
      );
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
        variant: variantFormResult.map((e) => e.result!).toList(),
      ),
    );
  }

  @override
  dispose() {
    formKey = null;
    formDispose(form);
  }
}

class CreateNewVariantForm extends FormGroup<VariantParam> {
  final Field<String> coverPhoto;
  final Field<TextEditingController> sku,
      price,
      available,
      damage,
      onHand,
      lost;
  final Field<bool> allowPurchaseWhenOutOfStock;
  //variant product = true
  final bool isVariant;

  const CreateNewVariantForm({
    required this.coverPhoto,
    required this.sku,
    required this.price,
    required this.available,
    required this.damage,
    required this.onHand,
    required this.lost,
    required this.allowPurchaseWhenOutOfStock,
    required this.isVariant,
  });

  factory CreateNewVariantForm.form([bool isVariant = false]) {
    return CreateNewVariantForm(
      coverPhoto: Field<String>(
        isValid: (p0) => p0 != null ? null : "Cover Photo is required",
      ),
      sku: Field.textEditingController(),
      price: Field.textEditingController(),
      available: Field.textEditingController(),
      damage: Field.textEditingController(),
      onHand: Field.textEditingController(),
      lost: Field.textEditingController(),
      allowPurchaseWhenOutOfStock: Field<bool>(
        input: false,
        isRequired: true,
        isValid: (p0) =>
            p0 == null ? "Allow purchase when out of stock is reqruied" : null,
      ),
      isVariant: isVariant,
    );
  }

  @override
  dispose() {
    formDispose(form);
  }

  @override
  List<Field> get form => [
        sku,
        price,
        available,
        damage,
        onHand,
        lost,
        allowPurchaseWhenOutOfStock
      ];

  @override
  GlobalKey<FormState>? get formKey => GlobalKey<FormState>();

  @override
  Result<VariantParam> toParam() {
    final errorMessage = formIsValid(form);
    if (errorMessage != null) {
      return Result(exception: Error(errorMessage));
    }
    final priceData = double.tryParse(price.notNullInput.text);
    if (priceData == null) return Result(exception: Error("Missing price"));
    return Result(
      result: VariantParam.toCreate(
        coverPhoto: coverPhoto.notNullInput,
        sku: sku.notNullInput.text,
        price: priceData,
        available: double.tryParse(available.notNullInput.text) ?? 0,
        damage: double.tryParse(damage.notNullInput.text) ?? 0,
        onHand: double.tryParse(onHand.notNullInput.text) ?? 0,
        lost: double.tryParse(lost.notNullInput.text) ?? 0,
        allowPurchaseWhenOutOfStock: allowPurchaseWhenOutOfStock.notNullInput,

        ///TODO
        properties: [],
      ),
    );
  }

  @override
  bool validate() {
    return true;
  }
}
