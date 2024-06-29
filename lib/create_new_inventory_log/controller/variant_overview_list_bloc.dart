import 'dart:async';

import 'package:inventory_management_with_sql/core/bloc/sqlite_read_bloc.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_crud.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';
import 'package:inventory_management_with_sql/use_case/sqlite_variant_overview_use_case.dart';

class VariantOverviewListBloc
    extends SqliteReadBloc<Variant, VariantParam, SqliteVariantRepo> {
  final SqliteVariantOverviewUseCase useCase;
  VariantOverviewListBloc(super.repo)
      : useCase = SqliteVariantOverviewUseCase(repo: repo);

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
