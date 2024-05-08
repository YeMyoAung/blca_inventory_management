import 'dart:async';

import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';

abstract class SqliteCreateUseCase<Model extends DatabaseModel,
    Param extends DatabaseParamModel> {
  const SqliteCreateUseCase();

  FutureOr<Result<Model>> create(Param param);
}
