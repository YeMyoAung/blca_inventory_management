import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/create_new_inventory_log_form.dart';
import 'package:inventory_management_with_sql/inventory/controller/inventory_list_bloc.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_entity.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
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
      body: BlocBuilder<InventoryListBloc, SqliteReadState<Inventory>>(
          builder: (_, state) {
        final inventories = state.list;
        return ListView.builder(
          itemCount: inventories.length,
          itemBuilder: (_, i) {
            return ListTile(
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
              title: Text(inventories[i].toString()),
            );
          },
        );
      }),
    );
  }
}
