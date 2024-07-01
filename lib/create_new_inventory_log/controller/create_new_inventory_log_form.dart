import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_entity.dart';

class CreateNewInventoryLogForm extends FormGroup<InventoryParam> {
  @override
  GlobalKey<FormState>? formKey = GlobalKey<FormState>();

  final Field<int> variantID;
  final Field<String> reason;
  final Field<TextEditingController> quantities;
  final Field<TextEditingController> description;

  @override
  int? id;

  CreateNewInventoryLogForm({
    required this.id,
    required this.variantID,
    required this.reason,
    required this.quantities,
    required this.description,
  });

  factory CreateNewInventoryLogForm.form({
    int? id,
    int? variantID,
    String? reason,
    String? quantities,
    String? description,
  }) {
    return CreateNewInventoryLogForm(
      id: id,
      variantID: Field<int>(
        input: variantID,
        isValid: (p0) =>
            p0 != null && p0 >= 0 ? null : "Please select a variant",
      ),
      reason: Field<String>(
        input: reason,
        isValid: (p0) =>
            p0?.isNotEmpty == true ? null : "Please select a reason",
      ),
      quantities: Field.textEditingController(text: quantities),
      description: Field.textEditingController(text: description),
    );
  }

  @override
  dispose() {
    formKey = null;
    formDispose(form);
  }

  @override
  List<Field> get form => [variantID, reason, quantities, description];

  @override
  Result<InventoryParam> toParam() {
    final variant = variantID.input ?? -1;
    if (variant < 0) {
      return Result(exception: Error("Please select a variant"));
    }
    final rs = reason.input ?? "";
    if (rs.isEmpty) {
      return Result(exception: Error("Please select a reason"));
    }
    final qty = double.tryParse(quantities.input?.text ?? "") ?? -1;
    if (qty < 0) {
      return Result(exception: Error("Please enter a valid quantity"));
    }

    final desc = description.input?.text ?? "";

    return Result(
      result: InventoryParam.create(
        variantID: variant,
        reason: rs,
        quantity: qty,
        description: desc,
      ),
    );
  }

  @override
  bool validate() {
    return formKey?.currentState?.validate() ?? false;
  }
}
