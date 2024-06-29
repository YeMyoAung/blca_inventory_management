import 'dart:async';

import 'package:inventory_management_with_sql/core/bloc/sqlite_read_bloc.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_crud.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_entity.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_repo.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_inventory_list_usecase.dart';

class InventoryListBloc
    extends SqliteReadBloc<Inventory, InventoryParam, SqliteInventoryRepo> {
  final SqliteInventoryListUseCase usecase;
  InventoryListBloc(super.repo)
      : usecase = SqliteInventoryListUseCase(repo: repo);

  @override
  Future<Result<Inventory>> map(
    DatabaseCrudOnAction<Inventory> event,
  ) async {
    if (event.model.hasError) {
      return event.model;
    }
    event.model.result!.variantName =
        await usecase.getVariantName(event.model.result!.variantID);
    return event.model;
  }

  @override
  FutureOr<Result<List<Inventory>>> onRead() async {
    final result = await repo.findModels(offset: currentOffset, useRef: true);

    if (result.hasError) return result;
    for (final log in result.result ?? <Inventory>[]) {
      log.variantName = await usecase.getVariantName(log.variantID);
    }
    return result;
  }
}
