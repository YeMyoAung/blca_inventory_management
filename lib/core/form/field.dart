import 'package:flutter/cupertino.dart';

class Field<F> {
  final bool isRequired;
  F? input;
  final String? Function(F?)? isValid;
  final Function(F?)? dispose;

  Field({
    this.input,
    this.isRequired = true,
    this.isValid,
    this.dispose,
  }) : assert((isValid == null && !isRequired) ||
            (isRequired && isValid != null));

  static Field<TextEditingController> textEditingController() => Field(
        input: TextEditingController(),
        isRequired: false,
        dispose: (p0) {
          return p0?.dispose();
        },
        // value: (p0)=> p0.value.text,
      );

  F get notNullInput => input!;
}

String? formIsValid(List<Field> form) {
  for (dynamic field in form) {
    if (field.isRequired) {
      final value = field.isValid!(field.input);
      if (value != null) {
        return value;
      }
    }
  }
  return null;
}

void formDispose(List<Field> form) {
  for (dynamic field in form) {
    field.dispose?.call(field.input);
  }
}
