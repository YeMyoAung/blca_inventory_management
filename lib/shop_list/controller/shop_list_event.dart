import 'package:inventory_management_with_sql/repo/shop_repo/shop_entity.dart';

abstract class ShopListEvent {
  const ShopListEvent();
}

class ShopListGetEvent extends ShopListEvent {}

class ShopListCreatedEvent extends ShopListEvent {
  final Shop shop;

  const ShopListCreatedEvent(this.shop);
}

class ShopListUpdatedEvent extends ShopListEvent {
  final Shop shop;

  const ShopListUpdatedEvent(this.shop);
}

class ShopListDeletedEvent extends ShopListEvent {
  final Shop shop;
  const ShopListDeletedEvent(this.shop);
}
