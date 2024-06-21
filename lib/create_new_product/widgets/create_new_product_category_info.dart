import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/cateogry/controller/category_list_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_state.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewCategoryInfo extends StatelessWidget {
  const CreateNewCategoryInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryListBloc = context.read<CategoryListBloc>();
    final createNewProductBloc = context.read<CreateNewProductBloc>();

    return ListTile(
      onTap: () async {
        final result = await StarlightUtils.pushNamed(
          addCategoryScreen,
          arguments: categoryListBloc,
        );
        if (result is Category) {
          createNewProductBloc.add(CreateNewProducCategorySelectEvent(result));
        }
      },
      leading: const Icon(
        Icons.category_outlined,
      ),
      title: BlocBuilder<CreateNewProductBloc, SqliteExecuteBaseState>(
          buildWhen: (_, state) =>
              state is CreateNewProductCategorySelectedState,
          builder: (_, state) {
            logger.e("Selected Category ${createNewProductBloc.form.category.input}");
            if (createNewProductBloc.form.category.input != null) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Category",
                  ),
                  Text(createNewProductBloc.form.category.notNullInput.name),
                ],
              );
            }
            return const Text(
              "Category",
            );
          }),
    );
  }
}
