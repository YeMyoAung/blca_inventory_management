import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/create_new_inventory_log_event.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/create_new_inventory_log_form.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/create_new_inventory_log_state.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_entity.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_create_new_invenoty_log_usecase.dart';

class CreateNewInventoryLogBloc extends SqliteExecuteBloc<
    Inventory,
    InventoryParam,
    SqliteCreateNewInventoryLogUseCase,
    CreateNewInventoryLogForm,
    NullObject> {
  CreateNewInventoryLogBloc(super.form, super.useCase) {
    on<CreateNewInventoryLogSelectReasonEvent>(
        _createNewInventoryLogSelectReasonEvent);
    on<CreateNewInventoryLogSelectVariantEvent>(
      _createNewInventoryLogSelectVariantEvent,
    );
  }

  
  FutureOr<void> _createNewInventoryLogSelectVariantEvent(
      CreateNewInventoryLogSelectVariantEvent event,
      Emitter<SqliteExecuteBaseState> emit) {
    form.variantID.input = event.value;
    emit(CreateNewInventoryLogSelectVariantState());
  }

  FutureOr<void> _createNewInventoryLogSelectReasonEvent(
      CreateNewInventoryLogSelectReasonEvent event,
      Emitter<SqliteExecuteBaseState> emit) {
    form.reason.input = event.value;
    emit(CreateNewInventoryLogSelectReasonState());
  }
}
