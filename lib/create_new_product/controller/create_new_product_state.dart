import 'package:inventory_management_with_sql/core/bloc/sqlite_create_state.dart';

class CreateNewProductCoverPhotoSelectedState extends SqliteCreateBaseState {}

class CreateNewProductAvailableToSellWhenOutOfStockSelectedState
    extends SqliteCreateBaseState {}

class CreateNewProductNewStockState extends SqliteCreateBaseState {}

class CreateNewProductCategorySelectedState extends SqliteCreateBaseState {}

class CreateNewProductSetPriceState extends SqliteCreateBaseState {
  final int index;

  CreateNewProductSetPriceState({required this.index});
}
