import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_use_case.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';

abstract class SqliteExecuteBloc<
        Model extends DatabaseModel,
        Param extends DatabaseParamModel,
        UseCase extends SqliteExecuteUseCase<Model, Param>,
        Form extends FormGroup<Param>,
        Args extends NullObject>
    extends Bloc<SqliteExecuteBaseEvent, SqliteExecuteBaseState> {
  final UseCase useCase;
  final Form form;
  SqliteExecuteBloc(this.form, this.useCase)
      : super(SqliteExecuteInitialState()) {
    on<SqliteExecuteEvent<Args>>(_sqliteCreateEventListener);
  }

  bool isValid(SqliteExecuteEvent<Args> event) => form.validate();

  Result<Param> toParam(SqliteExecuteEvent<Args> event) => form.toParam();

  FutureOr<Result<Model>> onExecute(
    SqliteExecuteEvent<Args> event,
    Param param, [
    int? id,
  ]) =>
      useCase.execute(param, form.id);

  FutureOr<void> _sqliteCreateEventListener(
    SqliteExecuteEvent<Args> event,
    Emitter<SqliteExecuteBaseState> emit,
  ) async {
    if (state is SqliteExecutingState) {
      return;
    }

    if (!isValid(event)) return;

    final values = toParam(event);

    if (values.hasError) {
      return emit(SqliteExecuteErrorState(values.toString()));
    }
    emit(SqliteExecutingState());

    final result = await onExecute(event, values.result!);

    if (result.hasError) {
      return emit(SqliteExecuteErrorState(
        result.toString(),
      ));
    }

    emit(SqliteExecutingState());

    emit(SqliteExecuteState());
  }

  @override
  Future<void> close() {
    form.dispose();
    return super.close();
  }
}
