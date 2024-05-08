import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/utils/dialog.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_bloc.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewCategoryScreen extends StatelessWidget {
  const CreateNewCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CreateNewCategoryBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Categories"),
        actions: [
          CustomOutlinedButton<SqliteCreateBaseState,
              CreateNewCategoryBloc>.bloc(
            onPressed: (bloc) {
              bloc.add(const SqliteCreateEvent());
            },
            listener: (_, bloc, state) {
              if (state is SqliteCreatedState) {
                StarlightUtils.pop();
                StarlightUtils.snackbar(SnackBar(
                    content: Text(
                        "${bloc.form.name.input?.text} was successfully created.")));
                return;
              }
              state as SqliteCreateErrorState;
              dialog("Failed to create category", state.message);
            },
            listenWhen: (_, current) {
              return current is SqliteCreatedState ||
                  current is SqliteCreateErrorState;
            },
            label: "Save",
            icon: Icons.save_outlined,
          )
        ],
      ),
      body: Form(
        key: bloc.form.formKey,
        child: FormBox(
          margin: const EdgeInsets.only(top: 20),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Category Name",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: bloc.form.name.input,
                validator: (v) => v?.isNotEmpty == true ? null : "",
                decoration: const InputDecoration(
                  hintText: "Computer etc...",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
