import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';

class CreateNewProductPickCoverPhotoEvent extends SqliteCreateBaseEvent {
  const CreateNewProductPickCoverPhotoEvent();
}

class CreateNewVariantProductPickCoverPhotoEvent extends SqliteCreateBaseEvent {
  const CreateNewVariantProductPickCoverPhotoEvent();
}

class CreateNewProductAvailabeToSellWhenOutOfStockEvent
    extends SqliteCreateBaseEvent {
  final bool canSell;
  const CreateNewProductAvailabeToSellWhenOutOfStockEvent(this.canSell);
}

class CreateNewProducCategorySelectEvent extends SqliteCreateBaseEvent {
  final Category category;
  const CreateNewProducCategorySelectEvent(this.category);
}

class CreateNewProductNewStockEvent extends SqliteCreateBaseEvent {}

class CreateNewProductSetPriceEvent extends SqliteCreateBaseEvent {
  final int index;

  CreateNewProductSetPriceEvent({required this.index});
}
