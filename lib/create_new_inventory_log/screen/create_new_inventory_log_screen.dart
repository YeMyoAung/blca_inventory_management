import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/create_new_inventory_log_bloc.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';

class CreateNewInventoryLogScreen extends StatelessWidget {
  const CreateNewInventoryLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Log"),
        actions: [
          CustomOutlinedButton(
            onPressed: () {
              ///TODO
            },
            label: "Save",
            icon: Icons.save_alt,
          )
        ],
      ),
      body: Column(
        children: [
          // const TextField(),
          // Expanded(
          //   child:
          //       BlocBuilder<VariantOverviewListBloc, SqliteReadState<Variant>>(
          //     builder: (_, state) {
          //       final data = state.list;
          //       return ListView.builder(
          //         itemCount: data.length,
          //         itemBuilder: (_, i) {
          //           return ListTile(
          //             title: Text(data[i].name),
          //           );
          //         },
          //       );
          //     },
          //   ),
          // )

          ///reason
          DropdownButton(
            items: Reasons.keys
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(e),
                  ),
                )
                .toList(),
            onChanged: (value) {},
          ),

          TextFormField(),

          TextFormField(
            minLines: 3,
            maxLines: null,
          )

        ],
      ),
    );
  }
}
