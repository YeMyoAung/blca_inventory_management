import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/create_new_inventory_log_bloc.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/create_new_inventory_log_event.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/create_new_inventory_log_state.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/variant_overview_list_bloc.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/variant_overview_list_state.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:inventory_management_with_sql/routes/route_name.dart';
import 'package:inventory_management_with_sql/routes/router.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_create_new_invenoty_log_usecase.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class CreateNewInventoryLogScreen extends StatelessWidget {
  const CreateNewInventoryLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final variantOverViewListBloc = context.read<VariantOverviewListBloc>();
    final createNewInventoryLogBloc = context.read<CreateNewInventoryLogBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventory Log"),
        actions: [
          CustomOutlinedButton(
            onPressed: () {
              createNewInventoryLogBloc
                  .add(const SqliteExecuteEvent<NullObject>());
            },
            label: "Save",
            icon: Icons.save_alt,
          )
        ],
      ),
      body: BlocListener<CreateNewInventoryLogBloc, SqliteExecuteBaseState>(
        listener: (context, state) {
          if (state is SqliteExecuteState) {
            StarlightUtils.pop();
            return;
          }
          if (state is SqliteExecuteErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
            ));
            return;
          }
        },
        child: Theme(
          data: theme.copyWith(
            // listTileTheme: theme.listTileTheme.copyWith(
            //   titleTextStyle: titleTextStyle?.copyWith(
            //     fontSize: 25,
            //   ),
            // ),
            inputDecorationTheme: theme.inputDecorationTheme.copyWith(
              border: const UnderlineInputBorder(
                borderSide: BorderSide.none,
              ),
            ),
          ),
          child: BlocBuilder<VariantOverviewListBloc, SqliteReadState<Variant>>(
              buildWhen: (_, c) =>
                  c is SqliteForceStopState ||
                  c is VariantOverviewListLoadedState,
              builder: (context, state) {
                logger.i("VariantOverviewListBloc $state ");
                // if (state is SqliteForceStopState) {
                //   return const Center(
                //     child: CupertinoActivityIndicator(),
                //   );
                // }
                return Text("${state.list.length}");
                return Form(
                  key: createNewInventoryLogBloc.form.formKey,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: BlocBuilder<CreateNewInventoryLogBloc,
                            SqliteExecuteBaseState>(
                          buildWhen: (_, current) => current
                              is CreateNewInventoryLogSelectVariantState,
                          builder: (_, state) {
                            final variantID = createNewInventoryLogBloc
                                    .form.variantID.input ??
                                -1;
                            final list = variantOverViewListBloc.state.list;
                            int index =
                                list.indexWhere((e) => e.id == variantID);

                            return ListTile(
                              title: index >= 0
                                  ? Text(
                                      list[index].name,
                                    )
                                  : const Text("Select Variant"),
                              onTap: () async {
                                final result = await StarlightUtils.pushNamed(
                                  selectVariantScreen,
                                  arguments: SelectVariantScreenArgs(
                                    variantOverviewListBloc:
                                        variantOverViewListBloc,
                                  ),
                                );
                                if (result != null) {
                                  createNewInventoryLogBloc.add(
                                    CreateNewInventoryLogSelectVariantEvent(
                                      variantOverViewListBloc
                                          .state
                                          .list[int.parse(result.toString())]
                                          .id,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),

                      ///reason
                      FormBox(
                        child: BlocBuilder<CreateNewInventoryLogBloc,
                            SqliteExecuteBaseState>(
                          buildWhen: (_, current) =>
                              current is CreateNewInventoryLogSelectReasonState,
                          builder: (_, state) {
                            return DropdownButton(
                              value:
                                  createNewInventoryLogBloc.form.reason.input,
                              hint: const Text("Reason"),
                              isDense: true,
                              underline: const SizedBox(),
                              isExpanded: true,
                              items: Reasons.keys
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value == null) return;
                                createNewInventoryLogBloc.add(
                                    CreateNewInventoryLogSelectReasonEvent(
                                        value));
                              },
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: FormBox(
                          height: 60,
                          padding: const EdgeInsets.only(
                              top: 10, left: 20, right: 20),
                          child: TextFormField(
                            controller:
                                createNewInventoryLogBloc.form.quantities.input,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "Quantity",
                            ),
                          ),
                        ),
                      ),

                      FormBox(
                        padding:
                            const EdgeInsets.only(top: 10, left: 20, right: 20),
                        child: TextFormField(
                          controller:
                              createNewInventoryLogBloc.form.description.input,
                          minLines: 3,
                          maxLines: null,
                          decoration: const InputDecoration(
                            hintText: "Description",
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
