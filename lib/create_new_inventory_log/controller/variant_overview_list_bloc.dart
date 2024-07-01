import 'dart:async';

import 'package:inventory_management_with_sql/core/bloc/sqlite_read_bloc.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_event.dart';
import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_crud.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/variant_overview_list_event.dart';
import 'package:inventory_management_with_sql/create_new_inventory_log/controller/variant_overview_list_state.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_variant_overview_use_case.dart';

class VariantOverviewListBloc
    extends SqliteReadBloc<Variant, VariantParam, SqliteVariantRepo> {
  final int? selected;
  final SqliteVariantOverviewUseCase useCase;
  VariantOverviewListBloc(SqliteVariantRepo repo, [this.selected])
      : useCase = SqliteVariantOverviewUseCase(variantRepo: repo),
        super(repo, SqliteReadInitialState<Variant>(<Variant>[])) {
    on<VariantOverListLoadSelectedIDEvent>((event, emit) async {
      final variant = await repo.getOne(selected!);
      if (variant.hasError) {
        ///
        return;
      }
      variant.result!.name = await useCase.getVariantName(selected!);
      final list = state.list.toList();
      list.add(variant.result!);
      emit(VariantOverviewListLoadedState(list));
      add(SqliteGetEvent<Variant>());
    });

    if (selected != null) {
      add(const VariantOverListLoadSelectedIDEvent());
    }
  }

  @override
  Future<Result<Variant>> map(DatabaseCrudOnAction<Variant> event) async {
    if (event.model.hasError) {
      return event.model;
    }
    event.model.result!.name =
        await useCase.getVariantName(event.model.result!.id);
    return event.model;
  }

  @override
  FutureOr<Result<List<Variant>>> onRead() async {
    final result = await repo.findModels(offset: currentOffset, useRef: true);
    if (result.hasError) return result;

    for (final variant in result.result ?? <Variant>[]) {
      variant.name = await useCase.getVariantName(variant.id);
    }

    return result;
  }
}
