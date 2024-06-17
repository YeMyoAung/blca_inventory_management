import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_state.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_state.dart';
import 'package:inventory_management_with_sql/create_new_product/widgets/product_price_button.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewProductPriceInfo extends StatelessWidget {
  const CreateNewProductPriceInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final setOptionValueBloc = context.read<SetOptionValueBloc>();
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    return BlocBuilder<SetOptionValueBloc, SetOptionValueBaseState>(
      buildWhen: (_, current) =>
          current is GenerateOptionValueState ||
          current is GeneratedOptionValueState ||
          current is ClearOptionValueState,
      builder: (_, state) {
        final payload = setOptionValueBloc.getPayload();

        if ((state is GenerateOptionValueState ||
                state is GeneratedOptionValueState) &&
            !payload.hasError) {
          if (payload.result!.isNotEmpty) return const SizedBox();
        }
        return ProductPriceButton(
          onTap: () {
            //index 0
            StarlightUtils.pushNamed(
              setProductPriceScreen,
              arguments: createNewProductBloc,
            );
          },
          builder: () {
            return const ProductPriceBuilder(
              // buildWhen: (bloc) => !bloc.form.varaints[0].isVariant,
            );
          },
        );
      },
    );
  }
}

class ProductPriceBuilder extends StatelessWidget {
  final bool Function(CreateNewProductBloc)? buildWhen;
  const ProductPriceBuilder({
    super.key,
    this.buildWhen,
  });

  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();

    return BlocBuilder<CreateNewProductBloc, SqliteExecuteBaseState>(
      buildWhen: buildWhen == null
          ? null
          : (_, current) =>
              current is CreateNewProductSetPriceState &&
              buildWhen!.call(createNewProductBloc),
      builder: (_, state) {
        final data =
            double.tryParse(createNewProductBloc.form.price.input?.text ?? "");
        return Text(
          "${data ?? "NA"}",
        );
      },
    );
  }
}
