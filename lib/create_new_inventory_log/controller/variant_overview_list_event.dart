import 'package:inventory_management_with_sql/core/bloc/sqlite_read_event.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';

class VariantOverListLoadSelectedIDEvent extends SqliteEvent<Variant> {
  const VariantOverListLoadSelectedIDEvent();
}
