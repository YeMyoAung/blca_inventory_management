import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_use_case.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/form/form.dart';

abstract class SqliteCreateBloc<
        Model extends DatabaseModel,
        Param extends DatabaseParamModel,
        UseCase extends SqliteCreateUseCase<Model, Param>,
        Form extends FormGroup<Param>>
    extends Bloc<SqliteCreateBaseEvent, SqliteCreateBaseState> {
  final UseCase useCase;
  final Form form;
  SqliteCreateBloc(this.form, this.useCase)
      : super(SqliteCreateInitialState()) {
    on<SqliteCreateEvent>(_sqliteCreateEventListener);
  }

  FutureOr<void> _sqliteCreateEventListener(_, emit) async {
    if (state is SqliteCreatingState) {
      return;
    }

    if (!form.validate()) return;

    final values = form.toParam();

    if (values.hasError) {
      return emit(SqliteCreateErrorState(values.toString()));
    }
    emit(SqliteCreatingState());
    final result = await onCreate(values.result!);

    if (result.hasError) {
      return emit(SqliteCreateErrorState(
        result.toString(),
      ));
    }

    emit(SqliteCreatingState());

    emit(SqliteCreatedState());
  }

  FutureOr<Result<Model>> onCreate(Param param) {
    return useCase.create(param);
  }

  @override
  Future<void> close() {
    form.dispose();
    return super.close();
  }
}
