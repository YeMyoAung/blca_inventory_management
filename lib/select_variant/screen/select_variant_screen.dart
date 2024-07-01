import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/variant_overview_list_bloc.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SelectVariantScreen extends StatelessWidget {
  const SelectVariantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AddSomethingScreen<Variant, VariantOverviewListBloc>(
      title: "Variant",
      builder: (_, list, index) {
        return ListTile(
          onTap: () {
            StarlightUtils.pop(result: index);
          },
          title: Text(list[index].name),
        );
      },
    );
  }
}

class AddSomethingScreen<Model extends DatabaseModel,
        Bloc extends StateStreamable<SqliteReadState<Model>>>
    extends StatelessWidget {
  final String title;
  final Widget Function(BuildContext _, List<Model> list, int index) builder;
  const AddSomethingScreen({
    super.key,
    required this.title,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
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
            child: BlocBuilder<Bloc, SqliteReadState<Model>>(
              builder: (_, state) {
                return ListView.separated(
                  padding: const EdgeInsets.only(bottom: 20),
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                  itemCount: state.list.length,
                  itemBuilder: (_, i) {
                    return builder(_, state.list, i);
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
