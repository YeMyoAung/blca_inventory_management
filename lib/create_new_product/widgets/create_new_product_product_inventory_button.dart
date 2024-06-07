import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/custom_switch_tile.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/key_value_pair_widget.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/stock_value.dart';
import 'package:inventory_management_with_sql/theme/theme.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';

class CreateNewProductInventoryButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget Function(
    Widget Function(
      bool value,
      Function(bool) onChanged,
    ),
  )? allowPurchaseWhenOutOfStockBuilder;
  final Widget Function(
      Widget Function(
        double available,
        double onHand,
        double lost,
        double damage,
      ))? stockBuilder;
  const CreateNewProductInventoryButton({
    super.key,
    required this.onPressed,
    this.allowPurchaseWhenOutOfStockBuilder,
    this.stockBuilder,
  });

  Widget buildStockRow(
    double available,
    double onHand,
    double lost,
    double damage,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        StockValue(title: "Available", value: available),
        StockValue(title: "On Hand", value: onHand),
        StockValue(title: "Lost", value: lost),
        StockValue(title: "Damage", value: damage),
      ],
    );
  }

  Widget buildAllowPurchaseWhenOutOfStockSwitchTile(
    bool value,
    Function(bool)? onChanged,
  ) {
    return CustomSwitchTile(
      title: const Text("Allow Purhcase When Out Of Stock"),
      value: value,
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    // final createNewProductBloc = context.read<CreateNewProductBloc>();
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
              onPressed: onPressed,
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
          allowPurchaseWhenOutOfStockBuilder
                  ?.call(buildAllowPurchaseWhenOutOfStockSwitchTile) ??
              buildAllowPurchaseWhenOutOfStockSwitchTile(false, null),
          stockBuilder?.call(buildStockRow) ?? buildStockRow(0, 0, 0, 0),
        ],
      ),
    );
  }
}
