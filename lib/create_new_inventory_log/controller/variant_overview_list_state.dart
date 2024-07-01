import 'package:inventory_management_with_sql/core/bloc/sqlite_read_state.dart';
import 'package:inventory_management_with_sql/repo/variant_repo/variant_entity.dart';

class VariantOverviewListLoadingState extends SqliteReadState<Variant> {
  VariantOverviewListLoadingState(super.list);
}

class VariantOverviewListLoadedState extends SqliteReadState<Variant> {
  VariantOverviewListLoadedState(super.list);
}
