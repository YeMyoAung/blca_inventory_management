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
        return InkWell(
          onTap: () {
            StarlightUtils.pushNamed(
              createnewInventoryLogScreen,
              arguments: CreateNewInventoryLogForm.form(
                id: inventories[i].id,
                variantID: inventories[i].variantID,
                reason: inventories[i].reason,
                quantities: inventories[i].quantity.toString(),
                description: inventories[i].description,
              ),
            );
          },
          child: ListTile(
            dense: false,
            title: Text(inventories[i].createdAt.toString()),
            trailing: Text(
              (inventories[i].quantity *
                      (inventories[i].reason != PURCHASE ? -1 : 1))
                  .toString(),
              style: TextStyle(
                fontSize: 14,
                color: inventories[i].reason == PURCHASE
                    ? Colors.green
                    : inventories[i].reason == DAMAGE
                        ? Colors.orange
                        : inventories[i].reason == SELL
                            ? Colors.amber
                            : Colors.red,
              ),
            ),
            subtitle: Text(
              "${inventories[i].variantName} as ${inventories[i].reason} ",
            ),
          ),
        );
      }),
    );
  }
}
