import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';
import 'package:inventory_management_with_sql/repo/category_repo/category_entity.dart';

class CreateNewProductPickCoverPhotoEvent extends SqliteExecuteBaseEvent {
  const CreateNewProductPickCoverPhotoEvent();
}

class CreateNewVariantProductPickCoverPhotoEvent extends SqliteExecuteBaseEvent {
  const CreateNewVariantProductPickCoverPhotoEvent();
}

class CreateNewProductAvailabeToSellWhenOutOfStockEvent
    extends SqliteExecuteBaseEvent {
  final bool canSell;
  const CreateNewProductAvailabeToSellWhenOutOfStockEvent(this.canSell);
}

class CreateNewProducCategorySelectEvent extends SqliteExecuteBaseEvent {
  final Category category;
  const CreateNewProducCategorySelectEvent(this.category);
}

class CreateNewProductNewStockEvent extends SqliteExecuteBaseEvent {}

class CreateNewProductSetPriceEvent extends SqliteExecuteBaseEvent {
  final int index;

  CreateNewProductSetPriceEvent({required this.index});
}
