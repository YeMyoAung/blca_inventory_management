import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';

class SqliteVariantOverviewUseCase {
  final SqliteVariantRepo variantRepo;

  SqliteVariantOverviewUseCase({
    required this.variantRepo,
  });

  Future<String> getVariantName(int variantID) async {
    try {
      final product = await variantRepo.database.rawQuery("""
        SELECT $productTb.name FROM $variantTb
        join $productTb on $productTb.id=$variantTb.product_id
        where $variantTb.id=?
      """, [variantID]);
      if (product.isEmpty) {
        return "";
      }
      final result = await variantRepo.database.rawQuery(
        """SELECT $optionTb.name as key, $attributeTb.name as value FROM $variantPropertiesTb
         JOIN $attributeTb ON $attributeTb.id=$variantPropertiesTb.value_id
         JOIN $optionTb ON $optionTb.id=$attributeTb.option_id
         where $variantPropertiesTb.variant_id=$variantID""",
      );
      logger.i("SqliteVariantOverviewUseCase: $variantID, $result");

      if (result.isEmpty) {
        return "${product[0]['name']}";
      }

      return "${product[0]['name']} (${result.map((e) => "${e['key']}: ${e['value']}").join(", ")})";
    } catch (e) {
      logger.e("SqliteVariantOverviewUseCase: $e");
      return "";
    }
  }
}
