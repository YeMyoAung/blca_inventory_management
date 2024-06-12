import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_state.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/add_variant_button.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/routes/router.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductOptionAttributeInfo extends StatelessWidget {
  const CreateNewProductOptionAttributeInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final setOptionValueBloc = context.read<SetOptionValueBloc>();
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    final theme = context.theme;
    final titleTextStyle = theme.appBarTheme.titleTextStyle;
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: BlocBuilder<SetOptionValueBloc, SetOptionValueBaseState>(
        builder: (_, state) {
          final payload = setOptionValueBloc.getPayload();
          if ((state is GenerateOptionValueState ||
                  state is GeneratedOptionValueState) &&
              !payload.hasError) {
            final result = payload.result ?? [];
            if (result.isNotEmpty) {
              return FormBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Options",
                      style: titleTextStyle,
                    ),
                    for (final optionAttributes in result) ...[
                      Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(optionAttributes['name'])),
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        height: 30,
                        width: context.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: optionAttributes['attributes'].length,
                          itemBuilder: (_, i) {
                            return AttributeCard(
                              name: optionAttributes['attributes']
                                  .elementAt(i)['name'],
                            );
                          },
                        ),
                        // child: Text(optionAttributes['attributes'].elementAt(0).toString()),
                      )
                    ],
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: CustomOutlinedButton(
                        onPressed: () {
                          StarlightUtils.pushNamed(
                            setOptionValueScreen,
                            arguments: SetOptionValueArgs(
                                createNewProductBloc: createNewProductBloc,
                                setOptionValueBloc: setOptionValueBloc),
                          );
                        },
                        label: "Add More Variants",
                        icon: Icons.add_circle_outline,
                      ),
                    ),
                  ],
                ),
              );
            }
          }
          return const AddVariantButton();
        },
      ),
    );
  }
}

class AttributeCard extends StatelessWidget {
  final String name;
  final TextStyle? style;
  const AttributeCard({
    super.key,
    required this.name,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(15),
      ),
      alignment: Alignment.center,
      child: Text(
        name,
        style: style,
      ),
    );
  }
}
