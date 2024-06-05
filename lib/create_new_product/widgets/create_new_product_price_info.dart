
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_state.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/product_price_button.dart';

class CreateNewProductPriceInfo extends StatelessWidget {
  const CreateNewProductPriceInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final setOptionValueBloc = context.read<SetOptionValueBloc>();
    return BlocBuilder<SetOptionValueBloc, SetOptionValueBaseState>(
      builder: (_, state) {
        final payload = setOptionValueBloc.getPayload();
        if ((state is GenerateOptionValueState ||
                state is GeneratedOptionValueState) &&
            !payload.hasError) {
          if (payload.result!.isNotEmpty) return const SizedBox();
        }
        return const ProductPriceButton();
      },
    );
  }
}
