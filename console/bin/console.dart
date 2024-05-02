class Field<T> {
  final bool isRequired;
  T? data;
  final String? Function(T?)? isValid;
  final Function(T?)? dispose;

  Field({
    this.data,
    this.isValid,
    this.isRequired = true,
    this.dispose,
  }) : assert((isValid == null && !isRequired) ||
            (isRequired && isValid != null));
}

class XFile {
  final String path;

  XFile(this.path);
}

class TextEditingController {
  String text = "";
  void dispose() {}
}

String? isValid(List<Field> form) {
  for (dynamic field in form) {
    if (field.isRequired) {
      final value = field.isValid!(field.data);
      if (value != null) {
        return value;
      }
    }
  }
  return null;
}

class ProductParam {
  final String name;
  final int categoryId;
  final String barcode;

  ProductParam(
      {required this.name, required this.categoryId, required this.barcode});
}

class ProductForm {
  final Field<String> name;
  final Field<int> categoryId;
  final Field<String> barcode;

  ProductForm(
      {required this.name, required this.categoryId, required this.barcode});

  toCreateParam() {
    if (null == isValid([name, categoryId, barcode])) {
      throw "is not valid";
    }
    return ProductParam(
        name: name.data!, categoryId: categoryId.data!, barcode: barcode.data!);
  }
}

class CreateBloc {
  final ProductForm form;
  CreateBloc(this.form);
}

void main() {
  ///Shop
  final coverPhotoField = Field<XFile>(
    isValid: (value) => value != null && value.path.isNotEmpty
        ? null
        : "Cover photo is missing",
  );
  final nameField = Field<TextEditingController>(
    data: TextEditingController(),
    isRequired: false,
    dispose: (data) => data?.dispose(),
  );

  nameField.data?.text = "hello";
  coverPhotoField.data = XFile("hello world");

  print(isValid([coverPhotoField, nameField]));
}
