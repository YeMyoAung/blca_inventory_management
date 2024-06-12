import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/create_new_product_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_bloc.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_state.dart';
import 'package:inventory_management_with_sql/theme/theme.dart';
import 'package:inventory_management_with_sql/widgest/box/form_box.dart';
import 'package:inventory_management_with_sql/widgest/button/bloc_outlined_button.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SetOptionValueScreen extends StatelessWidget {
  const SetOptionValueScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final createNewProductBloc = context.read<CreateNewProductBloc>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            StarlightUtils.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text("Options"),
        actions: [
          CustomOutlinedButton<SetOptionValueBaseState,
              SetOptionValueBloc>.bloc(
            onPressed: (bloc) {
              if (bloc.validate()) {
                createNewProductBloc.clean();
                StarlightUtils.pop();
              }
            },
            label: "Save",
            icon: Icons.save_outlined,
          )
        ],
      ),
      body: const SetOptionValueBuilder(),
    );
  }
}

class SetOptionValueBuilder extends StatelessWidget {
  const SetOptionValueBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    ///
    final setOptionBloc = context.watch<SetOptionValueBloc>();
    return Form(
      key: setOptionBloc.formGroups.values.first.formKey,
      child: ListView(
        controller: setOptionBloc.scrollController,
        children: [
          /// bloc
          /// formBoxCount = 2
          /// formGroup = {1:[TextEditingController()*2],2:[TextEditingController()*2]}
          /// Map<int,List<FormField>>;assert(List.lenght >= 2)
          /// formBoxCount + 1
          /// formGroup.add()
          ///
          ///
          /// list = [1,2,3,4];-> 0,1,2,3
          /// enter index 1
          /// if list.length-1 == enter index && enter index > 0
          /// add new attribute form
          for (int groupId in setOptionBloc.formGroups.keys)
            FormBox(
              margin: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   "Option Name",
                  //   style: StandardTheme.getBodyTextStyle(context),
                  // ),

                  /// Index == 0 (After Option Name)
                  /// Index == 1 (After Attribute)
                  /// Index > 1
                  // TextFormField(),
                  // Text(
                  //   "Attribute",
                  //   style: StandardTheme.getBodyTextStyle(context),
                  // ),

                  /// Index > 1
                  for (int fieldId = 0;
                      fieldId < setOptionBloc.getForm(groupId).length;
                      fieldId++)
                    if (fieldId == 0) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Option Name",
                            style: StandardTheme.getBodyTextStyle(context),
                          ),
                          if (setOptionBloc.formGroups.length > 1 &&
                              setOptionBloc.formGroups.keys.first != groupId)
                            InkWell(
                              onTap: () {
                                setOptionBloc
                                    .add(RemoveOptionValueEvent(groupId));
                              },
                              child: const Icon(
                                Icons.remove,
                                color: Colors.red,
                              ),
                            )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller:
                              setOptionBloc.getForm(groupId)[fieldId].input,
                          validator: (value) => value?.isNotEmpty == true
                              ? null
                              : "Option Name is required",
                        ),
                      ),
                    ] else if (fieldId == 1) ...[
                      Text(
                        "Attribute",
                        style: StandardTheme.getBodyTextStyle(context),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller:
                              setOptionBloc.getForm(groupId)[fieldId].input,
                          onEditingComplete: () {
                            setOptionBloc.add(
                                AddNewAttributeValueEvent(groupId, fieldId));
                          },
                          validator: (value) => value?.isNotEmpty == true
                              ? null
                              : "Attribute Name is required",
                        ),
                      ),
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TextFormField(
                          controller:
                              setOptionBloc.getForm(groupId)[fieldId].input,
                          onEditingComplete: () {
                            setOptionBloc.add(
                                AddNewAttributeValueEvent(groupId, fieldId));
                          },
                          validator: (value) => value?.isNotEmpty == true ||
                                  (setOptionBloc.isLastAttribute(
                                          fieldId, groupId) &&
                                      setOptionBloc.getForm(groupId).length > 2)
                              ? null
                              : "Attribute Name is required",
                          decoration: InputDecoration(
                            suffixIcon: InkWell(
                              onTap: () {
                                setOptionBloc.add(
                                  RemoveAttributeFieldEvent(fieldId, groupId),
                                );
                              },
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      )
                    ]
                ],
              ),
            ),
          const AddNewOptionButton()
        ],
      ),
    );
  }
}

class AddNewOptionButton extends StatelessWidget {
  const AddNewOptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      color: context.theme.cardColor,
      height: 60,
      width: context.width,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: CustomOutlinedButton<SetOptionValueBaseState,
          SetOptionValueBloc>.bloc(
        onPressed: (bloc) {
          bloc.add(AddNewOptionValueEvent());
        },
        label: "Add More Option",
        icon: Icons.add_circle_outline,
      ),
    );
  }
}
