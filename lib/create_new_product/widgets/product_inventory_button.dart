import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_state.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/custom_switch_tile.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/key_value_pair_widget.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/stock_value.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/theme/theme.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProductInventoryButton extends StatelessWidget {
  const ProductInventoryButton({super.key});

  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    final bodyTextStyle = StandardTheme.getBodyTextStyle(context);
    return FormBox(
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
                return CustomSwitchTile(
                  title: const Text("Allow Purhcase When Out Of Stock"),
                  value: createNewProductBloc
                      .form.availableToSellWhenOutOfStock.notNullInput,
                  onChanged: (value) {
                    createNewProductBloc.add(
                      CreateNewProductAvailabeToSellWhenOutOfStockEvent(
                        value,
                      ),
                    );
                  },
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
    );
  }
}
