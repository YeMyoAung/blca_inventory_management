import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/form/field.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_event.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_form.dart';
import 'package:inventory_management_with_sql/create_new_product/controller/set_option_value_state.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SetOptionValueBloc
    extends Bloc<SetOptionValueBaseEvent, SetOptionValueBaseState> {
  int count = 1;

  ///{1:[textingcontroller,]}index 0 => option name,index >= 1 => attribute
  ///Option Name
  /// - Attribute Name
  /// {
  ///   option_name:"",
  ///   attribute_names:[{
  /// name:}]
  /// }
  Map<int, SetOptionValueForm> formGroups;

  void clear(emit) {
    count = 1;
    formGroups = form ??
        {
          1: SetOptionValueForm.instance(),
        };
    variants = [];
    selectedVariants.value = [];
    emit(AddNewOptionValueState());
    emit(ClearOptionValueState());
  }

  Result<List<Map<String, dynamic>>> getPayload() {
    final List<Map<String, dynamic>> payload = [];
    if (formGroups.isEmpty ||
        formGroups.values.first.form.first.input?.text.isNotEmpty == false) {
      return Result(
        result: payload,
      );
    }

    for (final form in formGroups.values) {
      payload.add({
        "name": form.form[0].input?.text,
        "attributes": form.form
            .sublist(1)
            .where((element) => element.input?.text.isNotEmpty == true)
            .map(
              (e) => {
                "name": e.input?.text,
              },
            )
            .toList(),
      });
    }

    return Result(
      result: payload,
    );
  }

  List<Field<TextEditingController>> getForm(int optionId) {
    return formGroups[optionId]?.form ?? [];
  }

  GlobalKey<FormState>? getFormKey(int index) {
    return formGroups[index]?.formKey;
  }

  bool validate() {
    // for (final form in ) {
    //   print(form);
    //   if (!form.validate()) {
    //     return false;
    //   }
    // }
    logger.w("formGroups ${formGroups.values.first.formKey}");
    if (formGroups.values.first.formKey?.currentState?.validate() == true) {
      add(GenerateOptionValueEvent());

      return true;
    }
    return false;
  }

  final ScrollController scrollController = ScrollController();

  Map<int, SetOptionValueForm>? form;

  List<String>? properties;

  SetOptionValueBloc([this.form, this.properties])
      : formGroups = form ??
            {
              1: SetOptionValueForm.instance(),
            },
        super(SetOptionValueInitialState()) {
    if (form != null) {
      count = form!.length;
    }

    on<AddNewOptionValueEvent>(_addNewOptionValueEvent);

    on<AddNewAttributeValueEvent>(_addNewAttributeValueEvent);

    on<RemoveOptionValueEvent>(_removeOptionValueEvent);

    on<ClearOptionValueEvent>(_clearOptionValueEvent);

    on<GenerateOptionValueEvent>(_generateOptionValueEvent);

    if (form != null) {
      add(GenerateOptionValueEvent());
    }

    on<RemoveAttributeFieldEvent>(
      (event, emit) {
        _removeAttributeFieldEvent(event, emit);
      },
    );
  }

  void _removeAttributeFieldEvent(
    RemoveAttributeFieldEvent event,
    Emitter<SetOptionValueBaseState> emit,
  ) {
    if (formGroups.isEmpty) return;
    final group = formGroups[event.optionId];

    if (group == null) return;
    final result = group.form.toList()..removeAt(event.attributeId);
    group.form.clear();
    group.form.addAll(result);
    emit(AddNewOptionValueState());
  }

  List<List<Map>> variants = [];

  FutureOr<void> _generateOptionValueEvent(
    GenerateOptionValueEvent _,
    Emitter<SetOptionValueBaseState> emit,
  ) async {
    logger.i("Start Generating");
    emit(GenerateOptionValueState());

    /// [{size},{color},{package}]
    ///
    /// size (color,package)
    final payload = getPayload();
    if (payload.hasError) return;

    final sizeColorPackageExampleResult = (payload.result ?? []).map((e) {
      final v = e['attributes'].toList() as List<Map>;

      return v.map((Map v) {
        return {
          ...v,
          "option": e['name'],
        };
      }).toList();
    }).toList(); //size,color,package
    if (sizeColorPackageExampleResult.isEmpty) return;
    variants = sizeColorPackageExampleResult.fold<List<List<Map>>>([],
        (previousValue, element) {
      if (previousValue.isEmpty) {
        return element.map((e) => [e]).toList();
      }

      ///previousValue = List<List>
      final List<List<Map>> prob = [];
      for (final i in element) {
        for (final j in previousValue) {
          prob.add([...j, i]);
        }
      }
      return prob;
    });

    if (properties != null) {
      final selected = <int>[];
      final selectedPropertiesStrings = <String>[];
      for (final propertiesString in properties ?? <String>[]) {
        ///1-2-3 == 1-2-3
        final index = variants.indexWhere((element) {
          final String varaintString = element.map((e) => e['name']).join("-");
          return propertiesString == varaintString;
        });
        if (index == -1) continue;
        selectedPropertiesStrings.add(propertiesString);
        selected.add(index);
      }
      selectedVariants.value = selected;
      properties = null;
      emit(GeneratedOptionValueState(
        selectedProperties: selectedPropertiesStrings,
      ));
    } else {
      selectedVariants.value = [];
      emit(GeneratedOptionValueState(selectedProperties: null));
    }
  }

  FutureOr<void> _addNewOptionValueEvent(
      AddNewOptionValueEvent _, Emitter<SetOptionValueBaseState> emit) {
    count++;
    formGroups[count] = SetOptionValueForm.instance();

    scrollEnd(emit);
  }

  FutureOr<void> _addNewAttributeValueEvent(
    AddNewAttributeValueEvent event,
    Emitter<SetOptionValueBaseState> emit,
  ) async {
    final form = formGroups[event.attributeId];
    if (form == null) return;
    if (!isLastAttribute(event.optionId, event.attributeId)) return;
    if (form.form[event.optionId].input?.isNotEmpty == true) {
      form.addNewAttribute();
      emit(AddNewOptionValueState());
    }
  }

  FutureOr<void> _removeOptionValueEvent(
      RemoveOptionValueEvent event, Emitter<SetOptionValueBaseState> emit) {
    formGroups.remove(event.optionId);
    emit(RemoveOptionValueState());
  }

  FutureOr<void> _clearOptionValueEvent(
    ClearOptionValueEvent _,
    Emitter<SetOptionValueBaseState> emit,
  ) {
    clear(emit);
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

  final ValueNotifier<List<int>> selectedVariants = ValueNotifier([]);

  void addVariants(int index) {
    selectedVariants.value = selectedVariants.value.toList()..add(index);
  }

  void removeVariants(int index) {
    selectedVariants.value = selectedVariants.value.toList()..remove(index);
  }

  @override
  Future<void> close() {
    scrollController.dispose();
    selectedVariants.dispose();

    ///formGroups.forEach((key, value) => value.dispose());
    return super.close();
  }
}
