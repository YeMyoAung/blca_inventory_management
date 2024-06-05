import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/attribute_builder.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SetVariantScreen extends StatelessWidget {
  const SetVariantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final setOptionValueBloc = context.read<SetOptionValueBloc>();
    final createNewProductBlocName =
        context.read<CreateNewProductBloc>().form.name.input?.text ?? "";
    final name =
        createNewProductBlocName.isNotEmpty ? createNewProductBlocName : "NA";
    final titleTextStyle = context.theme.appBarTheme.titleTextStyle;
    return Scaffold(
      backgroundColor: context.theme.cardColor,
      appBar: AppBar(
        title: const Text("Select Variants"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
            child: Text(
              "Generated Variants",
              style: titleTextStyle,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: setOptionValueBloc.variants.length,
              itemBuilder: (_, index) {
                final variants = setOptionValueBloc.variants[index];
                return Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    left: 5,
                    right: 20,
                  ),
                  child: Row(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: setOptionValueBloc.selectedVariants,
                        builder: (_, value, child) {
                          final isExist = value.contains(index);
                          print(value);
                          return Checkbox(
                            value: isExist,
                            onChanged: (value) {
                              if (isExist) {
                                setOptionValueBloc.removeVariants(index);
                              } else {
                                setOptionValueBloc.addVariants(index);
                              }
                            },
                          );
                        },
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: titleTextStyle,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          VariantAttributeBuilder(
                            attributes: variants,
                          )
                        ],
                      ))
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

