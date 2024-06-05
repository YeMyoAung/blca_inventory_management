import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProductPriceButton extends StatelessWidget {
  const ProductPriceButton({super.key});

  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();

    return ListTile(
      onTap: () async {
        await StarlightUtils.pushNamed(
          setProductPriceScreen,
          arguments: createNewProductBloc,
        );
      },
      leading: const Icon(
        Icons.monetization_on,
      ),
      title: const Text(
        "Price",
      ),
    );
  }
}
