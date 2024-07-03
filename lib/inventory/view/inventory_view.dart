import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/bloc/generic_view.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/create_new_inventory_log_form.dart';
import 'package:inventory_management_with_sql/inventory/controller/inventory_list_bloc.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_entity.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_create_new_invenoty_log_usecase.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class InventoryListView extends StatelessWidget {
  const InventoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Inventory"),
        actions: [
          CustomOutlinedButton(
            onPressed: () {
              StarlightUtils.pushNamed(
                createnewInventoryLogScreen,
                arguments: CreateNewInventoryLogForm.form(),
              );
            },
            label: "Add Log",
            icon: Icons.history,
          )
        ],
      ),
      body: GenericView<Inventory, InventoryListBloc>(
          builder: (_, inventories, i) {
        return InventoryItem(inventory: inventories[i]);
      }),
    );
  }
}

class InventoryItem extends StatelessWidget {
  final Inventory inventory;
  const InventoryItem({super.key, required this.inventory});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        StarlightUtils.pushNamed(
          createnewInventoryLogScreen,
          arguments: CreateNewInventoryLogForm.form(
            id: inventory.id,
            variantID: inventory.variantID,
            reason: inventory.reason,
            quantities: inventory.quantity.toString(),
            description: inventory.description,
          ),
        );
      },
      child: ListTile(
        dense: false,
        title: Text(inventory.createdAt.toString()),
        trailing: Text(
          (inventory.quantity * (inventory.reason != PURCHASE ? -1 : 1))
              .toString(),
          style: TextStyle(
            fontSize: 14,
            color: getColor(inventory.reason),
          ),
        ),
        subtitle: Text(
          "${inventory.variantName} as ${inventory.reason} ",
        ),
      ),
    );
  }
}
