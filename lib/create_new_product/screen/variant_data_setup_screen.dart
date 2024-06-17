import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_option_attribute_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_price_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_product_inventory_button.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/product_price_button.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class VariantDataSetupScreen extends StatelessWidget {
  final int uiIndex;
  const VariantDataSetupScreen({super.key, required this.uiIndex});

  @override
  Widget build(BuildContext context) {
    final titleTextStyle = context.theme.appBarTheme.titleTextStyle;
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    final selectedValue =
        context.read<SetOptionValueBloc>().variants.elementAt(uiIndex);
    const attributeStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
    );
    final formIndex = createNewProductBloc.variantUiAndFormIndexMapper[uiIndex];
    if (formIndex == null) return ErrorWidget("Invaild index");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Variant"),
        actions: [
          CustomOutlinedButton(
            onPressed: () {
              StarlightUtils.pop();
            },
            label: "Save",
            icon: Icons.save,
          )
        ],
      ),
      body: ListView(
        children: [
          FormBox(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload Product Photo",
                  style: titleTextStyle,
                ),
                const VariantProductPhotoPicker(),
                for (final value in selectedValue)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${value['option']} :",
                          style: attributeStyle,
                        ),
                        AttributeCard(
                          name: value['name'],
                          style: attributeStyle,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: ProductPriceButton(
              onTap: () {
                StarlightUtils.pushNamed(
                  setProductPriceScreen,
                  arguments: createNewProductBloc,
                );
              },
              builder: () {
                return ProductPriceBuilder(
                  buildWhen: (p0) =>
                      p0.form.index == formIndex &&
                      p0.form.varaints[formIndex].isVariant,
                );
              },
            ),
          ),
          CreateNewProductInventoryButton(
            onPressed: () {
              StarlightUtils.pushNamed(
                setProductInventoryScreen,
                arguments: createNewProductBloc,
              );
            },
            allowPurchaseWhenOutOfStockBuilder: (childBuilder) {
              return BlocBuilder<CreateNewProductBloc, SqliteExecuteBaseState>(
                  builder: (_, state) {
                return childBuilder(
                  createNewProductBloc
                      .form.availableToSellWhenOutOfStock.notNullInput,
                  (v) {
                    createNewProductBloc.add(
                      CreateNewProductAvailabeToSellWhenOutOfStockEvent(
                        v,
                      ),
                    );
                  },
                );
              });
            },
          ),
        ],
      ),
    );
  }
}


class VariantProductPhotoPicker extends StatelessWidget {
  const VariantProductPhotoPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    return InkWell(
      onTap: () {
        createNewProductBloc.add(const CreateNewVariantProductPickCoverPhotoEvent());
      },
      child: BlocBuilder<CreateNewProductBloc, SqliteExecuteBaseState>(
          buildWhen: (_, state) =>
              state is CreateNewVariantProductCoverPhotoSelectedState,
          builder: (_, state) {
            if (createNewProductBloc.form.variantCoverPhoto.input != null) {
              return Container(
                margin: const EdgeInsets.only(
                  top: 12,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(
                      File(createNewProductBloc.form.variantCoverPhoto.notNullInput!),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                width: 80,
                height: 80,
                alignment: Alignment.center,
              );
            }
            return const UploadPhotoPlaceholder();
          }),
    );
  }
}

