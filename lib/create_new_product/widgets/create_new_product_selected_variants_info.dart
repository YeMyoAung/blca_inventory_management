import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/variant_form_listener_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/attribute_builder.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/custom_switch_tile.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/routes/router.dart';
import 'package:inventory_management_with_sql/theme/theme.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductSelectedVariantsInfo extends StatelessWidget {
  const CreateNewProductSelectedVariantsInfo({super.key});

  String getName(CreateNewProductBloc createNewProductBloc) {
    final createNewProductBlocName =
        createNewProductBloc.form.name.input?.text ?? "";
    return createNewProductBlocName.isNotEmpty
        ? createNewProductBlocName
        : "NA";
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final titleTextStyle = theme.appBarTheme.titleTextStyle;
    final setOptionValueBloc = context.read<SetOptionValueBloc>();
    final bodyTextStyle = StandardTheme.getBodyTextStyle(context);
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    final variantFormListenerBloc = context.read<VariantFormListenerBloc>();
    return FormBox(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          CustomSwitchTile(
            title: Text(
              "Variants",
              style: titleTextStyle,
            ),
            value: true,
            onChanged: (value) {
              createNewProductBloc.changeToSingleProduct();
              setOptionValueBloc.add(ClearOptionValueEvent());
            },
          ),

          Text(
            "Add variants from generated list, the rest generated variants will not be active as product.",
            style: bodyTextStyle,
          ),

          ///Selected Variants
          ValueListenableBuilder(
              valueListenable: setOptionValueBloc.selectedVariants,
              builder: (_, value, child) {
                return Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      for (final uiIndex in value)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: InkWell(
                            onTap: () { 
                              createNewProductBloc.form.index =
                                  createNewProductBloc
                                      .variantUiAndFormIndexMapper[uiIndex]!;
                              StarlightUtils.pushNamed(
                                variantDataSetupScreen,
                                arguments: VariantDataSetupArgs(
                                  createNewProductBloc: createNewProductBloc,
                                  setOptionValueBloc: setOptionValueBloc,
                                  selectedIndex: uiIndex,
                                ),
                              );
                            },
                            child: Row(
                              children: [
                                //TODO:
                                const UploadPhotoPlaceholder(),
                                const SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        getName(createNewProductBloc),
                                        style: titleTextStyle,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: VariantAttributeBuilder(
                                          attributes: setOptionValueBloc
                                              .variants[uiIndex],
                                        ),
                                      ),
                                      const Text("0 available"),
                                      Text(
                                        "0 MMK",
                                        style: titleTextStyle,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                );
              }),

          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: CustomOutlinedButton(
              onPressed: () {
                StarlightUtils.pushNamed(
                  setVariantScreen,
                  arguments: VariantScreenArgs(
                    setOptionValueBloc: setOptionValueBloc,
                    createNewProductBloc: createNewProductBloc,
                    variantFormListenerBloc: variantFormListenerBloc,
                  ),
                );
              },
              label: "Select Variants",
              icon: Icons.add_circle_outline,
            ),
          ),
        ],
      ),
    );
  }
}
