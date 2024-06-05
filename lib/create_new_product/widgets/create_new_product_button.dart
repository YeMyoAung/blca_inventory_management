import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductButton extends StatelessWidget {
  const CreateNewProductButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomOutlinedButton<SqliteCreateBaseState,
        CreateNewProductBloc>.bloc(
      listenWhen: (p0, p1) =>
          p1 is SqliteCreateErrorState || p1 is SqliteCreatedState,
      listener: (p0, p1, state) {
        if (state is SqliteCreateErrorState) {
          StarlightUtils.snackbar(
            SnackBar(
              content: Text(state.message),
            ),
          );
          return;
        }

        StarlightUtils.pop();
      },
      buildWhen: (p0, p1) {
        return false;
      },
      onPressed: (bloc) {
        bloc.add(const SqliteCreateEvent());
      },
      label: "Save",
      icon: Icons.save_outlined,
    );
  }
}
