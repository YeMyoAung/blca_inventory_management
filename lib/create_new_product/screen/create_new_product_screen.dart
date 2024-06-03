import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/cateogry/controller/category_list_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/theme/theme.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductScreen extends StatelessWidget {
  const CreateNewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    final setOptionValueBloc = context.read<SetOptionValueBloc>();
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
            CustomOutlinedButton<SqliteCreateBaseState,
                CreateNewProductBloc>.bloc(
              listenWhen: (p0, p1) =>
                  p1 is SqliteCreateErrorState || p1 is SqliteCreatedState,
              listener: (p0, p1, state) {
                if (state is SqliteCreateErrorState) {
                  StarlightUtils.snackbar(
                    SnackBar(
                      content: Text(state.message),
                    ),
                  );
                  return;
                }

                StarlightUtils.pop();
              },
              buildWhen: (p0, p1) {
                return false;
              },
              onPressed: (bloc) {
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
                  InkWell(
                    onTap: () {
                      createNewProductBloc
                          .add(const CreateNewProductPickCoverPhotoEvent());
                    },
                    child: BlocBuilder<CreateNewProductBloc,
                            SqliteCreateBaseState>(
                        buildWhen: (_, state) =>
                            state is CreateNewProductCoverPhotoSelectedState,
                        builder: (_, state) {
                          if (createNewProductBloc.form.coverPhoto.input !=
                              null) {
                            return Container(
                              margin: const EdgeInsets.only(
                                top: 12,
                                bottom: 20,
                              ),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: FileImage(
                                    File(createNewProductBloc
                                        .form.coverPhoto.notNullInput),
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              width: 80,
                              height: 80,
                              alignment: Alignment.center,
                            );
                          }
                          return Container(
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
                          );
                        }),
                  ),
                  Text(
                    "Product Title",
                    style: titleTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 20),
                    child: TextFormField(
                      controller: createNewProductBloc.form.name.notNullInput,
                      validator: (value) =>
                          value?.isNotEmpty == true ? null : "",
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
                      controller:
                          createNewProductBloc.form.description.notNullInput,
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
                if (result is Category) {
                  createNewProductBloc
                      .add(CreateNewProducCategorySelectEvent(result));
                }
              },
              leading: const Icon(
                Icons.category_outlined,
              ),
              title: BlocBuilder<CreateNewProductBloc, SqliteCreateBaseState>(
                  buildWhen: (_, state) =>
                      state is CreateNewProductCategorySelectedState,
                  builder: (_, state) {
                    if (createNewProductBloc.form.category.input != null) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Category",
                          ),
                          Text(createNewProductBloc
                              .form.category.notNullInput.name),
                        ],
                      );
                    }
                    return const Text(
                      "Category",
                    );
                  }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListTile(
                onTap: () async {
                  StarlightUtils.pushNamed(
                    setOptionValueScreen,
                    arguments: setOptionValueBloc,
                  );
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
                      onPressed: () {
                        StarlightUtils.pushNamed(
                          setProductInventoryScreen,
                          arguments: createNewProductBloc,
                        );
                      },
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
                  BlocBuilder<CreateNewProductBloc, SqliteCreateBaseState>(
                      buildWhen: (_, state) => state
                          is CreateNewProductAvailableToSellWhenOutOfStockSelectedState,
                      builder: (_, state) {
                        return SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          value: createNewProductBloc
                              .form.availableToSellWhenOutOfStock.notNullInput,
                          onChanged: (value) {
                            createNewProductBloc.add(
                              CreateNewProductAvailabeToSellWhenOutOfStockEvent(
                                value,
                              ),
                            );
                          },
                          title: const Text("Allow Purhcase When Out Of Stock"),
                        );
                      }),
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
                final price = await StarlightUtils.pushNamed(
                  setProductPriceScreen,
                  arguments: createNewProductBloc,
                );

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
