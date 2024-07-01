import 'package:inventory_management_with_sql/core/bloc/sqlite_create_event.dart';

class CreateNewInventoryLogSelectReasonEvent extends SqliteExecuteBaseEvent {
  final String value;
  const CreateNewInventoryLogSelectReasonEvent(this.value);
}

class CreateNewInventoryLogSelectVariantEvent extends SqliteExecuteBaseEvent {
  final int value;
  const CreateNewInventoryLogSelectVariantEvent(this.value);
}
