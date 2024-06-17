import 'dart:async';

import 'package:inventory_management_with_sql/core/db/impl/sqlite_use_case.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_entity.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_repo.dart';

class SqliteShopCreateUseCase extends SqliteExecuteUseCase<Shop, ShopParam> {
  final SqliteShopRepo shopRepo;

  const SqliteShopCreateUseCase({required this.shopRepo});

  @override
  FutureOr<Result<Shop>> execute(ShopParam param, [int? id]) {
    if (id == null) {
      return shopRepo.create(param);
    }
    return shopRepo.update(id, param);
  }
}
