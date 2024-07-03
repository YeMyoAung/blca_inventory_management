import 'dart:async';

import 'package:inventory_management_with_sql/core/db/impl/sqlite_use_case.dart';
import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_entity.dart';
import 'package:inventory_management_with_sql/repo/inventory_repo/inventory_repo.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';

const String SELL = "Sell",
    PURCHASE = "Purchase",
    DAMAGE = "Damage",
    LOST = "Lost";
final Map<
    String,
    Future<Result<Variant>> Function(
      SqliteVariantRepo repo,
      int variantID,
      double quantities,
    )> Reasons = {
  SELL: (
    repo,
    variantID,
    quantities,
  ) async {
    final result = await repo.getOne(variantID);

    if (result.hasError) {
      return result;
    }

    logger.i(result.result!.onHand);
    logger.i(result.result!.allowPurchaseWhenOutOfStock);

    if (result.result!.onHand < quantities &&
        !result.result!.allowPurchaseWhenOutOfStock) {
      return Result(exception: Error("Out of stock"));
    }

    // available-,onHand-
    return repo.update(
      variantID,
      VariantParam.toUpdate(
        available: result.result!.available + (quantities * -1),
        onHand: result.result!.onHand + (quantities * -1),
      ),
    );
  },
  PURCHASE: (
    repo,
    variantID,
    quantities,
  ) async {
    final result = await repo.getOne(variantID);

    if (result.hasError) {
      return result;
    }
    // available+,onHand+
    return repo.update(
      variantID,
      VariantParam.toUpdate(
        available: result.result!.available + quantities,
        onHand: result.result!.onHand + quantities,
      ),
    );
  },
  DAMAGE: (
    repo,
    variantID,
    quantities,
  ) async {
    final result = await repo.getOne(variantID);

    if (result.hasError) {
      return result;
    }

    if (result.result!.available < quantities &&
        !result.result!.allowPurchaseWhenOutOfStock) {
      return Result(exception: Error("Out of stock"));
    }
    // damage+,onHand-
    return repo.update(
      variantID,
      VariantParam.toUpdate(
        damage: result.result!.damage + quantities,
        onHand: result.result!.onHand + (quantities * -1),
      ),
    );
  },
  LOST: (
    repo,
    variantID,
    quantities,
  ) async {
    final result = await repo.getOne(variantID);

    if (result.hasError) {
      return result;
    }

    if (result.result!.available < quantities &&
        !result.result!.allowPurchaseWhenOutOfStock) {
      return Result(exception: Error("Out of stock"));
    }
    // lost+,onHand-
    return repo.update(
      variantID,
      VariantParam.toUpdate(
        available: result.result!.available + (quantities * -1),
        lost: result.result!.lost + quantities,
        onHand: result.result!.onHand + (quantities * -1),
      ),
    );
  },
};

class SqliteCreateNewInventoryLogUseCase
    extends SqliteExecuteUseCase<Inventory, InventoryParam> {
  final SqliteVariantRepo variantRepo;
  final SqliteInventoryRepo inventoryrepo;

  SqliteCreateNewInventoryLogUseCase({
    required this.inventoryrepo,
    required this.variantRepo,
  });

  @override
  FutureOr<Result<Inventory>> execute(InventoryParam param, [int? id]) async {
    final callback = Reasons[param.reason];
    if (callback == null) {
      return Result(exception: Error("Reason not found"));
    }
    final result = await inventoryrepo.create(param);
    if (result.hasError) {
      return result;
    }
    final record =
        await callback.call(variantRepo, param.variantID, param.quantity);
    if (record.hasError) {
      final deleteResult = await inventoryrepo.delete(result.result!.id);
      if (deleteResult.hasError) {
        return deleteResult;
      }
      return Result(exception: record.exception);
    }
    return result;
  }
}
