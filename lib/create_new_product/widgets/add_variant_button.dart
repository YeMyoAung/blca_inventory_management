import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/routes/router.dart';
import 'package:starlight_utils/starlight_utils.dart';

class AddVariantButton extends StatelessWidget {
  const AddVariantButton({super.key});

  @override
  Widget build(BuildContext context) {
    final setOptionValueBloc = context.read<SetOptionValueBloc>();
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    return ListTile(
      onTap: () async {
        StarlightUtils.pushNamed(
          setOptionValueScreen,
          arguments: SetOptionValueArgs(
            createNewProductBloc: createNewProductBloc,
            setOptionValueBloc: setOptionValueBloc,
          ),
        );
      },
      leading: const Icon(
        Icons.archive_outlined,
      ),
      title: const Text(
        "Add Variants",
      ),
    );
  }
}
