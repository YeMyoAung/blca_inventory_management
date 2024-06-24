import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/variant_form_listener_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_button.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_category_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_option_attribute_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_price_info.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_selected_variant_or_inventory_info.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductScreen extends StatelessWidget {
  final String title;
  const CreateNewProductScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    final setOptionValueBloc = context.read<SetOptionValueBloc>();
    final variantFormListenerBloc = context.read<VariantFormListenerBloc>();
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
      child: BlocListener<SetOptionValueBloc, SetOptionValueBaseState>(
        listener: (context, state) {
          if (state is GeneratedOptionValueState) {
         
            final properties = state.selectedProperties ?? [];
            for (int i = 0; i < properties.length; i++) {
              createNewProductBloc.mapUiAndForm(
                  setOptionValueBloc.selectedVariants.value[i], properties[i]);
            }
          }
        },
        child: BlocListener<VariantFormListenerBloc, VariantFormState>(
          listener: (context, state) {
            if (state.isAdded == null) return;
            if (state.isAdded == true) {
              createNewProductBloc.addVariant(
                state.index,
              );
              setOptionValueBloc.addVariants(state.index);
            } else {
              createNewProductBloc.removeVariant(state.index);
              setOptionValueBloc.removeVariants(state.index);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(title),
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
        ),
      ),
    );
  }
}
