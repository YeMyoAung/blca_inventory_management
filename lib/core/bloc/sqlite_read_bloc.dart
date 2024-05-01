import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_repo.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_crud.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';

abstract class SqliteReadBloc<Model extends DatabaseModel,
        Param extends DatabaseParamModel, Repo extends SqliteRepo<Model, Param>>
    extends Bloc<SqliteEvent<Model>, SqliteState<Model>> {
  StreamSubscription? onChangeSubscription;

  int currentOffset = 0;

  final Repo repo;
  SqliteReadBloc(
    super.initialState,
    this.repo,
  ) {
    //on action
    onChangeSubscription = repo.onAction.listen(_repOnActionListener);

    ///Get Event
    on<SqliteGetEvent<Model>>(_sqliteGetEventListener);

    ///Create Event
    on<SqliteCreatedEvent<Model>>(_sqliteCreatedEventListener);

    ///Update Event
    on<SqliteUpdatedEvent<Model>>(_sqliteUpdatedEventListener);

    ///Delete Event
    on<SqliteDeletedEvent<Model>>(_sqliteDeletedEventListener);

    add(SqliteGetEvent());
  }

  void _repOnActionListener(DatabaseCrudOnAction<Model> event) {
    if (event.action == DatabaseCrudAction.create) {
      add(SqliteCreatedEvent(event.model));
      return;
    }
    if (event.action == DatabaseCrudAction.update) {
      add(SqliteUpdatedEvent(event.model));
      return;
    }
    add(SqliteDeletedEvent(event.model));
  }

  FutureOr<void> _sqliteDeletedEventListener(
      SqliteDeletedEvent<Model> event, emit) {
    final list = state.list.toList();
    list.remove(event.model.result!);
    emit(SqliteReceiveState(list));
  }

  FutureOr<void> _sqliteUpdatedEventListener(
      SqliteUpdatedEvent<Model> event, emit) {
    final list = state.list.toList();
    final index = list.indexOf(event.model.result!);
    list[index] = event.model.result!;
    emit(SqliteReceiveState(list));
  }

  FutureOr<void> _sqliteCreatedEventListener(
    SqliteCreatedEvent<Model> event,
    emit,
  ) {
    final list = state.list.toList();

    list.add(event.model.result!);
    emit(SqliteReceiveState(list));
  }

  FutureOr<void> _sqliteGetEventListener(SqliteGetEvent<Model> _, emit) async {
    if (state is SqliteLoadingState || state is SqliteSoftLoadingState) {
      return;
    }
    final list = state.list.toList();

    if (list.isEmpty) {
      emit(SqliteLoadingState(list));
    } else {
      emit(SqliteSoftLoadingState(list));
    }
    final result = await repo.findModels(offset: currentOffset);

    logger.i("SqliteGetEvent Result: $result");
    if (result.hasError) {
      logger.e(
          "SqliteGetEvent Error: ${result.exception?.message} ${result.exception?.stackTrace}");
      emit(SqliteErrorState(
        list,
        result.toString(),
      ));
      return;
    }

    final incommingList = result.result ?? [];
    if (incommingList.isEmpty) {
      emit(SqliteReceiveState(list));
      return;
    }
    list.addAll(incommingList);
    currentOffset += incommingList.length;
    emit(SqliteReceiveState(list));
  }

  @override
  Future<void> close() async {
    await onChangeSubscription?.cancel();
    return super.close();
  }
}
