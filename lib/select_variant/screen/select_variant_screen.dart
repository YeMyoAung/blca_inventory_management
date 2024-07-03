import 'package:flutter/material.dart';
import 'package:inventory_management_with_sql/core/bloc/generic_view.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/variant_overview_list_bloc.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SelectVariantScreen extends StatelessWidget {
  const SelectVariantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericView<Variant, VariantOverviewListBloc>(
      appBar: AppBar(
        title: const Text("Variants"),
      ),
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
