import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_state.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_product_inventory_button.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/create_new_product_selected_variants_info.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductSelectedVariantsOrInventoryInfo extends StatelessWidget {
  const CreateNewProductSelectedVariantsOrInventoryInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    final setOptionValueBloc = context.read<SetOptionValueBloc>();

    return BlocBuilder<SetOptionValueBloc, SetOptionValueBaseState>(
      builder: (_, state) {
        final payload = setOptionValueBloc.getPayload();

        if ((state is GenerateOptionValueState ||
                state is GeneratedOptionValueState) &&
            !payload.hasError) {
          if (payload.result!.isNotEmpty) {
            return const CreateNewProductSelectedVariantsInfo();
          }
        }
        return CreateNewProductInventoryButton(
          onPressed: () {
            StarlightUtils.pushNamed(
              setProductInventoryScreen,
              arguments: createNewProductBloc,
            );
          },
          allowPurchaseWhenOutOfStockBuilder: (buildSwitchTile) {
            return BlocBuilder<CreateNewProductBloc, SqliteCreateBaseState>(
              buildWhen: (_, state) => state
                  is CreateNewProductAvailableToSellWhenOutOfStockSelectedState,
              builder: (_, state) {
                return buildSwitchTile(
                  createNewProductBloc
                      .form.availableToSellWhenOutOfStock.notNullInput,
                  (value) {
                    createNewProductBloc.add(
                      CreateNewProductAvailabeToSellWhenOutOfStockEvent(
                        value,
                      ),
                    );
                  },
                );
              },
            );
          },
          stockBuilder: (stockBuilder) {
            return BlocBuilder<CreateNewProductBloc, SqliteCreateBaseState>(
              buildWhen: (_, state) => state is CreateNewProductNewStockState,
              builder: (_, state) {
                double parse(String? value) =>
                    double.tryParse(
                      value ?? "0",
                    ) ??
                    0;
                return stockBuilder(
                  parse(createNewProductBloc.form.available.input?.text),
                  parse(createNewProductBloc.form.onHand.input?.text),
                  parse(createNewProductBloc.form.lost.input?.text),
                  parse(createNewProductBloc.form.damage.input?.text),
                );
              },
            );
          },
        );
      },
    );
  }
}
