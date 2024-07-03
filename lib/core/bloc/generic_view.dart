import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';

class GenericView<Model extends DatabaseModel,
        Bloc extends StateStreamable<SqliteReadState<Model>>>
    extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget Function(BuildContext _, List<Model> list, int index) builder;
  const GenericView({
    super.key,
    this.appBar,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final variantOverviewListBloc = context.read<Bloc>();
    return Scaffold(
      appBar: this.appBar,
      body: Column(
        children: [
          FormBox(
            margin: const EdgeInsets.only(bottom: 20),
            child: TextField(
              onChanged: (variantOverviewListBloc as SqliteReadBloc)
                  .searchController
                  .search,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<Bloc, SqliteReadState<Model>>(
              builder: (_, state) {
                if (state is SqliteSoftLoadingState<Model> ||
                    state is SqliteLoadingState<Model>) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
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
