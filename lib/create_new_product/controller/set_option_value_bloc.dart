import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
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
    emit(AddNewOptionValueState());
  }

  Result<List<Map<String, dynamic>>> getPayload() {
    final List<Map<String, dynamic>> payload = [];
    if (formGroups.isEmpty) {
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
            ),
      });
    }

    return Result(
      result: payload,
    );
  }

  List<Field<TextEditingController>> getForm(int index) {
    return formGroups[index]?.form ?? [];
  }

  GlobalKey<FormState>? getFormKey(int index) {
    return formGroups[index]?.formKey;
  }

  bool validate() {
    for (final form in formGroups.values) {
      if (!form.validate()) {
        return false;
      }
    }

    add(GenerateOptionValueEvent());

    return true;
  }

  final ScrollController scrollController = ScrollController();

  Map<int, SetOptionValueForm>? form;

  SetOptionValueBloc([this.form])
      : formGroups = form ??
            {
              1: SetOptionValueForm.instance(),
            },
        super(SetOptionValueInitialState()) {
    on<AddNewOptionValueEvent>(_addNewOptionValueEvent);

    on<AddNewAttributeValueEvent>(_addNewAttributeValueEvent);

    on<RemoveOptionValueEvent>(_removeOptionValueEvent);

    on<ClearOptionValueEvent>(_clearOptionValueEvent);

    on<GenerateOptionValueEvent>(_generateOptionValueEvent);
  }

  FutureOr<void> _generateOptionValueEvent(
      GenerateOptionValueEvent _, Emitter<SetOptionValueBaseState> emit) async {
    emit(GenerateOptionValueState());
    print("_generateOptionValueEvent");

    /// [{size},{color},{package}]
    ///
    /// size (color,package)
    final payload = getPayload();
    if (payload.hasError) return;

    final sizeColorPackageExampleResult =
        payload.result ?? []; //size,color,package
    if (sizeColorPackageExampleResult.isEmpty) return;

    // sizeColorPackageExampleResult.fold([], (previousValue, element) {
    //   print(previousValue);
    //   final current = element['attributes'].toList();
    //   print(current);
    //   print("-----");
    //   if (previousValue.isNotEmpty) {
    //     for (final value in current) {
    //       for (final pValue in previousValue) {

    //       }
    //     }
    //   }

    //   return current;
    // });

    // final first = sizeColorPackageExampleResult[0];
    // final name = first['name'];
    // final attributes = first["attributes"]; //size
    // final total = sizeColorPackageExampleResult.length;

    // for (final size in attributes) {
    //   print("First Loop: $name");
    //   print("size is ${size['name']}");
    //   final pair =
    //       {}; //color,package ,(Red,Gold)(Green,Gold)(Blue,Gold) (Red,Sliver),(Green,Sliver),(Blue,Sliver)
    //   for (final colorPackage
    //       in sizeColorPackageExampleResult.getRange(1, total)) {
    //     final otherName = colorPackage['name'];
    //     final otherAttributes = colorPackage['attributes'];
    //     print("Other Loop: $otherName");
    //     print("other data: $otherAttributes");
    //   }
    // }
  }

  FutureOr<void> _addNewOptionValueEvent(
      AddNewOptionValueEvent _, Emitter<SetOptionValueBaseState> emit) {
    count++;
    formGroups[count] = SetOptionValueForm.instance();

    scrollEnd(emit);
  }

  FutureOr<void> _addNewAttributeValueEvent(AddNewAttributeValueEvent event,
      Emitter<SetOptionValueBaseState> emit) async {
    final form = formGroups[event.groupId];
    if (form == null) return;
    if (!isLastAttribute(event.fieldId, event.groupId)) return;
    if (form.form[event.fieldId].input?.isNotEmpty == true) {
      form.addNewAttribute();
      emit(AddNewOptionValueState());
    }
  }

  FutureOr<void> _removeOptionValueEvent(
      RemoveOptionValueEvent event, Emitter<SetOptionValueBaseState> emit) {
    formGroups.remove(event.groupId);
    emit(RemoveOptionValueState());
  }

  FutureOr<void> _clearOptionValueEvent(
      ClearOptionValueEvent _, Emitter<SetOptionValueBaseState> emit) {
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

  @override
  Future<void> close() {
    scrollController.dispose();

    ///formGroups.forEach((key, value) => value.dispose());
    return super.close();
  }
}
