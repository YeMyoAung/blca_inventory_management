import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/core/db/impl/sqlite_repo.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_crud.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/utils/debounce.dart';

abstract class SqliteReadBloc<Model extends DatabaseModel,
        Param extends DatabaseParamModel, Repo extends SqliteRepo<Model, Param>>
    extends Bloc<SqliteEvent<Model>, SqliteReadState<Model>> {
  final SearchController searchController = SearchController(
    duration: const Duration(milliseconds: 200),
  );

  StreamSubscription? onChangeSubscription;

  int currentOffset = 0;

  List<Model> _previousList = [];

  final Repo repo;
  SqliteReadBloc(
    this.repo,
    super.initialState,
  ) {
    searchController.stream.listen((event) {
      add(SqliteSearchEvent<Model>(value: event));
    });

    //on action
    onChangeSubscription = repo.onAction.listen(_repOnActionListener);

    ///Search Event
    on<SqliteSearchEvent<Model>>((event, emit) async {
      if (event.value.isEmpty) {
        emit(SqliteReceiveState<Model>(_previousList));
        _previousList = [];
        return;
      }
      if (_previousList.isEmpty) _previousList = state.list.toList();
      emit(SqliteSoftLoadingState<Model>(<Model>[]));
      final result = await onSearch(event.value);

      logger.i("SqliteSearchEvent Result: $result");
      if (result.hasError) {
        emit(SqliteReceiveState<Model>(<Model>[]));
        return;
      }

      
      emit(SqliteReceiveState<Model>(result.result!));
    });

    ///Get Event
    on<SqliteGetEvent<Model>>(_sqliteGetEventListener);

    ///Create Event
    on<SqliteCreatedEvent<Model>>(_sqliteCreatedEventListener);

    ///Update Event
    on<SqliteUpdatedEvent<Model>>(_sqliteUpdatedEventListener);

    ///Delete Event
    on<SqliteDeletedEvent<Model>>(_sqliteDeletedEventListener);

    logger.i("SqliteReadBloc $state ${state is! SqliteForceStopState<Model>}");

    if (state is! SqliteForceStopState<Model>) {
      add(SqliteGetEvent<Model>());
    }
  }

  Future<Result<Model>> map(DatabaseCrudOnAction<Model> event) async {
    return event.model;
  }

  void _repOnActionListener(DatabaseCrudOnAction<Model> event) async {
    if (event.action == DatabaseCrudAction.create) {
      final model = await map(event);
      add(SqliteCreatedEvent<Model>(model));
      return;
    }
    if (event.action == DatabaseCrudAction.update) {
      final model = await map(event);
      add(SqliteUpdatedEvent<Model>(model));
      return;
    }
    add(SqliteDeletedEvent<Model>(event.model));
  }

  FutureOr<void> _sqliteDeletedEventListener(
      SqliteDeletedEvent<Model> event, emit) {
    final list = state.list.toList();
    list.remove(event.model.result!);
    emit(SqliteReceiveState<Model>(list));
  }

  FutureOr<void> _sqliteUpdatedEventListener(
      SqliteUpdatedEvent<Model> event, emit) {
    final list = state.list.toList();
    final index = list.indexOf(event.model.result!);
    list[index] = event.model.result!;
    emit(SqliteReceiveState<Model>(list));
  }

  FutureOr<void> _sqliteCreatedEventListener(
    SqliteCreatedEvent<Model> event,
    emit,
  ) {
    final list = state.list.toList();

    list.add(event.model.result!);
    emit(SqliteReceiveState<Model>(list));
  }

  FutureOr<void> _sqliteGetEventListener(SqliteGetEvent<Model> _, emit) async {
    if (state is SqliteLoadingState<Model> ||
        state is SqliteSoftLoadingState<Model>) {
      return;
    }
    final list = state.list.toList();

    if (list.isEmpty) {
      emit(SqliteLoadingState<Model>(list));
    } else {
      emit(SqliteSoftLoadingState<Model>(list));
    }

    final result = await onRead();

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
      emit(SqliteReceiveState<Model>(list));
      return;
    }
    list.addAll(incommingList);
    currentOffset += incommingList.length;
    emit(SqliteReceiveState<Model>(list));
  }

  Future<Result<List<Model>>> onSearch(String value) {
    return repo.findModels();
  }

  FutureOr<Result<List<Model>>> onRead() {
    return repo.findModels(offset: currentOffset);
  }

  @override
  Future<void> close() async {
    await searchController.dispose();
    await onChangeSubscription?.cancel();
    return super.close();
  }
}
