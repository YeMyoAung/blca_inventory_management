import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SetProductInventoryScreen extends StatelessWidget {
  const SetProductInventoryScreen({super.key});

  void submit(CreateNewProductBloc bloc) {
    if (!_doubleCheck(bloc.form.available.notNullInput.text)) {
      _showSnackBar("Available must be num");
      return;
    }
    if (!_doubleCheck(bloc.form.onHand.notNullInput.text)) {
      _showSnackBar("On Hand must be num");
      return;
    }
    if (!_doubleCheck(bloc.form.lost.notNullInput.text)) {
      return _showSnackBar("Lost must be num");
    }
    if (!_doubleCheck(bloc.form.damange.notNullInput.text)) {
      return _showSnackBar("Damange must be num");
    }
    StarlightUtils.pop();
  }

  void _showSnackBar(String text) =>
      StarlightUtils.snackbar(SnackBar(content: Text(text)));
  bool _doubleCheck(String text) =>
      text.isEmpty ? true : double.tryParse(text) != null;
  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Inventory"),
        actions: [
          CustomOutlinedButton(
            onPressed: () {
              submit(createNewProductBloc);
            },
            label: "Save",
            icon: Icons.save_outlined,
          )
        ],
      ),
      body: ListView(
        children: [
          FormBox(
            margin: const EdgeInsets.only(top: 10, bottom: 20),
            child: Column(
              children: [
                TextFormField(
                  controller: createNewProductBloc.form.sku.input!,
                  decoration: const InputDecoration(
                    hintText: "Sku",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: createNewProductBloc.form.barcode.input!,
                    decoration: InputDecoration(
                      hintText: "Barcode",
                      suffixIcon: InkWell(
                        onTap: () {
                          ///TODO
                        },
                        child: const Icon(Icons.qr_code),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          FormBox(
            child: Column(
              children: [
                TextFormField(
                  validator: (value) => value == null
                      ? null
                      : double.tryParse(value) == null
                          ? ""
                          : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: createNewProductBloc.form.available.notNullInput,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Available",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: TextFormField(
                    controller: createNewProductBloc.form.onHand.notNullInput,
                    validator: (value) => value == null
                        ? null
                        : double.tryParse(value) == null
                            ? ""
                            : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: "On Hand",
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: createNewProductBloc.form.lost.notNullInput,
                  validator: (value) => value == null
                      ? null
                      : double.tryParse(value) == null
                          ? ""
                          : null,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    hintText: "Lost",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: TextFormField(
                    controller: createNewProductBloc.form.damange.notNullInput,
                    keyboardType: TextInputType.number,
                    validator: (value) => value == null
                        ? null
                        : double.tryParse(value) == null
                            ? ""
                            : null,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      hintText: "Damage",
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
