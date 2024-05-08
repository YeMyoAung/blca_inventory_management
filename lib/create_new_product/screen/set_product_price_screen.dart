import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SetProductPriceScreen extends StatelessWidget {
  const SetProductPriceScreen({super.key});

  void submit(String text) {
    final value = double.tryParse(text) ?? -1;
    if (value == -1) {
      StarlightUtils.snackbar(
        const SnackBar(
          content: Text("Please set a valid price"),
        ),
      );
      return;
    }
    StarlightUtils.pop(result: value);
  }

  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Price"),
        actions: [
          CustomOutlinedButton(
            onPressed: () {
              submit(createNewProductBloc.form.price.input!.text);
            },
            label: "Save",
            icon: Icons.save_outlined,
          )
        ],
      ),
      body: FormBox(
        margin: const EdgeInsets.only(top: 10),
        child: TextFormField(
          controller: createNewProductBloc.form.price.input!,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            final parse = double.tryParse(value ?? "");
            return parse == null
                ? ""
                : parse < 0
                    ? ""
                    : null;
          },
          onEditingComplete: () {
            submit(createNewProductBloc.form.price.input!.text);
          },
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "eg. 10000",
          ),
        ),
      ),
    );
  }
}
