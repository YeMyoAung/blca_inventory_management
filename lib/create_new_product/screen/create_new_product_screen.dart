import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductScreen extends StatelessWidget {
  const CreateNewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.primaryColor;
    return Theme(
      data: theme.copyWith(
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.zero),
          ),
        ),
        listTileTheme: ListTileThemeData(
          iconColor: primaryColor,
          textColor: primaryColor,
          contentPadding: EdgeInsets.zero,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Products"),
          actions: [
            CustomOutlinedButton<SqliteCreateState, CreateNewProductBloc>.bloc(
              buildWhen: (p0, p1) {
                logger.e(p0);
                logger.e(p1);
                return false;
              },
              onPressed: (bloc) {
                bloc.form.name.input?.text = "Product 1";
                bloc.form.categoryId.input = 1;
                bloc.form.barcode.input?.text = "1001";
                bloc.form.description.input?.text = "A good product";
                bloc.add(const SqliteCreateEvent());
              },
              label: "Save",
              icon: Icons.save_outlined,
            )
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 30),
          children: [
            FormBox(
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Product Photo"),
                  Container(
                    decoration: BoxDecoration(
                      color: context.theme.unselectedWidgetColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    width: 80,
                    height: 80,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.upload,
                      size: 30,
                    ),
                  ),
                  const Text("Product Title"),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Shoes etc...",
                    ),
                  ),
                  const Text("Description"),
                  TextFormField(
                    maxLines: 5,
                    minLines: 3,
                    decoration: const InputDecoration(
                      hintText: "Enter a description...",
                    ),
                  ),
                  const Text(
                      "Describe your product attributes, sales points..."),
                ],
              ),
            ),
            const FormBox(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                leading: Icon(
                  Icons.category_outlined,
                ),
                title: Text(
                  "Category",
                ),
              ),
            ),
            FormBox(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.inventory),
                    title: const Text("Inventory"),
                    trailing: TextButton(
                      onPressed: () {},
                      child: const Text("Edit"),
                    ),
                  ),
                  const KeyValuePairWidget(
                    leading: Text("Sku"),
                    trailing: Text(
                      "-",
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const KeyValuePairWidget(
                    leading: Text("Barcode"),
                    trailing: Text(
                      "-",
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SwitchListTile(
                    dense: true,
                    value: false,
                    onChanged: (value) {},
                    title: const Text("Allow Purhcase When Out Of Stock"),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StockValue(title: "Available", value: 0),
                      StockValue(title: "On Hand", value: 0),
                      StockValue(title: "Lost", value: 0),
                      StockValue(title: "Damage", value: 0),
                    ],
                  )
                ],
              ),
            ),
            const FormBox(
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                leading: Icon(
                  Icons.monetization_on,
                ),
                title: Text(
                  "Price",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StockValue extends StatelessWidget {
  final String title;
  final double value;
  const StockValue({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("$value"),
            const Icon(Icons.arrow_drop_down_outlined)
          ],
        ),
      ],
    );
  }
}

class KeyValuePairWidget extends StatelessWidget {
  const KeyValuePairWidget({
    super.key,
    required this.leading,
    required this.trailing,
  });
  final Widget leading, trailing;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: leading),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(right: 20),
          child: trailing,
        )),
      ],
    );
  }
}
