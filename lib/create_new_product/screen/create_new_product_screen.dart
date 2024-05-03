import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';

class CreateNewProductScreen extends StatelessWidget {
  const CreateNewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Products"),
        actions: [
          CustomOutlinedButton<SqliteCreateState, CreateNewProductBloc>.bloc(
            buildWhen: (p0, p1) {
              logger.e(p0);
              logger.e(p1);
              return false;
            },
            onPressed: (bloc) {
              bloc.form.name.input?.text = "Product 1";
              bloc.form.categoryId.input = 1;
              bloc.form.barcode.input?.text = "1001";
              bloc.form.description.input?.text = "A good product";
              bloc.add(const SqliteCreateEvent());
            },
            label: "Save",
            icon: Icons.save_outlined,
          )
        ],
      ),
    );
  }
}
