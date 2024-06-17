import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductButton extends StatelessWidget {
  const CreateNewProductButton({super.key});

  @override
  Widget build(BuildContext context) {
    final setOptionValueBloc = context.read<SetOptionValueBloc>();
    return CustomOutlinedButton<SqliteExecuteBaseState,
        CreateNewProductBloc>.bloc(
      listenWhen: (p0, p1) =>
          p1 is SqliteExecuteErrorState || p1 is SqliteExecuteState,
      listener: (p0, p1, state) {
        if (state is SqliteExecuteErrorState) {
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
        bloc.add(SqliteExecuteEvent<ProductCreateEvent>(
          arguments: ProductCreateEvent(
            formGroups: setOptionValueBloc.formGroups,
            getPayload: setOptionValueBloc.getPayload,
            variants: setOptionValueBloc.variants,
          ),
        ));
      },
      label: "Save",
      icon: Icons.save_outlined,
    );
  }
}
