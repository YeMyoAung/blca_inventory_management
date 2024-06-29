import 'package:inventory_management_with_sql/core/db/interface/database_model.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';

final Map<
    String,
    Future<Result<Variant>> Function(
      SqliteVariantRepo repo,
      int variantID,
      double quantities,
    )> Reasons = {
  "Sell": (
    repo,
    variantID,
    quantities,
  ) async {
    final result = await repo.getOne(variantID);

    if (result.hasError) {
      return result;
    }

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
  "Purchase": (
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
  "Damage": (
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
  "Lost": (
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
        lost: result.result!.lost + quantities,
        onHand: result.result!.onHand + (quantities * -1),
      ),
    );
  },
};

class CreateNewInventoryLogBloc {}
