import 'package:inventory_management_with_sql/core/db/utils/dep.dart';
import 'package:inventory_management_with_sql/core/db/utils/sqlite_table_const.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_repo.dart';

class SqliteVariantOverviewUseCase {
  final SqliteVariantRepo repo;

  SqliteVariantOverviewUseCase({required this.repo});

  Future<String> getVariantName(int variantID) async {
    try {
      final result = await repo.database.rawQuery(
        """SELECT $optionTb.name as key, $attributeTb.name as value FROM $variantPropertiesTb
         JOIN $attributeTb ON $attributeTb.id=$variantPropertiesTb.value_id
         JOIN $optionTb ON $optionTb.id=$attributeTb.option_id
         where $variantPropertiesTb.variant_id=$variantID""",
      );
      logger.i("SqliteVariantOverviewUseCase: $variantID, $result");

      if (result.isEmpty) {
        return "";
      }

      return result.map((e) => "${e['key']}: ${e['value']}").join(", ");
    } catch (e) {
      logger.e("SqliteVariantOverviewUseCase: $e");
      return "";
    }
  }
}
