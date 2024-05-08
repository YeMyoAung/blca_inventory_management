import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/cateogry/controller/category_list_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: Column(
        children: [
          const FormBox(
            margin: EdgeInsets.only(top: 10, bottom: 20),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CategoryListBloc, SqliteReadState<Category>>(
              builder: (_, state) {
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: state.list.length,
                  itemBuilder: (_, i) {
                    return ListTile(
                      onTap: () => StarlightUtils.pop(result: state.list[i]),
                      title: Text(state.list[i].name),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
