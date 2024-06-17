import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/cateogry/controller/category_list_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/create_new_category/controller/create_new_category_form.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/routes/router.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CategoryListView extends StatelessWidget {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Category"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CustomOutlinedButton(
              onPressed: () {
                StarlightUtils.pushNamed(
                  createNewCategory,
                  arguments: CreateNewCategoryArgs(
                    form: CreateNewCategoryForm.form(),
                    title: "Create New Category",
                  ),
                );
              },
              label: "Create Category",
              icon: Icons.add_circle_outline,
            ),
          )
        ],
      ),
      body: BlocBuilder<CategoryListBloc, SqliteReadState<Category>>(
          builder: (_, state) {
        return ListView.builder(
          itemCount: state.list.length,
          itemBuilder: (_, i) {
            return ListTile(
              onTap: () {
                StarlightUtils.pushNamed(
                  createNewCategory,
                  arguments: CreateNewCategoryArgs(
                    form: CreateNewCategoryForm.form(
                      name: state.list[i].name,
                      id: state.list[i].id,
                    ),
                    title: "Edit Category",
                  ),
                );
              },
              title: Text(state.list[i].name),
            );
          },
        );
      }),
    );
  }
}
