import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/cateogry/controller/category_list_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/generic_view.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_form.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_info.dart';
import 'package:inventory_management_with_sql/product/controller/product_list_bloc.dart';
import 'package:inventory_management_with_sql/repo/product_repo/v2/product_entity.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/routes/router.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryListBloc = context.read<CategoryListBloc>();
    final productListBloc = context.read<ProductListBloc>();
    final titleStyle = context.theme.appBarTheme.titleTextStyle;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Product"),
        actions: [
          CustomOutlinedButton(
            onPressed: () {
              StarlightUtils.pushNamed(
                createNewProduct,
                arguments: CreateNewProductArgs(
                  title: "Create Product",
                  categoryListBloc: categoryListBloc,
                  form: CreateNewProductForm.form(
                    id: null,
                    varaints: [
                      CreateNewVariantForm.form(),
                    ],
                  ),
                  propertiesForm: null,
                  properties: null,
                ),
              );
            },
            label: "Create Product",
            icon: Icons.save_outlined,
          )
        ],
      ),
      body: GenericView<Product, ProductListBloc>(
        builder: (_, list, i) {
          return InkWell(
            onTap: () async {
              final product = await productListBloc.detail(i);
              if (product.hasError) {
                //TODO show error
                return;
              }
              final productDetail = product.result!;

              StarlightUtils.pushNamed(
                createNewProduct,
                arguments: CreateNewProductArgs(
                  title: "Edit Product",
                  categoryListBloc: categoryListBloc,
                  form: CreateNewProductForm.form(
                    properties: productDetail.options.map((e) {
                      return OptionAttributePair(
                        option: e,
                        attribute: e.attributes,
                      );
                    }).toList(),
                    id: productDetail.id,
                    name: productDetail.name,
                    description: productDetail.description,
                    barcode: productDetail.barcode,
                    category: productDetail.category,
                    coverPhoto: productDetail.coverPhoto,
                    varaints: productDetail.variantForm,
                  ),
                  propertiesForm: productDetail.propertiesForm,
                  properties: productDetail.variants
                      .map((e) =>
                          e.properties.map((e) => e.attributeName).join("-"))
                      .toList(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
              color: Colors.white,
              height: 150,
              child: Row(
                children: [
                  UploadPhotoPlaceholder(
                    path: list[i].coverPhoto,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          list[i].name,
                          style: titleStyle,
                        ),
                        Expanded(
                          child: Text(
                            list[i].description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 5,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
