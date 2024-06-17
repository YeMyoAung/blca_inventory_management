import 'dart:async';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

abstract class SqliteExecuteUseCase<Model extends DatabaseModel,
    Param extends DatabaseParamModel> {
  const SqliteExecuteUseCase();

  FutureOr<Result<Model>> execute(Param param,[int? id]);
}
