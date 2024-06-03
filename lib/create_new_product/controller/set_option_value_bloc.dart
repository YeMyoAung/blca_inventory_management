import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_form.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_state.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SetOptionValueBloc
    extends Bloc<SetOptionValueBaseEvent, SetOptionValueBaseState> {
  int count = 1;
  final Map<int, SetOptionValueForm> formGroups;

  List<Field<TextEditingController>> getForm(int index) {
    return formGroups[index]?.form ?? [];
  }

  GlobalKey<FormState>? getFormKey(int index) {
    return formGroups[index]?.formKey;
  }

  void validate() {
    formGroups.forEach((_, value) {
      value.validate();
    });
  }

  final ScrollController scrollController = ScrollController();

  SetOptionValueBloc([Map<int, SetOptionValueForm>? form])
      : formGroups = form ??
            {
              1: SetOptionValueForm.instance(),
            },
        super(SetOptionValueInitialState()) {
    on<AddNewOptionValueEvent>(
      (_, emit) {
        count++;
        formGroups[count] = SetOptionValueForm.instance();

        scrollEnd(emit);
      },
    );

    on<AddNewAttributeValueEvent>((event, emit) {
      final form = formGroups[event.groupId];
      if (form == null) return;
      if (!isLastAttribute(event.fieldId, event.groupId)) return;
      if (form.form[event.fieldId].input?.isNotEmpty == true) {
        form.addNewAttribute();
        emit(AddNewOptionValueState());
      }
    });

    on<RemoveOptionValueEvent>((event, emit) {
      formGroups.remove(event.groupId);
      emit(RemoveOptionValueState());
    });
  }

  bool isLastAttribute(int fieldId, int groupId) {
    return fieldId == getForm(groupId).length - 1;
  }

  void scrollEnd(emit) {
    emit(AddNewOptionValueState());
    scrollController.animateTo(
      scrollController.offset + scrollController.position.viewportDimension,
      duration: const Duration(milliseconds: 200),
      curve: Curves.linear,
    );
  }

  @override
  Future<void> close() {
    scrollController.dispose();

    ///formGroups.forEach((key, value) => value.dispose());
    return super.close();
  }
}
