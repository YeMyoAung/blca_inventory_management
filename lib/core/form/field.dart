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

  static Field<TextEditingController> textEditingController({
    bool isRequired = false,
    String? Function(TextEditingController?)? isValid,
    dynamic Function(TextEditingController?)? dispose,
    String? text,
  }) =>
      Field(
        input: TextEditingController(
          text: text,
        ),

        isRequired: isRequired,
        isValid: isValid,
        dispose: dispose ??
            (p0) {
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
