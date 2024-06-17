import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';

class CreateNewProductCoverPhotoSelectedState extends SqliteExecuteBaseState {}
class CreateNewVariantProductCoverPhotoSelectedState extends SqliteExecuteBaseState {}

class CreateNewProductAvailableToSellWhenOutOfStockSelectedState
    extends SqliteExecuteBaseState {}

class CreateNewProductNewStockState extends SqliteExecuteBaseState {}

class CreateNewProductCategorySelectedState extends SqliteExecuteBaseState {}

class CreateNewProductSetPriceState extends SqliteExecuteBaseState {
  final int index;

  CreateNewProductSetPriceState({required this.index});
}
