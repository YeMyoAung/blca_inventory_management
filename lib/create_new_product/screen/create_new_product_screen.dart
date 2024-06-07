import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_category_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_button.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_option_attribute_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_price_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_selected_variant_or_inventory_info.dart';
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
        listTileTheme: context.theme.listTileTheme.copyWith(
          iconColor: primaryColor,
          textColor: primaryColor,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Create Products"),
          actions: const [
            CreateNewProductButton(),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.only(bottom: 30),
          children: const [
            CreateNewProductInfo(),
            CreateNewCategoryInfo(),
            CreateNewProductOptionAttributeInfo(),
            CreateNewProductSelectedVariantsOrInventoryInfo(),
            CreateNewProductPriceInfo(),
          ],
        ),
      ),
    );
  }
}
