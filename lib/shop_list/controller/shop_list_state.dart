import 'package:inventory_management_with_sql/core/bloc/bloc_state.dart';
import 'package:inventory_management_with_sql/repo/shop_repo/shop_entity.dart';

abstract class ShopListState extends BasicState {
  final List<Shop> list;

  ShopListState(this.list);
}

class ShopListInitialState extends ShopListState {
  ShopListInitialState([List<Shop> list = const []]) : super(list);
}

class ShopListLoadingState extends ShopListState {
  ShopListLoadingState(super.list);
}

class ShopListSoftLoadingState extends ShopListState {
  ShopListSoftLoadingState(super.list);
}

class ShopListReceiveState extends ShopListState {
  ShopListReceiveState(super.list);
}

class ShopListErrorState extends ShopListState {
  final String message;

  ShopListErrorState(super.list, this.message);
}
