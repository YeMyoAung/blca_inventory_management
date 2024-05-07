import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/cateogry/controller/category_list_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/theme/theme.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductScreen extends StatelessWidget {
  const CreateNewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final primaryColor = theme.primaryColor;
    final categoryListBloc = context.read<CategoryListBloc>();
    final titleTextStyle = theme.appBarTheme.titleTextStyle;
    final bodyTextStyle = StandardTheme.getBodyTextStyle(context);
    return Theme(
      data: theme.copyWith(
        textButtonTheme: const TextButtonThemeData(
          style: ButtonStyle(
            padding: MaterialStatePropertyAll(EdgeInsets.zero),
          ),
        ),
        listTileTheme: context.theme.listTileTheme.copyWith(
          iconColor: primaryColor,
          textColor: primaryColor,
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
                  Text(
                    "Product Photo",
                    style: titleTextStyle,
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 12,
                      bottom: 20,
                    ),
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
                  Text(
                    "Product Title",
                    style: titleTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 20),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: "Shoes etc...",
                      ),
                    ),
                  ),
                  Text(
                    "Description",
                    style: titleTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: TextFormField(
                      maxLines: 5,
                      minLines: 3,
                      decoration: const InputDecoration(
                        hintText: "Enter a description...",
                      ),
                    ),
                  ),
                  Text(
                    "Describe your product attributes, sales points...",
                    style: bodyTextStyle,
                  ),
                ],
              ),
            ),
            ListTile(
              onTap: () async {
                final result = await StarlightUtils.pushNamed(
                  addCategoryScreen,
                  arguments: categoryListBloc,
                );

                ///TODO
                print(result?.id);
              },
              leading: const Icon(
                Icons.category_outlined,
              ),
              title: const Text(
                "Category",
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () async {
                  final result = await StarlightUtils.pushNamed(
                    addCategoryScreen,
                    arguments: categoryListBloc,
                  );

                  ///TODO
                  print(result?.id);
                },
                leading: const Icon(
                  Icons.archive_outlined,
                ),
                title: const Text(
                  "Add Variants",
                ),
              ),
            ),
            FormBox(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.inventory),
                    title: const Text("Inventory"),
                    trailing: TextButton(
                      onPressed: () {},
                      child: const Text("Edit"),
                    ),
                  ),
                  KeyValuePairWidget(
                    leading: Text(
                      "Sku",
                      style: bodyTextStyle,
                    ),
                    trailing: const Text(
                      "-",
                      textAlign: TextAlign.end,
                    ),
                  ),
                  KeyValuePairWidget(
                    leading: Text(
                      "Barcode",
                      style: bodyTextStyle,
                    ),
                    trailing: const Text(
                      "-",
                      textAlign: TextAlign.end,
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
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
            ListTile(
              onTap: () async {
                final price =
                    await StarlightUtils.pushNamed(setProductPriceScreen);

                ///TODO
                print(price);
              },
              leading: const Icon(
                Icons.monetization_on,
              ),
              title: const Text(
                "Price",
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
        Text(
          title,
          style: StandardTheme.getBodyTextStyle(context),
        ),
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
